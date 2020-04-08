//
//  TabBar.swift
//  CovidCases
//
//  Created by Imthath M on 08/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct TabBarController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var selectedIndex: Int

    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers
        tabBarController.delegate = context.coordinator
        tabBarController.selectedIndex = 0
        return tabBarController
    }

    func updateUIViewController(_ tabBarController: UITabBarController, context: Context) {
        tabBarController.selectedIndex = selectedIndex
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITabBarControllerDelegate {
        var parent: TabBarController

        init(_ tabBarController: TabBarController) {
            self.parent = tabBarController
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            parent.selectedIndex = tabBarController.selectedIndex
        }
    }
}

/// An iOS style TabView that doesn't reset it's childrens navigation stacks when tabs are switched.
struct UIKitTabView: View {
    var viewControllers: [UIHostingController<Tab>]
    @State var selectedIndex: Int = 0
    
    init(_ views: [Tab]) {
        self.viewControllers = views.map {
            let host = UIHostingController(rootView: $0)
            host.tabBarItem = $0.barItem
            return host
        }
    }
    
    var body: some View {
        TabBarController(controllers: viewControllers, selectedIndex: $selectedIndex)
            .edgesIgnoringSafeArea(.all)
    }
    
    struct Tab: View {
        var view: AnyView
        var barItem: UITabBarItem
        
        init<V: View>(view: V, barItem: UITabBarItem) {
            self.view = AnyView(view)
            self.barItem = barItem
        }
        
        var body: some View {
            view
        }
        
        // convenience
        init<V: View>(view: V, image: String) {
            let barItem = UITabBarItem(title: nil, image: UIImage(systemName: image), selectedImage: nil)
//            (title: nil, image: UIImage(systemName: "globe"))
            self.init(view: view, barItem: barItem)
        }
    }
}
