//
//  LocationDetail.swift
//  CovidCases
//
//  Created by Imthath M on 08/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI

struct MaxLocationDetail: View {
    let location: MaxLocation
    var footerInfo: [String] = []
    
    var body: some View {
        detailListView
            .navigationBarTitle(location.name)
    }
    
    fileprivate var detailListView: some View {
        List {
            Section(header: topHeader.frame(height: .averageTouchSize * 2), content: {
                ItemRow(title: "Recent cases", count: location.recentCases,
                        color: .orange, percentage: location.recentCasesPercent)
            })
            ItemSection(title: "Active cases", count: location.activeCases,
                    color: .orange, percentage: location.activePercent)
            ItemSection(title: "Recovered", count: location.recoveredCases,
                    color: .green, percentage: location.recoveredPercent)
            ItemSection(title: "Recent Deaths", count: location.recentDeaths,
                    color: .red, percentage: location.recentDeathsPercent)
            ItemSection(title: "Total Deaths", count: location.totalDeaths,
                    color: .red, percentage: location.diedPercent)
            Section(header: footer.frame(height: .averageTouchSize * CGFloat(totalFooterTexts.count)),
                    content: { EmptyView() })
        }
        .listRowInsets(EdgeInsets(top: .medium, leading: .large, bottom: .medium, trailing: .large))
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
    
    private var topHeader: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Text("Total cases - \(self.location.totalCases)")
                    .frame(width: geometry.width)
            }
            .font(.title)
            .foregroundColor(.primary)
        }
        
    }
    
    private var footer: some View {
        InfoFooter(texts: totalFooterTexts)
    }
    
    private var totalFooterTexts: [String] {
        footerInfo + [location.displayUpdateTime]
    }
}

//struct LocationDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MaxLocationDetail()
//    }
//}
