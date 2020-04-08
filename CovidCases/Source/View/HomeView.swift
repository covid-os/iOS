//
//  HomeView.swift
//  CovidCases
//
//  Created by Imthath M on 07/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    
    @ObservedObject var device: Device = Device.shared
    
    var body: some View {
//        NavigationView {
            TabView {
                NavigationView {
                    CountryList()
                    }
                
//                .navigationBarTitle("COVID-19 Statistics", displayMode: .inline)
                    .tabItem { Image(systemName: "globe") }
                NavigationView {
                    INStatesList()
                }
                    .tabItem { Image(systemName: "mappin.and.ellipse") }
                NavigationView {
                    Text("Info")
                }
                    .tabItem { Image(systemName: "info.circle") }
            }.edgesIgnoringSafeArea(.top).stacked(for: device)
//        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
