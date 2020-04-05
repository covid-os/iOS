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
    @State private var sortedBy: CountrySort = .recovered
    
    static var filteredCountries: [Country] {
        var set = Set<String>()
        return CountriesStore.data.countries
        .filter({ $0.totalConfirmed > 0 && set.insert($0.slug).0 })
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
                .onAppear(perform: updateCountries)
                .navigationBarTitle("COVID-19 Statistics", displayMode: .inline)
                .navigationBarItems(trailing: imageButton(withName: "arrow.2.circlepath.circle.fill", andAction: updateCountries))
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
                    CountryRow(country: country)
                }
            }
        }
    }
    
    fileprivate var sectionHeader: some View {
        GeometryReader { geometry in
            HStack(spacing: .zero) {
                self.sortButton(for: .name, title: "LOCATION (\(self.displayedCountries.count))")
                    .frame(width: geometry.width * 0.4)
                self.sortButton(for: .total, title: "TOTAL")
                    .frame(width: geometry.width * 0.2)
                self.sortButton(for: .active, title: "ACTIVE")
                    .frame(width: geometry.width * 0.2)
                self.sortButton(for: .recovered, title: "RECOVERED")
                    .frame(width: geometry.width * 0.2, height: .averageTouchSize)
            }
            .frame(height: .averageTouchSize * 1.5)
        }
    }
    
    func sortButton(for sorter: CountrySort, title: String) -> some View {
        Button(action: {
            if self.sortedBy == sorter {
                self.displayedCountries.reverse()
            } else {
                self.sortedBy = sorter
                self.displayedCountries.sort(by: sorter)
            }
        }, label: {
            Text(title)
                .font(.footnote)
//                .font(.custom("Gill Sans", size: .small * 1.5))
                .foregroundColor(sortedBy == sorter ? .blue : .primary)
        })
        
    }
    
//    func setColors(to navigationBar: UINavigationBar) {
//        let appearance = UINavigationBarAppearance()
//        appearance.shadowColor = .clear
//        appearance.backgroundColor = .systemBackground
//        navigationBar.standardAppearance = appearance
//        navigationBar.compactAppearance = appearance
//        navigationBar.scrollEdgeAppearance = appearance
//    }
    
    func updateCountries() {
        if displayedCountries.isEmpty {
            Console.shared.log("showing data for the first time")
            self.filterCountries()
        }
        
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
                    .filter({ $0.totalConfirmed > 0 && set.insert($0.slug).0 })
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

enum CountrySort {
    case name
    case total
    case active
    case recovered
}

extension Array where Element == Country {
    func sorted(by sorter: CountrySort) -> [Element] {
        switch sorter {
        case .name:
            return sorted(by: { $0.name < $1.name })
        case .total:
            return sorted(by: { $0.totalConfirmed > $1.totalConfirmed })
        case .active:
            return sorted(by: { $0.activeCases > $1.activeCases })
        case .recovered:
            return sorted(by: { $0.totalRecovered > $1.totalRecovered })
        }
    }
    
    mutating func sort(by sorter: CountrySort) {
        self = sorted(by: sorter)
    }
}

extension Array where Element: Hashable {
    var uniqueElements: [Element] {
        var set = Set<Element>()

        return filter { set.insert($0).0 }
    }

    mutating func removeDuplicates() {
        self = self.uniqueElements
    }
}


struct CountryRow: View {
    let country: Country
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: .zero) {
                HStack {
                    Text(self.country.name)
                    Spacer()
                }
                .frame(width: geometry.width * 0.4)
                Text(self.country.totalConfirmed.formatted)
                    .frame(width: geometry.width * 0.2)
                Text(self.country.activeCases.formatted)
                    .frame(width: geometry.width * 0.2)
                Text(self.country.totalRecovered.formatted)
                    .frame(width: geometry.width * 0.2)
            }
        }
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
//        CountryRow(country: Model.country)
    }
}

public struct SearchField: View {
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false

    public init(searchText: Binding<String>) {
        self._searchText = searchText
    }
    
    public var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                }).foregroundColor(.primary)

                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: .small, leading: .small * 0.75, bottom: .small, trailing: .small * 0.75))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(.small)

            if showCancelButton  {
                Button("Cancel") {
                        UIApplication.dismissKeyboard() // this must be placed before the other commands here
                        self.searchText = ""
                        self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
                .animation(.easeInOut)
            }
        }
        .animation(.easeInOut)
        .padding(.horizontal)
    }
}
