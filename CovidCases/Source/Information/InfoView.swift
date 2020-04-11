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
    var isBulleted = false
}

struct InfoView: View {
    let information: [FAQ] = [
        FAQ(question: "What does COVID-19 stand for?",
            answers: ["COVID-19 is the name of the disease caused by the novel coronavirus SARS-CoV-2. Viruses and the diseases they cause have different names. For example, AIDS is the disease caused by the human immunodeficiency virus, HIV.", "As mentioned above, COVID-19 is an acronym. In its full form, COVID-19 stands for COronaVIrus Disease of 2019.", "It started in Wuhan, China in late 2019 and has since spread worldwide."], isBulleted: false),
        FAQ(question: "Who named COVID-19?",
            answers: ["It's actually WHO - World Health Organization. The coronavirus disease of 2019 was given the abbreviated name of COVID-19 by the WHO in a press release on February 11, 2020."]),
        FAQ(question: "What is a coronavirus?",
            answers: ["Coronaviruses are common human and animal viruses. They were first discovered in domestic poultry in the 1930s. In animals, coronaviruses cause a range of respiratory, gastrointestinal, liver, and neurologic diseases.", "Only seven coronaviruses are known to cause disease in humans."]),
        FAQ(question: "What is a novel coronavirus?",
            answers: ["A “novel” coronavirus means that it is a new coronavirus that has not been previously identified in humans. This means it is different from coronaviruses that cause the common cold, and those that caused SARS in 2002 and MERS in 2012.", "Like, SARS and MERS, the novel coronavirus is a zoonotic disease. The definition of a zoonotic disease is one that begins in animals and is transmitted from animals to people."]),
        FAQ(question: "How to prevent infection?",
            answers: ["Regularly and thoroughly wash your hands with an alcohol-based hand rub or soap." , "Maintain a minimum of 1-meter distance between yourself and the person coughing or sneezing", "Avoid touching your eyes, nose, and mouth.", "Avoid travelling to the hotspots.", "Stay home if you are unwell.", "Avoid close contact with people who are sick or show symptoms of the virus.", "Practice cough etiquette, covering your cough or sneeze.", "Clean and disinfect frequently touched objects and surfaces.", "Surgical masks may be used as an infection control measure or a mitigation measure when worn by individuals with respiratory symptoms."],
            isBulleted: true),
        FAQ(question: "What are the symptoms of infection?",
            answers: ["Common symptoms include fever, tiredness and dry cough. Some patients may also experience nasal congestion, runny nose, sore throat or diarrhea. Some people may be infected without developing any symptoms.", "Older people and those with medical problems like high blood pressure, diabetes or heart problems are more likely to develop serious infection.", "Human coronaviruses can sometimes cause lower-respiratory tract illnesses, such as pneumonia or bronchitis.", "This is more common in people with cardiopulmonary disease, people with weakened immune systems, infants, and older adults."]),
        
        FAQ(question: "What should you do if you feel symptoms?",
            answers: ["Stay home: Most people with COVID-19 have mild illness and are able to recover at home without medical care. Do not leave your home, except to get medical care. Do not visit public areas." ,
                      "Stay in touch with your doctor: Call before you get medical care. Be sure to get care if you have trouble breathing, or have any other emergency warning signs, or if you think, it is an emergency.",
                      "Avoid public transportation, ride sharing, or taxis.",
                      "Stay away from others, as much as possible. You should stay in a  specific “sick room” if possible and away from other people and pets in your home. Use a separate bathroom, if available.",
                      "Call ahead: Many medical visits for routine care are being postponed or done by phone or telemedicine. If you have a medical appointment that cannot be postponed, call your doctor’s office, and tell them you have or may have COVID-19. This will help the office protect themselves and other patients.",
                      "Cover your mouth and nose with a tissue when you cough or sneeze", "Dispose used tissues in a lined trashcan.",
                      "Immediately wash your hands with soap and water for at least 20 seconds. If soap and water are not available, clean your hands with an alcohol-based hand sanitizer that contains at least 60% alcohol",
                      "Clean high-touch surfaces in your “sick room” and bathroom. Let someone else clean and disinfect surfaces in common areas, but not your bedroom and bathroom.",
                      "If a caregiver or other person needs to clean and disinfect a sick person’s bedroom or bathroom, they should do so on an as-needed basis. The caregiver/other person should wear a mask and wait as long as possible after the sick person has used the bathroom.",
                      "High-touch surfaces include phones, remote controls, counters, tabletops, doorknobs, bathroom fixtures, toilets, keyboards, tablets, and bedside tables."],
            isBulleted: true),
        
        FAQ(question: "DI", answers: ["App logo from CDC on Unspash", "Tweet to the developer @imthath_m", "Open sourced at github.com/covid-os/iOS"])
        
    ]
    
    var body: some View {
        VStack {
            Card(cornerRadius: .zero, fillColor: Color(.systemBackground)) {
                Text("Know about COVID-19").font(.headline)
            }.frame(height: .averageTouchSize)
            faqList
        }
//            .navigationBarTitle("Know about COVID-19", displayMode: .inline)
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
        
        return AnyView(InfoRow(info: info))
    }
    private var footer: some View {
        InfoFooter(texts: ["App logo from CDC on Unspash", "Tweet to the developer @imthath_m", "Open sourced at github.com/covid-os/iOS"])
            .font(.footnote)
            .foregroundColor(.secondary)
            .frame(minHeight: .averageTouchSize * 3)
    }
}

struct InfoRow: View {
    
    let info: FAQ
    @State var showsAnswer = false
    var footer: AnyView = AnyView(EmptyView())
    
    var body: some View {
        self.stackView
            .background(Color(.secondarySystemBackground))
            .cornerRadius(.medium)
            .onTapGesture {
                self.showsAnswer.toggle()
        }
    }
    
    var stackView: some View {
        VStack(alignment: .leading, spacing: .medium) {
            questionButton
            if showsAnswer {
                answersView
                .padding(EdgeInsets(top: .zero, leading: .medium, bottom: .medium, trailing: .small))
            }
        }
    }
    
    var questionButton: some View {
        Button(action: {
            self.showsAnswer.toggle()
        }, label: {
            QuestionView(question: info.question)
                .background(showsAnswer ? Color.init("backgroundPink") : Color.clear)
                .animation(.default)
            }).buttonStyle(NoAnimationButtonStyle())
    }
    
    
    var answersView: some View {
        ForEach(info.answers, id: \.self) { answer in
            self.getText(for: answer)
        }
    }
    
    func getText(for answer: String) -> some View {
        if info.isBulleted {
            return Text("• " + answer).multilineTextAlignment(.leading)
        }
        
        return Text(answer).multilineTextAlignment(.leading)
    }
}

struct QuestionView: View {
    
    var question: String
    
    var body: some View {
                    HStack {
                        Text(question)
                            .font(.system(size: .medium * 1.35, weight: .bold, design: .default))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .frame(height: .averageTouchSize * 2)
                    
//                }
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
