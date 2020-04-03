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
                slug: UUID().uuidString,// ["in", "us", "uk", "au"].randomElement()!,
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
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case countries = "Countries"
        case date = "Date"
    }
    
    init(countries: [Country], date: String) {
        self.countries = countries
        self.date = date
    }
}

// MARK: - Country
class Country: Codable {
    let name, slug: String
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int
    let newRecovered, totalRecovered: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "Country"
        case slug = "Slug"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
    }
    
    init(country: String, slug: String, newConfirmed: Int,
         totalConfirmed: Int, newDeaths: Int, totalDeaths: Int,
         newRecovered: Int, totalRecovered: Int) {
        self.name = country
        self.slug = slug
        self.newConfirmed = newConfirmed
        self.totalConfirmed = totalConfirmed
        self.newDeaths = newDeaths
        self.totalDeaths = totalDeaths
        self.newRecovered = newRecovered
        self.totalRecovered = totalRecovered
    }
    
    var activeCases: Int { totalConfirmed - totalRecovered - totalDeaths }
    //    var newActiveCases: Int { newConfirmed  - newRecovered - newDeaths }
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
