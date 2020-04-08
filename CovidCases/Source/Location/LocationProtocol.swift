//
//  LocationProtocol.swift
//  CovidCases
//
//  Created by Imthath M on 07/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import Foundation

protocol Location {
    var name: String { get }
    var code: String { get }
    
    var totalCases: Int { get }
    var activeCases: Int { get }
    var recoveredCases: Int { get }
    var totalDeaths: Int { get }
}

extension Location {
    
    var activePercent: String { getPercent(of: activeCases) }
    var recoveredPercent: String { getPercent(of: recoveredCases) }
    var diedPercent: String { getPercent(of: totalDeaths) }
    
    func getPercent(of count: Int) -> String {
        guard totalCases > 0 else { return "" }
        
        let percent = Double(count) / Double(totalCases)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter.string(from: NSNumber(value: percent)) ?? String(format: "%.2f%%", percent)
    }
}

// conform to this protocol if the location has all the required properties
protocol MaxLocation: Location {
    var recentCases: Int { get }
    var recentDeaths: Int { get }
    var updatedTime: Date? { get }
}

extension MaxLocation {
    var recentCasesPercent: String { getPercent(of: recentCases) }
    var recentDeathsPercent: String { getPercent(of: recentDeaths) }
    
    var displayUpdateTime: String {
        if let time = updatedTime {
            return "Last updated: " + time.toString(inFormat: .displayDateFormat)
        }
        
        return ""
    }
}

enum LocationSorter {
    case name
    case total
    case active
    case recovered
}
