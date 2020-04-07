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
    
    @ObservedObject var device: Device = Device.shared
    
    @State private var displayedCountries: [Country] = []
    @State private var storedCountries: [Country] = CountriesStore.initialCountries
    @State private var searchText: String = ""
    @State private var sortedBy: LocationSorter = .total
    @State var world: Country = CountriesStore.world.asCountry
    
    let getCountries = GetObject<CountryData>()
    
    var body: some View {
        LocationList(home: $world, searchText: $searchText,
                     displayedLocations: $displayedCountries, sortedBy: $sortedBy,
                     updateLocations: updateCountries, filterLocations: filterCountries)
    }
    
    func updateCountries() {
        print("making API requst")
        getCountries.execute(CCRequest.countryList) { result in
            switch result {
            case .success(let data):
                print("API requst success")
                
                // TODO: the data conversion operation happens twice in this two lines. can remove once.
                guard data.lastUpdatedTime != Defaults.updatedTime else { return }
                data.updateTime()
                self.world = data.global.asCountry
                CountriesStore.save(data)
                var set = Set<String>()
                self.storedCountries = data.countries
                    .filter({ $0.totalCases > 0 && set.insert($0.slug).0 })
                self.filterCountries()
            case .failure(let error):
                print(error)
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

extension Int {
    var formatted: String {
        if self < 1000 { return "\(self)" }
        
        let thousands = Double(self)/1000
        
        if thousands < 1000 {
            return String(format: "%.1f", thousands) + " K"
        }
        
        return String(format: "%.1f", thousands/1000) + " M"
        
    }
}

//struct CountryList_Previews: PreviewProvider {
//    static var previews: some View {
//        CountryList().sectionHeader
////        LocationRow(country: Model.country)
//    }
//}
