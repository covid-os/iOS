//
//  LocationViews.swift
//  CovidCases
//
//  Created by Imthath M on 07/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI

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

protocol Location {
    var name: String { get }
    var code: String { get }
    var totalCases: Int { get }
    var activeCases: Int { get }
    var recoveredCases: Int { get }
}

enum LocationSorter {
    case name
    case total
    case active
    case recovered
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
