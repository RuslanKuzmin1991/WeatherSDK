//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 17.10.24.
//

import SwiftUI
import UIKit

@main
struct TestTaskApp: App {
    var body: some Scene {
        WindowGroup {
            RootViewController()
                           .edgesIgnoringSafeArea(.all)
        }
    }
}

//Necessary for UIKit navigation integration
struct RootViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let router = RouterApp()
        router.setRootView()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.navigationBar
        
        if let font = UIFont.navigationTitle {
            appearance.titleTextAttributes = [.foregroundColor: UIColor.textPrimary,
                                              .font: font]
        }
        router.rootNavigator.navigationBar.standardAppearance = appearance
        router.rootNavigator.navigationBar.scrollEdgeAppearance = appearance
        return router.rootNavigator
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}
