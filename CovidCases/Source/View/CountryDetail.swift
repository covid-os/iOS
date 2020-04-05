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
            Section(header: topHeader, content: { EmptyView() })
            ItemRow(title: "Recent cases", count: country.newConfirmed,
                    color: .yellow, percentage: country.newCasesPercent)
            ItemRow(title: "Active cases", count: country.activeCases,
                    color: .orange, percentage: country.activePercentage)
            ItemRow(title: "Recovered", count: country.totalRecovered,
                    color: .green, percentage: country.recoveredPercent)
//            ItemRow(title: "Recently Recovered", count: country.newRecovered,
//                    color: .green, percentage: country.newRecoveredPercent)
            ItemRow(title: "Recent Deaths", count: country.newDeaths,
                    color: .red, percentage: country.newDeathsPercent)
            ItemRow(title: "Total Deaths", count: country.totalDeaths,
                    color: .red, percentage: country.diedPercentage)
            Section(header: CenteredHeaderFooter(lastUpdatedTime),
                    footer: CenteredHeaderFooter("Source: covid19api.com by JHU"),
                    content: { EmptyView() })
            Section(header: CenteredHeaderFooter("Tweet to the developer @imthath_m"),
                    footer: CenteredHeaderFooter("Open sourced at github.com/covid-os/iOS"),
                    content: { EmptyView() })
        }
        .listRowInsets(EdgeInsets(top: .medium, leading: .large, bottom: .medium, trailing: .large))
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
    
    private var topHeader: some View {
        GeometryReader { geometry in
            Text("Total cases - \(self.country.totalConfirmed)")
                .font(.title)
                .foregroundColor(.primary)
                .frame(width: geometry.width)
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

struct ItemRow: View {
    let title: String
    let count: Int
    var color: Color = .primary
    var percentage: String? = nil
    
    var body: some View {
        Section {
            HStack {
                Text(title)
                Spacer()
                numberStack
            }.frame(minHeight: .averageTouchSize * 2)
        }
    }
    
    var numberStack: some View {
        VStack(alignment: .trailing, spacing: .small) {
            Spacer()
            Text("\(count)")
                .font(.title)
            //            HStack {
            //                Spacer()
            Text(percentage == nil ? "" : percentage!)
            //            }
            
        }
        .foregroundColor(color)
    }
}

struct CenteredHeaderFooter: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
            Spacer()
        }
    }
}
struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetail(country: Model.country).detailListView
        //        ItemRow(title: "Active cases", count: 6930)
    }
}

