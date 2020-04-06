//
//  ContentView.swift
//  CovidCases
//
//  Created by Imthath M on 03/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI
import MINetworkKit

struct ContentView: View {
    
    let getStates = GetObject<India>()
    
    var body: some View {
        CountryList()
//        CountryDetail(country: Model.country)
//        Text("India").onAppear(perform: updateStates)
    }
    
    func updateStates() {
        getStates.execute(CIRequest.allData) { result in
            switch result {
            case .success(let india):
                print(india.statewise.count)
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
