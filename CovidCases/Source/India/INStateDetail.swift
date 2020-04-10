//
//  INStateDetail.swift
//  CovidCases
//
//  Created by Imthath M on 08/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI

struct INStateDetail: View {
    let state: INState
    
    var edgeInsets = EdgeInsets(top: .medium, leading: .large, bottom: .medium, trailing: .large)
    var body: some View {
        detailListView
            .navigationBarTitle(state.name)
    }
    
    fileprivate var detailListView: some View {
        List {
            districtsSection
                .listRowInsets(edgeInsets)
            Section(header: topHeader.frame(height: .averageTouchSize * 2), content: {
                ItemRow(title: "Active cases", count: state.activeCases,
                        color: .orange, percentage: state.activePercent)
            })
                .listRowInsets(edgeInsets)
            ItemSection(title: "Recent cases", count: state.recentCases,
                        color: .orange, percentage: state.recentCasesPercent)
                .listRowInsets(edgeInsets)
            ItemSection(title: "Recovered", count: state.recoveredCases,
                        color: .green, percentage: state.recoveredPercent)
                .listRowInsets(edgeInsets)
            ItemSection(title: "Total deaths", count: state.totalDeaths,
                        color: .death, percentage: state.diedPercent)
                .listRowInsets(edgeInsets)
            ItemSection(title: "Recent deaths", count: state.recentDeaths,
                        color: .death, percentage: state.recentDeathsPercent)
                .listRowInsets(edgeInsets)
            Section(header: footer.frame(height: .averageTouchSize * 2), content: { EmptyView() })
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
    
    private var districtsSection: some View {
        let districts = IndiaStore.getDistricts(forState: state.name)
        
        guard !districts.isEmpty else {
            return AnyView(EmptyView())
        }
        
        return AnyView(INDistrictList(districts: districts))
    }
    
    private var topHeader: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Text("Total cases - \(self.state.totalCases)")
                    .frame(width: geometry.width)
            }
            .font(.title)
            .foregroundColor(.primary)
        }
        
    }
    
    private var footer: some View {
        InfoFooter(texts: ["Source: covid19india.org", lastUpdatedTime])
    }
    
    private var lastUpdatedTime: String {
        if let time = state.dateString.toDate(fromFormat: .indiaDateFormat) ?? Defaults.indiaUpdatedTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, h:mm a"
            return "Last updated: " + formatter.string(from: time)
        }
        
        return ""
    }
}

extension INDistrict: Identifiable {
    var id: String { name }
}

struct INDistrictList: View {
    var districts: [INDistrict]
    
    var body: some View {
        Section(header: CenteredHeaderFooter("District level confirmed cases")) {
            ForEach(districts) {  INDistrictRow(district: $0) }
        }
    }
}

struct INDistrictRow: View {
    var district: INDistrict
    
    var body: some View {
        HStack {
            Text(district.name)
            Spacer()
            if district.recent > 0 {
                Text("↑\(district.recent)")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            Text("\(district.confirmed)")
        }
    }
}
//struct INStateDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        INStateDetail()
//    }
//}
