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
            .navigationBarTitle(Text(country.name), displayMode: .large)
    }
    
    fileprivate var detailListView: some View {
        List {
            ItemRow(title: "Total affected", count: country.totalConfirmed)
            ItemRow(title: "Active now", count: country.activeCases, color: .pink)
            ItemRow(title: "Recovered fully", count: country.totalRecovered, color: .green)
            ItemRow(title: "Died", count: country.totalDeaths, color: .red)
            Section(header: CenteredHeaderFooter(lastUpdatedTime),
                    footer: CenteredHeaderFooter("Source: covid19api.com by JHU CSSE"),
                    content: { EmptyView() })
        }
        .listRowInsets(EdgeInsets(top: .medium, leading: .large, bottom: .medium, trailing: .large))
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
    
    private var lastUpdatedTime: String {
        if let time = Defaults.updatedTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, HH:mm"
            return "Last updated time:" + formatter.string(from: time)
        }
        
        return ""
    }
    
    fileprivate func getStack(for title: String, withCount count: Int) -> some View {
        Section {
            HStack {
                Text(title)
                Spacer()
                Text("\(count)").font(.title)
            }.frame(minHeight: .averageTouchSize * 2)
        }
    }
    
    fileprivate var detailScrollView: some View {
        ScrollView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                cards
            }
        }
    }
    
    fileprivate var cards: some View {
        VStack {
            Card(fillColor: Color.pink) {
                HStack {
                    Spacer()
                    VStack(spacing: .large) {
                        Text("Total Cases").font(.title)
                        Text("\(self.country.totalConfirmed)").font(.largeTitle)
                    }
                    Spacer()
                }
            }.frame(minHeight: 200)
                .padding()
            
            HStack(spacing: .large) {
                Card(fillColor: Color(UIColor.secondarySystemGroupedBackground)) {
                    HStack {
                        Spacer()
                        VStack(spacing: .large) {
                            Text("Active")
                            Text("\(self.country.activeCases)").font(.title).layoutPriority(1)
                        }
                        Spacer()
                    }
                }
                
                Card(fillColor: Color.green) {
                    HStack {
                        Spacer()
                        VStack(spacing: .large) {
                            Text("Recovered")
                            Text("\(self.country.totalRecovered)").font(.title)
                        }
                        Spacer()
                    }
                }
            }.frame(minHeight: 200).padding()
            
            Card(fillColor: Color.red) {
                HStack {
                    Spacer()
                    VStack(spacing: .large) {
                        Text("Total Deaths").font(.title)
                        Text("\(self.country.totalDeaths)").font(.largeTitle)
                    }
                    Spacer()
                }
            }.frame(minHeight: 200)
                .padding()
        }
    }
}

struct ItemRow: View {
    let title: String
    let count: Int
    var color: Color = .primary
    
    var body: some View {
        Section {
            HStack {
                Text(title)
                Spacer()
                Text("\(count)").font(.title).foregroundColor(color)
            }.frame(minHeight: .averageTouchSize * 2)
        }
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
        CountryDetail(country: Model.country).detailScrollView
    }
}

