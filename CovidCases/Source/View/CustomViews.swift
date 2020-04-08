//
//  CustomViews.swift
//  CovidCases
//
//  Created by Imthath M on 07/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI

public struct SearchField: View {
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false

    public init(searchText: Binding<String>) {
        self._searchText = searchText
    }
    
    public var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    Console.shared.log("onCommit")
                }).foregroundColor(.primary)

                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: .small, leading: .small * 0.75, bottom: .small, trailing: .small * 0.75))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(.small)

            if showCancelButton  {
                Button("Cancel") {
                        UIApplication.dismissKeyboard() // this must be placed before the other commands here
                        self.searchText = ""
                        self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
                .animation(.easeInOut)
            }
        }
        .animation(.easeInOut)
        .padding(.horizontal)
    }
}

struct ItemSection: View {
    let title: String
    let count: Int
    var color: Color = .primary
    var percentage: String
    
    var body: some View {
        if count == 0 {
            return AnyView(EmptyView())
        }
        
        return AnyView(section)
    }
    
    var section: some View {
        Section {
            ItemRow(title: title, count: count,
                    color: color, percentage: percentage)
        }
    }
}


struct ItemRow: View {
    let title: String
    let count: Int
    var color: Color = .primary
    var percentage: String
    
    var body: some View {
        if count == 0 {
            return AnyView(EmptyView())
        }
        
        return AnyView(row)
    }
    
    var row: some View {
        HStack {
            Text(title)
            Spacer()
            numberStack
        }.frame(minHeight: .averageTouchSize * 2)
    }
    
    var numberStack: some View {
        VStack(alignment: .trailing, spacing: .small) {
            Spacer()
            Text("\(count)")
                .font(.title)
            Text(percentage)
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

public struct InfoFooter: View {
    let texts: [String]
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: .medium) {
                ForEach(self.texts, id: \.self) { Text($0)}
            }.frame(width: geometry.width)
        }
    }
}

//struct CustomViews_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomViews()
//    }
//}
