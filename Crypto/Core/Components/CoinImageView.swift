//
//  CoinImageView.swift
//  Crypto
//
//  Created by iCommunity app on 11/08/2024.
//

import SwiftUI
import Combine

fileprivate class CoinImageViewModel: ObservableObject {
    @Published private(set) var image: UIImage? = nil
    @Published private(set) var isLoading: Bool = false
    
    private let coin: Coin
    private let coinImageService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.coinImageService = CoinImageService(coin: coin)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        Task {
            await coinImageService.$image
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.isLoading = false
                } receiveValue: { [weak self] image in
                    self?.image = image
                }
                .store(in: &cancellables)
        }
    }
}

struct CoinImageView: View {
    
    @StateObject private var coinImageViewModel: CoinImageViewModel
    
    init(coin: Coin) {
        self._coinImageViewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = coinImageViewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if coinImageViewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    CoinImageView(coin: DeveloperPreview.shared.coin)
}
