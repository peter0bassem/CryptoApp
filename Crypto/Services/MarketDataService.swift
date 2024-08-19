//
//  MarketDataService.swift
//  Crypto
//
//  Created by iCommunity app on 14/08/2024.
//

////GlobalData

import Combine
import Foundation

actor MarketDataService {
    @Published private(set) var marketData: MarketData? = nil
    private var marketDataCancellable: AnyCancellable?
    
    init() {
        Task {
            await getData()
        }
    }
    
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        marketDataCancellable = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] globalData in
                Task { [weak self] in
                    await self?.updateMarketData(with: globalData.data)
                    await self?.marketDataCancellable?.cancel()
                }
            })
    }
    
    private func updateMarketData(with marketData: MarketData?) {
        self.marketData = marketData
    }
}
