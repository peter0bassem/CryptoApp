//
//  CoinDataService.swift
//  Crypto
//
//  Created by iCommunity app on 01/08/2024.
//

import Combine
import Foundation

actor CoinDataService {
    @Published private(set) var allCoins: [Coin] = [] 
    private var coinCancellable: AnyCancellable?
    
    init() {
        Task {
            await getCoins()
        }
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        coinCancellable = NetworkingManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] coins in
                Task { [weak self] in
                    await self?.updateCoins(with: coins)
                    await self?.coinCancellable?.cancel()
                }
            })
    }
    
    private func updateCoins(with coins: [Coin]) {
        self.allCoins = coins
    }
}

