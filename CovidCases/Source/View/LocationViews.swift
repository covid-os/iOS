//
//  LocationViews.swift
//  CovidCases
//
//  Created by Imthath M on 07/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI

struct LocationList<T: Location>: View {
    
    @Binding var home: T
    @Binding var searchText: String
    @Binding var displayedLocations: [T]
    @Binding var sortedBy: LocationSorter
    
    let updateLocations: () -> Void
    let filterLocations: () -> Void
    
    @ObservedObject var device: Device = Device.shared
    
    var tempLocations: [T] { [home] + displayedLocations }
    
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
        //        NavigationView {
        viewStack
            .onAppear(perform: autoUpdateCountries)
            .navigationBarTitle("COVID-19 Statistics", displayMode: .inline)
            .navigationBarItems(trailing: imageButton(withName: "arrow.2.circlepath.circle.fill",
                                                      andAction: updateLocations))
        //        }
    }
    
    var viewStack: some View {
        let binding = Binding<String>(
            get: { self.searchText },
            set: { self.searchText = $0; self.filterLocations() }
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
            ForEach(tempLocations, id: \.code) { location in
                NavigationLink(destination: self.getDetailView(for: location)) {
                    LocationRow(location: location)
                }
            }
        }
    }
    
    func getDetailView(for location: Location) -> some View{
        if let country = location as? Country {
            return AnyView(CountryDetail(country: country))
        }
        
        return AnyView(LocationDetail(location: location))
    }
    
    fileprivate var sectionHeader: some View {
        LocationHeader(currentSorter: $sortedBy, locations: $displayedLocations)
    }
    
    func autoUpdateCountries() {
        if displayedLocations.isEmpty {
            Console.shared.log("showing data for the first time")
            self.filterLocations()
        }
        
        if let updatedTime = Defaults.updatedTime,
            Date().timeIntervalSince(updatedTime) < 1799 {
            return
        }
        
        updateLocations()
    }
}

struct LocationDetail: View {
    let location: Location
    
    var body: some View {
        detailListView
            .navigationBarTitle(location.name)
    }
    
    fileprivate var detailListView: some View {
        List {
            Section(header: topHeader.frame(height: .averageTouchSize * 2), content: {
                ItemRow(title: "Active cases", count: location.activeCases,
                        color: .orange, percentage: location.activePercent)
            })
            ItemSection(title: "Recovered", count: location.recoveredCases,
                        color: .green, percentage: location.recoveredPercent)
            ItemSection(title: "Total Deaths", count: location.totalDeaths,
                        color: .red, percentage: location.diedPercent)
            Section(header: footer.frame(height: .averageTouchSize * 4), content: { EmptyView() })
        }
        .listRowInsets(EdgeInsets(top: .medium, leading: .large, bottom: .medium, trailing: .large))
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
    
    private var topHeader: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Text("Total cases - \(self.location.totalCases)")
                    .frame(width: geometry.width)
            }
            .font(.title)
            .foregroundColor(.primary)
        }
        
    }
    
    private var footer: some View {
        GeometryReader { geometry in
            VStack(spacing: .medium) {
                Text("App logo from CDC on Unspash")
                Text("Tweet to the developer @imthath_m")
                Text("Open sourced at github.com/covid-os/iOS")
            }.frame(width: geometry.width)
        }
    }
}

struct LocationHeader<T: Location>: View {
    @Binding var currentSorter: LocationSorter
    @Binding var locations: [T]
    //    var sortLocations: (LocationSorter) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: .zero) {
                self.sortButton(for: .name, title: "LOCATION (\(self.locations.count))")
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
    
    func sortButton(for sorter: LocationSorter, title: String) -> some View {
        Button(action: {
            self.sortLocations(basedOn: sorter)
        }, label: {
            Text(title)
                .font(.custom("Gill Sans", size: .small * 1.5))
                .foregroundColor(currentSorter == sorter ? .blue : .primary)
        })
        
    }
    
    func sortLocations(basedOn sorter: LocationSorter) {
        if self.currentSorter == sorter {
            self.locations.reverse()
        } else {
            self.currentSorter = sorter
            self.locations.sort(by: sorter)
        }
    }
}

struct LocationRow: View {
    let location: Location
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: .zero) {
                HStack {
                    Text(self.location.name)
                    Spacer()
                }
                .frame(width: geometry.width * 0.4)
                Text(self.location.totalCases.formatted)
                    .frame(width: geometry.width * 0.2)
                Text(self.location.activeCases.formatted)
                    .frame(width: geometry.width * 0.2)
                Text(self.location.recoveredCases.formatted)
                    .frame(width: geometry.width * 0.2)
            }
        }
    }
}

extension Array where Element: Location {
    func sorted(by sorter: LocationSorter) -> [Element] {
        switch sorter {
        case .name:
            return sorted(by: { $0.name < $1.name })
        case .total:
            return sorted(by: { $0.totalCases > $1.totalCases })
        case .active:
            return sorted(by: { $0.activeCases > $1.activeCases })
        case .recovered:
            return sorted(by: { $0.recoveredCases > $1.recoveredCases })
        }
    }
    
    mutating func sort(by sorter: LocationSorter) {
        self = sorted(by: sorter)
    }
}

//struct LocationViews_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationHeader()
//    }
//}
