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
    let statewise: [Statewise]
//    let tested: [Tested]

    enum CodingKeys: String, CodingKey {
//        case casesTimeSeries = "cases_time_series"
//        case keyValues = "key_values"
        case statewise
//        case tested
    }

    init(//casesTimeSeries: [CasesTimeStamp],// keyValues: [KeyValue],
        statewise: [Statewise]) {//, tested: [Tested]) {
//        self.casesTimeSeries = casesTimeSeries
//        self.keyValues = keyValues
        self.statewise = statewise
//        self.tested = tested
    }
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
class Statewise: Codable, Location {
    let active, confirmed, deaths: String
//    let delta: Delta
//    let deltaconfirmed, deltadeaths, deltarecovered: String
    let dateString: String
    let recovered, name, code: String

    enum CodingKeys: String, CodingKey {
        case name = "state"
        case code = "statecode"
        case dateString = "lastupdatedtime"
        case active, confirmed, recovered, deaths
//        case activeCases = "active"
//        case totalCases = "confirmed"
//        case totalDeaths = "deaths"
//        case recoveredCases = "recovered"
    }
    
    // Location protocol confirmation
    var activeCases: Int { active.number }
    var totalCases: Int { confirmed.number }
    var recoveredCases: Int { recovered.number }
    
    init(active: String, confirmed: String, deaths: String, //delta: Delta,
//         deltaconfirmed: String, deltadeaths: String, deltarecovered: String,
         dateString: String, recovered: String, name: String, code: String) {
        self.active = active
        self.confirmed = confirmed
        self.deaths = deaths
//        self.delta = delta
//        self.deltaconfirmed = deltaconfirmed
//        self.deltadeaths = deltadeaths
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
class StateDatum: Codable {
    let state: String
    let districtData: [DistrictDatum]

    init(state: String, districtData: [DistrictDatum]) {
        self.state = state
        self.districtData = districtData
    }
}

// MARK: - DistrictDatum
class DistrictDatum: Codable {
    let district: String
    let confirmed: Int
    let lastupdatedtime: String
//    let delta: Delta

    init(district: String, confirmed: Int, lastupdatedtime: String) {//, delta: Delta) {
        self.district = district
        self.confirmed = confirmed
        self.lastupdatedtime = lastupdatedtime
//        self.delta = delta
    }
}

// MARK: - Delta
//class Delta: Codable {
//    let confirmed: Int
//
//    init(confirmed: Int) {
//        self.confirmed = confirmed
//    }
//}

typealias StateData = [StateDatum]
