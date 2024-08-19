//
//  CoinDetailsDataService.swift
//  Crypto
//
//  Created by iCommunity app on 19/08/2024.
//

import Foundation
import Combine

actor CoinDetailsDataService {
    @Published private(set) var coinDetails: CoinDetail? = nil
    private let coin: Coin
    private var coinDetailsCancellable: AnyCancellable?
    
    init(coin: Coin) {
        self.coin = coin
        Task {
            await getCoinDetails()
        }
    }
    
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id.removeOptional())?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        coinDetailsCancellable = NetworkingManager.download(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] coinDetail in
                Task { [weak self] in
                    await self?.updateCoinDetails(with: coinDetail)
                    await self?.coinDetailsCancellable?.cancel()
                }
            })
    }
    
    private func updateCoinDetails(with coinDetails: CoinDetail) {
        self.coinDetails = coinDetails
    }
}
