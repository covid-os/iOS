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
    @State private var storedCountries: [Country] = Self.filteredCountries
    @State private var searchText: String = ""
    @State private var sortedBy: LocationSorter = .total
    
    static var filteredCountries: [Country] {
        var set = Set<String>()
        return CountriesStore.data.countries
        .filter({ $0.totalCases > 0 && set.insert($0.slug).0 })
    }
    
    var getCountries = GetObject<CountryData>()
    
    var body: some View {
        myView
    }
    
    var myView: some View {
      if device.orientation == .portrait || UIDevice.current.userInterfaceIdiom == .phone {
          return AnyView(navView.navigationViewStyle(StackNavigationViewStyle()))
      } else {
          return AnyView(navView.navigationViewStyle(DoubleColumnNavigationViewStyle()))
      }
    }
    
    var navView: some View {
        NavigationView {
            viewStack
                .onAppear(perform: autoUpdateCountries)
                .navigationBarTitle("COVID-19 Statistics", displayMode: .inline)
                .navigationBarItems(trailing: imageButton(withName: "arrow.2.circlepath.circle.fill",
                                                          andAction: updateCountries))
        }
    }
    
    var viewStack: some View {
        let binding = Binding<String>(
            get: { self.searchText },
            set: { self.searchText = $0; self.filterCountries() }
        )
        
        return ZStack {
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
                SearchField(searchText: binding).padding(.bottom, .small)
                listView
            }
        }
    }
    
    private var listView: some View {
        List {
            section
        }
        .listRowInsets(EdgeInsets(top: .small, leading: .small, bottom: .small, trailing: .zero))
        .introspectTableView { tableView in
            tableView.tableFooterView = UIView()
            tableView.keyboardDismissMode = .onDrag
        }
    }
    
    fileprivate var section: some View {
        Section(header: sectionHeader.frame(height: .averageTouchSize)) {
            ForEach(displayedCountries, id: \.code) { country in
                NavigationLink(destination: CountryDetail(country: country)) {
                    LocationRow(location: country)
                }
            }
        }
    }
    
    fileprivate var sectionHeader: some View {
        LocationHeader(currentSorter: $sortedBy, locations: $displayedCountries)
    }
    
//    func setColors(to navigationBar: UINavigationBar) {
//        let appearance = UINavigationBarAppearance()
//        appearance.shadowColor = .clear
//        appearance.backgroundColor = .systemBackground
//        navigationBar.standardAppearance = appearance
//        navigationBar.compactAppearance = appearance
//        navigationBar.scrollEdgeAppearance = appearance
//    }
    
    func autoUpdateCountries() {
        if displayedCountries.isEmpty {
            Console.shared.log("showing data for the first time")
            self.filterCountries()
        }
        
        if let updatedTime = Defaults.updatedTime,
            Date().timeIntervalSince(updatedTime) < 1799 {
            return
        }
                
        updateCountries()
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
struct CountryList_Previews: PreviewProvider {
    static var previews: some View {
        CountryList().sectionHeader
//        LocationRow(country: Model.country)
    }
}
