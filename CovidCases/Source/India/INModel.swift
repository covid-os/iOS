//
//  IndiaModel.swift
//  CovidCases
//
//  Created by Imthath M on 06/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import Foundation

// MARK: - Welcome
class India: Codable {
//    let casesTimeSeries: [CasesTimeStamp]
//    let keyValues: [KeyValue]
    let states: [INState]
//    let tested: [Tested]

    enum CodingKeys: String, CodingKey {
//        case casesTimeSeries = "cases_time_series"
//        case keyValues = "key_values"
        case states = "statewise"
//        case tested
    }

    init(//casesTimeSeries: [CasesTimeStamp],// keyValues: [KeyValue],
        statewise: [INState]) {//, tested: [Tested]) {
//        self.casesTimeSeries = casesTimeSeries
//        self.keyValues = keyValues
        self.states = statewise
//        self.tested = tested
    }
    
    var total: INState { states.first(where: { $0.code == "TT" }) ?? IndiaStore.india }
    
    var exceptTotal: [INState] { states.filter({ $0.code != "TT" }) }
    
    var updateTime: Date { total.dateString.toDate(fromFormat: .indiaDateFormat)! }
}

// MARK: - CasesTimeSery
//class CasesTimeStamp: Codable {
//    let dailyconfirmed, dailydeceased, dailyrecovered, date: String
//    let totalconfirmed, totaldeceased, totalrecovered: String
//
//    init(dailyconfirmed: String, dailydeceased: String,
//         dailyrecovered: String, date: String, totalconfirmed: String, totaldeceased: String, totalrecovered: String) {
//        self.dailyconfirmed = dailyconfirmed
//        self.dailydeceased = dailydeceased
//        self.dailyrecovered = dailyrecovered
//        self.date = date
//        self.totalconfirmed = totalconfirmed
//        self.totaldeceased = totaldeceased
//        self.totalrecovered = totalrecovered
//    }
//}

// MARK: - KeyValue
//class KeyValue: Codable {
//    let confirmeddelta, counterforautotimeupdate, deceaseddelta, lastupdatedtime: String
//    let recovereddelta, statesdelta: String
//
//    init(confirmeddelta: String, counterforautotimeupdate: String,
//         deceaseddelta: String, lastupdatedtime: String, recovereddelta: String, statesdelta: String) {
//        self.confirmeddelta = confirmeddelta
//        self.counterforautotimeupdate = counterforautotimeupdate
//        self.deceaseddelta = deceaseddelta
//        self.lastupdatedtime = lastupdatedtime
//        self.recovereddelta = recovereddelta
//        self.statesdelta = statesdelta
//    }
//}

// MARK: - Statewise
class INState: Codable, MaxLocation {
    
    let active, confirmed, deaths: String
//    let delta: Delta
//    let deltaconfirmed, deltadeaths, deltarecovered: String
    let deltaconfirmed, deltadeaths: String
    let dateString: String
    let recovered, code: String
    var name: String

    enum CodingKeys: String, CodingKey {
        case name = "state"
        case code = "statecode"
        case dateString = "lastupdatedtime"
        case active, confirmed, recovered, deaths
        case deltaconfirmed, deltadeaths
//        case activeCases = "active"
//        case totalCases = "confirmed"
//        case totalDeaths = "deaths"
//        case recoveredCases = "recovered"
    }
    
    // Location protocol confirmation
    var activeCases: Int { active.number }
    var totalCases: Int { confirmed.number }
    var recoveredCases: Int { recovered.number }
    var totalDeaths: Int { deaths.number }
    
    var recentCases: Int { deltaconfirmed.number }
    var recentDeaths: Int { deltadeaths.number }
    var updatedTime: Date? { dateString.toDate(fromFormat: .indiaDateFormat) }
    
    init(active: String, confirmed: String, deaths: String, //delta: Delta,
         deltaconfirmed: String, deltadeaths: String, //deltarecovered: String,
         dateString: String, recovered: String, name: String, code: String) {
        self.active = active
        self.confirmed = confirmed
        self.deaths = deaths
//        self.delta = delta
        self.deltaconfirmed = deltaconfirmed
        self.deltadeaths = deltadeaths
//        self.deltarecovered = deltarecovered
        self.dateString = dateString
        self.recovered = recovered
        self.name = name
        self.code = code
    }
}

//// MARK: - Delta
//class Delta: Codable {
//    let active, confirmed, deaths, recovered: Int
//
//    init(active: Int, confirmed: Int, deaths: Int, recovered: Int) {
//        self.active = active
//        self.confirmed = confirmed
//        self.deaths = deaths
//        self.recovered = recovered
//    }
//}

// MARK: - Tested
//class Tested: Codable {
//    let source: String
//    let testsconductedbyprivatelabs, totalindividualstested, totalpositivecases, totalsamplestested: String
//    let updatetimestamp: String
//
//    init(source: String, testsconductedbyprivatelabs: String,
//         totalindividualstested: String, totalpositivecases: String,
//         totalsamplestested: String, updatetimestamp: String) {
//        self.source = source
//        self.testsconductedbyprivatelabs = testsconductedbyprivatelabs
//        self.totalindividualstested = totalindividualstested
//        self.totalpositivecases = totalpositivecases
//        self.totalsamplestested = totalsamplestested
//        self.updatetimestamp = updatetimestamp
//    }
//}

// MARK: - StateDatum
class INStateDatum: Codable {
    let name: String
    let districts: [INDistrict]

    init(state: String, districtData: [INDistrict]) {
        self.name = state
        self.districts = districtData
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "state"
        case districts = "districtData"
    }
}

// MARK: - DistrictDatum
class INDistrict: Codable {
    let name: String
    let confirmed: Int
    let date: String
    let delta: Delta

    init(district: String, confirmed: Int, lastupdatedtime: String, delta: Delta) {
        self.name = district
        self.confirmed = confirmed
        self.date = lastupdatedtime
        self.delta = delta
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "district"
        case confirmed
        case date = "lastupdatedtime"
        case delta
    }
    
    var recent: Int { delta.confirmed }
}

class Delta: Codable {
    let confirmed: Int

    init(confirmed: Int) {
        self.confirmed = confirmed
    }
}

//typealias INStateData = [INStateDatum]

class IndiaStore {
    
    static var savedInDocs: India? {
        return FileIO.shared.getOjbectFromFile(named: "india-store", withType: .json)
    }
    
    static func save(_ data: India) {
        FileIO.shared.save(data, to: "india-store", as: .json)
    }
    
    static var loadedFromBundle: India {
        return FileIO.shared.getBundledObject(inFile: "india_data", ofType: .json)!
    }
    
    static var allData: India {
        
        let data = IndiaStore.savedInDocs ?? IndiaStore.loadedFromBundle
        
        if let home = data.states.first(where: { $0.code == "TT" }) {
            home.name = "India"
            india = home
            if let updatedTime = home.dateString.toDate(fromFormat: .indiaDateFormat) {
                Defaults.indiaUpdatedTime = updatedTime
            }
            
        }

        return data
    }
    
    static var savedStatesInDocs: [INStateDatum]? {
        return FileIO.shared.getOjbectFromFile(named: "india-district-store", withType: .json)
    }
    
    static func saveStates(_ data: [INStateDatum]) {
        FileIO.shared.save(data, to: "india-district-store", as: .json)
    }
    
    static var loadedStatesFromBundle: [INStateDatum] {
        return FileIO.shared.getBundledObject(inFile: "india_district", ofType: .json)!
    }
    
    static var stateData: [INStateDatum] {
        return savedStatesInDocs ?? loadedStatesFromBundle
    }
    
    // TODO: update before release
    static var india = INState(active: "4464", confirmed: "5247", deaths: "150",
                               deltaconfirmed: "542", deltadeaths: "532",
                               dateString: "07/04/2020 21:53:25", recovered: "433",
                               name: "India", code: "TT")
    
    static var initialStates: [INState] {
        return IndiaStore.allData.states.filter({ $0.code != "TT" })
    }
    
    static func getDistricts(forState state: String) -> [INDistrict] {
        stateData.first(where: { $0.name == state })?
            .districts
            .sorted(by: { $0.confirmed > $1.confirmed }) ?? []
    }
}
