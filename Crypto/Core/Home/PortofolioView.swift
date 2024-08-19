//
//  PortofolioView.swift
//  Crypto
//
//  Created by iCommunity app on 14/08/2024.
//

import SwiftUI

struct PortofolioView: View {
    
    @Environment(\.dismiss) private var dismiss // moved dismiss functionality here
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    @State private var selectedCoin: Coin? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    SearchBarView(searchPlaceholder: "Search by name or symbol...", searchText: $homeViewModel.searchText)
                    CoinLogoList
                    
                    if let selectedCoin = selectedCoin {
                        portofolioInputSection(selectedCoin: selectedCoin)
                    }
                }
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Edit Portofolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButtonView { // on tap gesture calls dismissal
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    SaveTrailingNavBarButton
                }
            }
            .onChange(of: homeViewModel.searchText) { oldValue, newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
    
    private func getCurrentValue() -> Double {
        return quantityText.toDouble().removeOptional() * (selectedCoin?.currentPrice ?? 0.0)
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin,
        let amount = quantityText.toDouble() else { return }
        homeViewModel.updatePortofolio(coin: coin, amount: amount)
        
        // save to portofolio
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut) {
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        homeViewModel.searchText = ""
    }
    
    private func updateSelectedCoin(coin: Coin) {
        self.selectedCoin = coin
        
        if let portofolioCoin = homeViewModel.portofolioCoins.first(where: { $0.id == selectedCoin?.id }) {
            quantityText = portofolioCoin.currentHoldings.removeOptional().toString()
        } else {
            quantityText = ""
        }
    }
}

#Preview {
    PortofolioView()
        .environmentObject(DeveloperPreview.shared.homeViewModel)
}

extension PortofolioView {
    @ViewBuilder
    private var SaveTrailingNavBarButton: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button(action: saveButtonPressed, label: {
                Text("Save".uppercased())
            })
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != quantityText.toDouble()) ? 1.0 : 0.0)
        }
        .font(.headline)
    }
    
    @ViewBuilder
    private var CoinLogoList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(homeViewModel.searchText.isEmpty ? homeViewModel.portofolioCoins : homeViewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1.0)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
            .padding(.trailing)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func portofolioInputSection(selectedCoin: Coin) -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current Price of \(selectedCoin.symbol.removeOptional().uppercased()):")
                Spacer()
                Text(selectedCoin.currentPrice.removeOptional().asCurrencyWith6Decimals())
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex. 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text("\(getCurrentValue().asCurrencyWith2Decimals())")
            }
        }
        .animation(.none, value: UUID())
        .padding(.horizontal)
        .font(.headline)
    }
}
