//
//  Model.swift
//  CovidCases
//
//  Created by Imthath M on 03/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import Foundation

class Model {
    
    static var country: Country {
        Country(country: ["India", "America", "United Kindgon", "Australia"].randomElement()!,
                slug: UUID().uuidString,
                code: ["in", "us", "uk", "au"].randomElement()!,
                dateString: "2020-04-05T03:24:27Z",
            newConfirmed: Int.random(in: 10...1000),
            totalConfirmed: Int.random(in: 10000...80000),
            newDeaths: Int.random(in: 0...100),
            totalDeaths: Int.random(in: 0...2000),
            newRecovered: Int.random(in: 1000...5000),
            totalRecovered: Int.random(in: 0...100000))
    }
    
    static func countries(count: Int) -> [Country] {
        var result = [Country]()
        for _ in 0...count {
            result.append(country)
        }
        return result
    }
}

// MARK: - Welcome
class CountryData: Codable {
    let countries: [Country]
    let dateString: String
    
    enum CodingKeys: String, CodingKey {
        case countries = "Countries"
        case dateString = "Date"
    }
    
    init(countries: [Country], date: String) {
        self.countries = countries
        self.dateString = date
    }
    
    func updateTime() {
        if let time = lastUpdatedTime {
            Defaults.updatedTime = time
        }
    }
    
    var lastUpdatedTime: Date? { dateString.date }
}

// MARK: - Country
class Country: Codable {
    let name, slug, code, dateString: String
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int
    let newRecovered, totalRecovered: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "Country"
        case slug = "Slug"
        case code = "CountryCode"
        case dateString = "Date"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
    }
    
    init(country: String, slug: String, code: String,
         dateString: String, newConfirmed: Int,
         totalConfirmed: Int, newDeaths: Int, totalDeaths: Int,
         newRecovered: Int, totalRecovered: Int) {
        self.name = country
        self.slug = slug
        self.code = code
        self.dateString = dateString
        self.newConfirmed = newConfirmed
        self.totalConfirmed = totalConfirmed
        self.newDeaths = newDeaths
        self.totalDeaths = totalDeaths
        self.newRecovered = newRecovered
        self.totalRecovered = totalRecovered
    }
    
    var activeCases: Int { totalConfirmed - totalRecovered - totalDeaths }
    //    var newActiveCases: Int { newConfirmed  - newRecovered - newDeaths }
    
    var activePercentage: String { getPercent(of: activeCases) }
    var recoveredPercent: String { getPercent(of: totalRecovered) }
    var diedPercentage: String { getPercent(of: totalDeaths) }
    var newCasesPercent: String { getPercent(of: newConfirmed) }
    var newRecoveredPercent: String { getPercent(of: newRecovered) }
    var newDeathsPercent: String { getPercent(of: newDeaths) }
    
    func getPercent(of count: Int) -> String {
        let percent = Double(count) / Double(totalConfirmed)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter.string(from: NSNumber(value: percent)) ?? String(format: "%.2f%%", percent)
    }
}

//extension Country: Hashable {
//    
//    static func == (lhs: Country, rhs: Country) -> Bool {
//        lhs.slug == rhs.slug
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(slug)
//    }
//}

class CountriesStore {
    static var savedInDocs: CountryData? {
        return FileIO.shared.getOjbectFromFile(named: "covid-store", withType: .json)
    }
    
    static func save(_ data: CountryData) {
        FileIO.shared.save(data, to: "covid-store", as: .json)
    }
    
    static var loadedFromBundle: CountryData {
        return FileIO.shared.getBundledObject(inFile: "covid_countries_data", ofType: .json)!
    }
    
    static var data: CountryData {
        if let data = CountriesStore.savedInDocs {
            return data
        }
        
        let data = CountriesStore.loadedFromBundle
        
        data.updateTime()
        
        return data
    }
}
