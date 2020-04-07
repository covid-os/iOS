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
                    print("onCommit")
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


//struct CustomViews_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomViews()
//    }
//}
