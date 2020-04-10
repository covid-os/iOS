//
//  InfoView.swift
//  CovidCases
//
//  Created by Imthath M on 08/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI
import SwiftyUserInterface

struct FAQ {
    var question: String
    var answers: [String]
}

struct InfoView: View {
    let information: [FAQ] = [
        FAQ(question: "What colours are in a rainbow?", answers: ["SwiftUI has a dedicated modifier for setting background views behind list rows, in SwiftUI has a dedicated modifier for setting background views behind list rows, in  v", "SwiftUI has a dedicated modifier for setting background views behind list rows, in", "Yellow", "Green", "Blue", "Indigo", "SwiftUI has a dedicated modifier for setting background views behind list rows, in"]),
        FAQ(question: "What is the fastest animal on land?", answers: ["The SwiftUI has a dedicated modifier for setting background views behind list rows, in"]),
        FAQ(question: "What colours are of a rainbow?", answers: ["Red", "Orange", "Yellow", "Green", "Blue", "SwiftUI has a dedicated modifier for setting background views behind list rows, in", "Violet"]),
        FAQ(question: "What is the fastest mammal on land?", answers: ["The cheetah"]),
        FAQ(question: "DI", answers: ["App logo from CDC on Unspash", "Tweet to the developer @imthath_m", "Open sourced at github.com/covid-os/iOS"])
        
    ]
    
    var body: some View {
        faqList
        .navigationBarTitle("Know about COVID-19")
    }
    
    var faqList: some View {
        List(information, id: \.question) { info in
            self.row(for: info)
        }
        .introspectTableView {
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
        }
    }
    
    private func row(for info: FAQ) -> some View {
        if info.question == "DI" {
            return AnyView(footer)
        }
        
        return AnyView(InfoSection(info: info))
    }
    private var footer: some View {
        InfoFooter(texts: ["App logo from CDC on Unspash", "Tweet to the developer @imthath_m", "Open sourced at github.com/covid-os/iOS"])
            .font(.footnote)
            .foregroundColor(.secondary)
            .frame(minHeight: .averageTouchSize * 3)
    }
}

struct InfoSection: View {
    
    let info: FAQ
    @State var showsAnswer = false
    var footer: AnyView = AnyView(EmptyView())
    
    var body: some View {
        self.stackView
            .background(Color(.secondarySystemBackground))
            .cornerRadius(.small)
    }
    
    var stackView: some View {
        VStack(alignment: .leading, spacing: .medium) {
            questionButton
            if showsAnswer {
                answersView
                .padding(EdgeInsets(top: .zero, leading: .small, bottom: .medium, trailing: .zero))
            }
        }
    }
    
    var questionButton: some View {
        Button(action: {
            self.showsAnswer.toggle()
        }, label: {
            QuestionView(question: info.question)
            .background(showsAnswer ? Color.pink : Color.clear)
            .foregroundColor(showsAnswer ? Color(.systemBackground) : .primary)
            .animation(.easeInOut)
            }).buttonStyle(NoAnimationButtonStyle())
    }
    
    
    var answersView: some View {
        ForEach(info.answers, id: \.self) { answer in
            Text("• " + answer).multilineTextAlignment(.leading)
        }
    }
}

struct QuestionView: View {
    
    var question: String
    
    var body: some View {
        ZStack(alignment: .leading) {
                    HStack {
                        Text(question)
                        Spacer()
//                        Image(systemName: "chevron.down")
//                            .imageScale(.large)
        //                    .rotationEffect(.degrees(showsAnswer ? 180 : 0))
//                            .animation(.default)
                    }
                    .padding()
                    
                }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

struct NoAnimationButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
    
}
