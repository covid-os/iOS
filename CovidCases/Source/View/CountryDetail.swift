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
        detailScrollView
            .navigationBarTitle(Text(country.name), displayMode: .large)
        //            .navigationBarTitle(country.name, displayMode: .large)
        //            .navigationBarTitle(country.name)
    }
    
    fileprivate var detailScrollView: some View {
        ScrollView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                cards
            }
            
            //            }
        }
//        .background(Color(UIColor.systemGroupedBackground))
        //    .padding()
        //        .listRowInsets(EdgeInsets(top: .medium, leading: .large, bottom: .medium, trailing: .large))
        //        .listStyle(GroupedListStyle())
        //        .environment(\.horizontalSizeClass, .regular)
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

struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetail(country: Model.country).detailScrollView
    }
}

