//
//  InfoView.swift
//  CovidCases
//
//  Created by Imthath M on 08/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI

struct FAQ {
    var question: String
    var answers: [String]
}

struct InfoView: View {
    let information: [FAQ] = [
        FAQ(question: "What colours are in a rainbow?", answers: ["Red", "Orange", "Yellow", "Green", "Blue", "Indigo", "Violet"]),
        FAQ(question: "What is the fastest animal on land?", answers: ["The cheetah"]),
        FAQ(question: "What colours are of a rainbow?", answers: ["Red", "Orange", "Yellow", "Green", "Blue", "Indigo", "Violet"]),
        FAQ(question: "What is the fastest mammal on land?", answers: ["The cheetah"])
        
    ]
    
    var body: some View {
//        plainList
        groupedList
    }
    
    var plainList: some View {
        List {
            ForEach(information, id: \.question) { info in
                InfoSection(info: info)
            }
            Section(footer: footer, content: { EmptyView() })
        }
    }
    
    
    private var footer: some View {
        InfoFooter(texts: ["App logo from CDC on Unspash", "Tweet to the developer @imthath_m", "Open sourced at github.com/covid-os/iOS"])
    }
    
    var groupedList: some View {
        plainList
        .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
    }
}

struct InfoSection: View {
    
    let info: FAQ
    @State var showsAnswer = false
    var footer: AnyView = AnyView(EmptyView())
    
    var body: some View {
//        questionInHeader
        questionInList
    }
    
    var questionInHeader: some View {
        Section(header: questionView) {
            if showsAnswer {
                answersView
            }
        }
    }
    
    var questionInList: some View {
        Section {
            questionView
            if showsAnswer {
                answersView//.animation(.easeInOut)
            }
        }.animation(nil)
            //.animation(.easeInOut)
        .listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
    }
    
    var questionView: some View {
//        Text(info.question)
        questionStack
            .foregroundColor(.primary)
            .onTapGesture {
            self.showsAnswer.toggle()
        }.animation(.linear(duration: 0.3))
    }
    
    var questionStack: some View {
        ZStack(alignment: .leading) {
            if showsAnswer {
                Color.pink
            }
            HStack {
                Text(info.question)
                Spacer()
                Image(systemName: "chevron.down")
                    .imageScale(.large)
                    .rotationEffect(.degrees(showsAnswer ? 180 : 0))
                    .animation(.easeInOut)
            }
            .foregroundColor(showsAnswer ? Color(.systemBackground) : .primary)
            .padding()
            
        }
    }
    
//    @ViewBuilder
    var answersView: some View {
        VStack(alignment: .leading, spacing: .medium) {
            ForEach(info.answers, id: \.self) { answer in
                Text("• " + answer).multilineTextAlignment(.leading)
            }
        }.padding()
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
