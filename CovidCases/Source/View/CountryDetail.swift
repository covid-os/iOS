//
//  CountryDetail.swift
//  CovidCases
//
//  Created by Imthath M on 03/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI
import SwiftyUserInterface

struct CountryDetail: View {
    let country: Country
    
    var body: some View {
        detailListView
            .navigationBarTitle(country.name)
    }
    
    fileprivate var detailListView: some View {
        List {
            Section(header: topHeader.frame(height: .averageTouchSize * 2), content: {
                ItemRow(title: "Recent cases", count: country.newConfirmed,
                        color: .orange, percentage: country.newCasesPercent)
            })
            ItemSection(title: "Active cases", count: country.activeCases,
                    color: .orange, percentage: country.activePercent)
            ItemSection(title: "Recovered", count: country.recoveredCases,
                    color: .green, percentage: country.recoveredPercent)
            ItemSection(title: "Recent Deaths", count: country.newDeaths,
                    color: .red, percentage: country.newDeathsPercent)
            ItemSection(title: "Total Deaths", count: country.totalDeaths,
                    color: .red, percentage: country.diedPercent)
            Section(header: footer.frame(height: .averageTouchSize * 4), content: { EmptyView() })
        }
        .listRowInsets(EdgeInsets(top: .medium, leading: .large, bottom: .medium, trailing: .large))
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
    
    private var topHeader: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Text("Total cases - \(self.country.totalCases)")
                    .frame(width: geometry.width)
            }
            .font(.title)
            .foregroundColor(.primary)
        }
        
    }
    
    private var footer: some View {
        GeometryReader { geometry in
            VStack(spacing: .medium) {
                Text(self.lastUpdatedTime)
                Text("Source: covid19api.com by JHU")
                Text("App logo from CDC on Unspash")
                Text("Tweet to the developer @imthath_m")
                Text("Open sourced at github.com/covid-os/iOS")
            }.frame(width: geometry.width)
        }
    }
    
    private var lastUpdatedTime: String {
        if let time = country.dateString.date ?? Defaults.updatedTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, h:mm a"
            return "Last updated: " + formatter.string(from: time)
        }
        
        return ""
    }
}


struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetail(country: Model.country).detailListView
        //        ItemRow(title: "Active cases", count: 6930)
    }
}

