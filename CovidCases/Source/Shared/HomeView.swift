//
//  HomeView.swift
//  CovidCases
//
//  Created by Imthath M on 07/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    let countryData = CountriesStore.data
    
    @ObservedObject var device: Device = Device.shared
    
    var body: some View {
//        systemTabView
        customTabView.accentColor(.pink)
    }
    
//    var systemTabView: some View {
//        TabView {
//            countryList
//                .tabItem { Image(systemName: "globe") }
//            statesList
//            .tabItem { Image(systemName: "mappin.and.ellipse") }
//            infoView
//            .tabItem { Image(systemName: "info.circle") }
//        }.edgesIgnoringSafeArea(.top).stacked(for: device)
//    }
    
    var customTabView: some View {
        UIKitTabView([
            UIKitTabView.Tab(view: countryList, image: "globe"),
            UIKitTabView.Tab(view: statesList, image: "mappin.and.ellipse"),
            UIKitTabView.Tab(view: infoView, image: "info.circle")
        ]).stacked(for: device)
    }
    
    var countryList: some View {
        NavigationView {
            CountryList(data: countryData)
            VStack {
                Text("COVID-19 Statistics - World").font(.largeTitle)
                MaxLocationDetail(location: countryData.global)
                Text("Swipe right from the left edge to see the list of locations")
                    .font(.footnote).foregroundColor(.secondary).padding(.bottom, .small)
            }
            
        }
    }
    
    var statesList: some View {
        NavigationView {
            INStatesList()
            VStack {
                Text("COVID-19 Statistics - India").font(.largeTitle)
                MaxLocationDetail(location: IndiaStore.india)
                Text("Swipe right from the left edge to see the list of states")
                    .font(.footnote).foregroundColor(.secondary).padding(.bottom, .small)
            }
        }
    }
    
    var infoView: some View {
//        NavigationView {
            InfoView()
//            Text("Stay Home. \nStay Safe. \nStay Healthy.").font(.title)
//        }
    }
}

struct NavView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Text("This page stays when you switch back and forth between tabs (as expected on iOS)")) {
                    Text("Go to detail")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
