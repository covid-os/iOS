//
//  INStatesList.swift
//  CovidCases
//
//  Created by Imthath M on 07/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI
import MINetworkKit

struct INStatesList: View {
    @State private var displayedCountries: [INState] = []
    @State private var storedCountries: [INState] = IndiaStore.allData.exceptTotal
    @State private var searchText: String = ""
    @State private var sortedBy: LocationSorter = .total
    @State var home: INState = IndiaStore.india
    
    let getDistricts = GetObject<[INStateDatum]>()
    let getStates = GetObject<India>()
    
    var body: some View {
        LocationList(home: $home, searchText: $searchText,
                     displayedLocations: $displayedCountries, sortedBy: $sortedBy,
                     updateInterval: Defaults.indiaUpdateInterval,
                     updateLocations: updateStates, filterLocations: filterStates)
                     .navigationBarTitle("COVID-19 Statistics - India", displayMode: .inline)
    }
    
    func updateStates() {
        Console.shared.log("making API requst - IN all data")
        getStates.execute(INRequest.allData) { result in
            switch result {
            case .success(let data):
                Console.shared.log("API requst success")
                
                let updateTime = data.updateTime
                self.home = data.total
                IndiaStore.india = self.home
                guard updateTime != Defaults.indiaUpdatedTime else { return }
                Defaults.indiaUpdatedTime = updateTime
                
                IndiaStore.save(data)
                self.storedCountries = data.exceptTotal
                self.filterStates()
            case .failure(let error):
                "\(error)".log()
            }
        }
        
        getDistricts.execute(INRequest.district) { result in
            switch result {
            case .success(let states):
                IndiaStore.saveStates(states)
            case .failure(let error):
                "\(error)".log()
            }
        }
    }
    
    func filterStates() {
        guard !self.searchText.isEmpty else {
            self.displayedCountries = self.storedCountries.sorted(by: self.sortedBy)
            return
        }
        
        self.displayedCountries = self.storedCountries
            .filter({ $0.name.localizedCaseInsensitiveContains(self.searchText)})
            .sorted(by: self.sortedBy)
    }
}

struct INStatesList_Previews: PreviewProvider {
    static var previews: some View {
        INStatesList()
    }
}
