//
//  CountryList.swift
//  CovidCases
//
//  Created by Imthath M on 03/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI
import SwiftyUserInterface
import MINetworkKit

struct CountryList: View {
    
    @State private var displayedCountries: [Country] = []
    @State private var storedCountries: [Country]// = CountriesStore.initialCountries
    @State private var searchText: String = ""
    @State private var sortedBy: LocationSorter = .total
    @State var world: Country// = CountriesStore.world.asCountry
    
    let getCountries = GetObject<CountryData>()
    
    init(data: CountryData) {
        _storedCountries = State(initialValue: data.initialCountries)
        _world = State(initialValue: data.global.asCountry)
    }
    
    var body: some View {
        LocationList(home: $world, searchText: $searchText,
                     displayedLocations: $displayedCountries, sortedBy: $sortedBy,
                     updateLocations: updateCountries, filterLocations: filterCountries)
                     .navigationBarTitle("COVID-19 Global Statistics", displayMode: .inline)
    }
    
    func updateCountries() {
        Console.shared.log("making API requst")
        getCountries.execute(CCRequest.countryList) { result in
            switch result {
            case .success(let data):
                Console.shared.log("API requst success")
                
                // TODO: the data conversion operation happens twice in this two lines. can remove once.
                guard data.lastUpdatedTime != Defaults.countriesUpdatedTime else { return }
                data.updateTime()
                self.world = data.global.asCountry
                CountriesStore.save(data)
                var set = Set<String>()
                self.storedCountries = data.countries
                    .filter({ $0.totalCases > 0 && set.insert($0.slug).0 })
                self.filterCountries()
            case .failure(let error):
                "\(error)".log()
            }
        }
    }
    
    func filterCountries() {
        guard !self.searchText.isEmpty else {
            self.displayedCountries = self.storedCountries.sorted(by: self.sortedBy)
            return
        }
        
        self.displayedCountries = self.storedCountries
            .filter({ $0.name.localizedCaseInsensitiveContains(self.searchText)})
            .sorted(by: self.sortedBy)
    }
}

struct CountryDetail: View {
    let country: Country
    var footerInfo: [String] = []
    
    var body: some View {
        MaxLocationDetail(location: country, footerInfo: ["Source: covid19api.com"])
    }
}

//struct CountryList_Previews: PreviewProvider {
//    static var previews: some View {
//        CountryList().sectionHeader
////        LocationRow(country: Model.country)
//    }
//}
