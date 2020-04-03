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
    @State var countries: [Country] = []
    @State var searchText: String = ""
    @State var sortedBy: CountrySort = .total
    
    var getCountries = GetObject<CountryData>()
    
    var body: some View {
        NavigationView {
            listView
            .onAppear(perform: updateCountries)
            .navigationBarTitle("COVID-19 cases")
            .navigationBarItems(trailing: imageButton(withName: "arrow.2.circlepath.circle.fill", andAction: updateCountries))
        }
    }
    
    private var listView: some View {
        List {
//            SearchView(searchText: $searchText)
            section
        }.listRowInsets(EdgeInsets(top: .small, leading: .medium, bottom: .small, trailing: .small))
        .introspectTableView { tableView in
            if self.countries.isEmpty {
                let label = UILabel()
                label.text = "Loading..."
                tableView.tableFooterView = label
            } else {
                tableView.tableFooterView = UIView()
            }
            
        }
    }
    
    private var section: some View {
        Section(header: sectionHeader) {
            ForEach(countries, id: \.slug) { country in
                NavigationLink(destination: CountryDetail(country: country)) {
                    CountryRow(country: country)
                }
            }
        }
    }
    
    private var sectionHeader: some View {
        GeometryReader { geometry in
            HStack(spacing: .zero) {
                self.sortButton(for: .name, title: "Country")
                    .frame(width: geometry.width * 0.37)
                self.sortButton(for: .total, title: "Total")
                    .frame(width: geometry.width * 0.2)
                self.sortButton(for: .active, title: "Active")
                    .frame(width: geometry.width * 0.2)
                self.sortButton(for: .recovered, title: "Recovered")
                    .frame(width: geometry.width * 0.23)
            }
            .frame(height: .averageTouchSize * 1.5)
        }
    }
    
    func sortButton(for sorter: CountrySort, title: String) -> some View {
        Button(action: {
            self.sortedBy = sorter
            self.countries.sort(by: sorter)
        }, label: {
            HStack {
                Text(title)
                if sortedBy == sorter {
                    Image(systemName: "arrowtriangle.down.fill")
                }
            }
            .font(.footnote)
            .foregroundColor(.primary)
        })
        
    }
    
    func updateCountries() {
        getCountries.execute(CCRequest.countryList) { result in
            switch result {
            case .success(let data):
            var set = Set<String>()
            self.countries = data.countries
                .filter({ $0.totalConfirmed > 0 && set.insert($0.slug).0 })
                .sorted(by: self.sortedBy)
            case .failure(let error):
                print(error)
            }
        }
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
        //        Text("sgksj")
        GeometryReader { geometry in
            HStack(spacing: .zero) {
                HStack {
                    Text(self.country.name)//.padding(.leading)
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
        //        CountryList()
        CountryRow(country: Model.country)
    }
}
