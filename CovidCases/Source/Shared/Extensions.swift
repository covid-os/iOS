//
//  Extensions.swift
//  CovidCases
//
//  Created by Imthath M on 08/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

extension EdgeInsets {
    static var zero: EdgeInsets { EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero)}
}

extension View {
    func stacked(for device: Device) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self.navigationViewStyle(DoubleColumnNavigationViewStyle()))
        }
    }
}

extension Color {
    static var navBarColor: Color { Color(UIColor.navBarColor) }
    static var navBarTitleColor: Color { Color(UIColor.navBarTitleColor) }
    
    static var death: Color { .red }
}

extension UIColor {
    static var navBarColor: UIColor { .secondarySystemGroupedBackground }
//    static var navBarColor: UIColor { #colorLiteral(red: 0.7843137255, green: 0.3960784314, blue: 0.9058823529, alpha: 1) }
    static var navBarTitleColor: UIColor { .white }
}

extension String {
    
    static var jhuDateFormat: String { "yyyy-MM-dd'T'HH:mm:ssZ" }
    
    static var indiaDateFormat: String { "dd/MM/yyyy HH:mm:ss"}
    
    static var displayDateFormat: String { "MMMM d, h:mm a" }

    internal func log(file: String = #file,
                      functionName: String = #function,
                      lineNumber: Int = #line) {
        Console.shared.log("\(URL(fileURLWithPath: file).lastPathComponent)-\(functionName):\(lineNumber)  \(self)")
    }
    
    func toDate(fromFormat format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    var number: Int { Int(self) ?? 0 }
}

extension Date {
    func toString(inFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
extension Int {
    var formatted: String {
        if self < 1000 { return "\(self)" }
        
        let thousands = Double(self)/1000
        
        if thousands < 1000 {
            return String(format: "%.1f", thousands) + " K"
        }
        
        return String(format: "%.1f", thousands/1000) + " M"
        
    }
}

extension Array where Element: Hashable {
    var uniqueElements: [Element] {
        var set = Set<Element>()

        return filter { set.insert($0).0 }
    }

    mutating func removeDuplicates() {
        self = self.uniqueElements
    }
}
