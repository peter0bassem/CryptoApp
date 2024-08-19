//
//  CryptoApp.swift
//  Crypto
//
//  Created by iCommunity app on 30/07/2024.
//

import SwiftUI

@main
struct CryptoApp: App {
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [ .foregroundColor: UIColor(Color.theme.accent) ]
        UINavigationBar.appearance().titleTextAttributes = [ .foregroundColor: UIColor(Color.theme.accent) ]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                        .toolbar(.hidden, for: .navigationBar)
                }
                .environmentObject(viewModel)
                
                ZStack {
                    if showLaunchView {
                        LaunchScreenView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
