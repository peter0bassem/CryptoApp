//
//  SettingsView.swift
//  Crypto
//
//  Created by iCommunity app on 19/08/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss // moved dismiss functionality here
    
    private let defaultURL = URL(string: "https://www.google.com")!
    private let youtubeURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
    private let coffeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    private let coingeckoURL = URL(string: "https://www.coingecko.com")!
    private let personalURL = URL(string: "https://www.nicksarno.com")!
    
    var body: some View {
        NavigationView {
            ZStack {
                // background
                Color.theme.background
                    .ignoresSafeArea()
                
                // content
                List {
                    //                VStack {
                    swiftfulThinkingSection
                        .background(Color.theme.background.opacity(0.5))
                    coinGekoSection
                        .background(Color.theme.background.opacity(0.5))
                    developerSection
                        .background(Color.theme.background.opacity(0.5))
                    applicationSection
                        .background(Color.theme.background.opacity(0.5))
                    //                }
                }
                .background(Color.theme.background)
                .font(.headline)
                .tint(Color.blue)
                .listStyle(GroupedListStyle())
                .scrollIndicators(.hidden)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        XMarkButtonView { dismiss() }
                    }
                }
            }
        }
    }
}

extension SettingsView {
    @ViewBuilder
    private var swiftfulThinkingSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image(.logo)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was made by following a @SwiftfulThinking course on YouTube. It uses MVVM architecture, Combine, and CoreData")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Subscribe on YouTube🥳", destination: youtubeURL)
            Link("Support his coffee addiction☕️", destination: coffeeURL)
        } header: {
            Text("Swiftul Thinking")
        }
    }
    
    @ViewBuilder
    private var coinGekoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image(.coingecko)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGeko! Prices may slightyly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGeko🥳", destination: coingeckoURL)
        } header: {
            Text("CoinGeko")
        }
    }
    
    @ViewBuilder
    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This is was developer by Nick Sarno. It uses SwiftUI and is written in 100% in Swift. The project benifts from multi-threading, publishers/subscribers and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Website🥳", destination: personalURL)
        } header: {
            Text("Developer")
        }
    }
    
    @ViewBuilder
    private var applicationSection: some View {
        Section {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        } header: {
            Text("Application")
        }
    }
}

#Preview {
    SettingsView()
}
