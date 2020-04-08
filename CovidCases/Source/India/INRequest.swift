//
//  INRequest.swift
//  CovidCases
//
//  Created by Imthath M on 08/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import Foundation
import MINetworkKit

enum INRequest: MIRequest {
    case allData
    case district
    
    var baseURL: String {
        return "https://api.covid19india.org"
    }
    
    var urlPath: String {
        switch self {
        case .allData:
            return "/data.json"
        case .district:
            return "/v2/state_district_wise.json"
        }
    }
    
    var urlString: String {
        return baseURL + urlPath
    }
    
    var method: MINetworkMethod {
        switch self {
        case .allData, .district:
            return .get
        }
    }
    
    var params: [String : Any]? {
        switch self {
        case .allData, .district:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .allData, .district:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .allData, .district:
            return nil
        }
    }
    
    
}
