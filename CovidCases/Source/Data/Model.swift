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
    let global: Global
    let countries: [Country]
    let dateString: String
    
    enum CodingKeys: String, CodingKey {
        case global = "Global"
        case countries = "Countries"
        case dateString = "Date"
    }

    init(global: Global, countries: [Country], date: String) {
        self.global = global
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

class Global: Codable, Location {
    var name: String { "World "}
    
    var code: String { "homeLocation" }
    
    
    var newConfirmed, totalCases, newDeaths, totalDeaths: Int
    var newRecovered, recoveredCases: Int

    enum CodingKeys: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalCases = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case recoveredCases = "TotalRecovered"
    }

    init(newConfirmed: Int, totalConfirmed: Int, newDeaths: Int, totalDeaths: Int, newRecovered: Int, totalRecovered: Int) {
        self.newConfirmed = newConfirmed
        self.totalCases = totalConfirmed
        self.newDeaths = newDeaths
        self.totalDeaths = totalDeaths
        self.newRecovered = newRecovered
        self.recoveredCases = totalRecovered
    }
    
    var activeCases: Int { totalCases - recoveredCases }
    
    var asCountry: Country {
        Country(country: "World", slug: "world", code: "globe", dateString: "", newConfirmed: self.newConfirmed,
                totalConfirmed: self.totalCases, newDeaths: self.newDeaths, totalDeaths: self.totalDeaths,
                newRecovered: self.newRecovered, totalRecovered: self.recoveredCases)
    }
}

// MARK: - Country
class Country: Codable, Location {
    let name, slug, code, dateString: String
    let newConfirmed, totalCases, newDeaths, totalDeaths: Int
    let newRecovered, recoveredCases: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "Country"
        case slug = "Slug"
        case code = "CountryCode"
        case dateString = "Date"
        case newConfirmed = "NewConfirmed"
        case totalCases = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case recoveredCases = "TotalRecovered"
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
        self.totalCases = totalConfirmed
        self.newDeaths = newDeaths
        self.totalDeaths = totalDeaths
        self.newRecovered = newRecovered
        self.recoveredCases = totalRecovered
    }
    
    var activeCases: Int { totalCases - recoveredCases - totalDeaths }
    //    var newActiveCases: Int { newConfirmed  - newRecovered - newDeaths }
    
    var newCasesPercent: String { getPercent(of: newConfirmed) }
//    var newRecoveredPercent: String { getPercent(of: newRecovered) }
    var newDeathsPercent: String { getPercent(of: newDeaths) }
    
}

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
            world = data.global
            return data
        }
        
        let data = CountriesStore.loadedFromBundle
        
        data.updateTime()

        world = data.global
        return data
    }
    
    static var world = Global(newConfirmed: 106598, totalConfirmed: 1252421, newDeaths: 5972,
                              totalDeaths: 67572, newRecovered: 28514, totalRecovered: 259047)
    
    static var initialCountries: [Country] {
        var set = Set<String>()
        return CountriesStore.data.countries
        .filter({ $0.totalCases > 0 && set.insert($0.slug).0 })
    }
}
