//
//  CoinDetailViewModel.swift
//  Crypto
//
//  Created by iCommunity app on 19/08/2024.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    @Published private(set) var coinDetails: CoinDetail? = nil
    @Published private(set) var statistics: [Statistic] = []
    @Published private(set) var additionalStatistics: [Statistic] = []
    @Published private(set) var coinDescription: String? = nil
    @Published private(set) var websiteURL: String? = nil
    @Published private(set) var redditURL: String? = nil
    
    @Published private var coin: Coin
    private let coinDetailsDataService: CoinDetailsDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(with coin: Coin) {
        self.coin = coin
        coinDetailsDataService = CoinDetailsDataService(coin: coin)
        DispatchQueue.main.async { [weak self] in
            self?.addSubscribers()
        }
    }
    
    private func addSubscribers() {
        Task {
            await coinDetailsDataService.$coinDetails
                .combineLatest($coin)
                .map(mapCoinDetailsToStatistics)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] allStatistics in
                    self?.statistics = allStatistics.overview
                    self?.additionalStatistics = allStatistics.additional
                }
                .store(in: &cancellables)
        }
        
        Task {
            await coinDetailsDataService.$coinDetails
                .receive(on: DispatchQueue.main)
                .sink { [weak self] coinDetails in
                    self?.coinDescription = coinDetails?.readableDescription
                    self?.websiteURL = coinDetails?.links?.homepage?.first
                    self?.redditURL = coinDetails?.links?.subredditURL
                }
                .store(in: &cancellables)
        }
    }
    
    private func mapCoinDetailsToStatistics(coinDetails: CoinDetail?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
         return (createOverviewStatistics(coin: coin), createAdditionalStatisticsArray(coinDetails: coinDetails, coin: coin))
    }
    
    private func createOverviewStatistics(coin: Coin) -> [Statistic] {
        let price = coin.currentPrice.removeOptional().asCurrencyWith2Decimals()
        let pricePercentageChange = coin.priceChangePercentage24H.removeOptional()
        let priceSat = Statistic(title: "Current Price", value: price, percentageChange: pricePercentageChange)
        
        let marketCap = "$" + coin.marketCap.removeOptional().formattedWithAbbreviations()
        let marketCapPercentageChange = coin.marketCapChangePercentage24H.removeOptional()
        let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentageChange)
        
        let rank = coin.rank.toString()
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + coin.totalVolume.removeOptional().formattedWithAbbreviations()
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        return [priceSat, marketCapStat, rankStat, volumeStat]
    }
    
    private func createAdditionalStatisticsArray(coinDetails: CoinDetail?, coin: Coin) -> [Statistic] {
        let high24H = coin.high24H?.asCurrencyWith6Decimals() ?? "N/A"
        let highStat = Statistic(title: "24h High", value: high24H)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "N/A"
        let lowStat = Statistic(title: "24 Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith2Decimals() ?? "N/A"
        let pricePercentageChange2 = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: pricePercentageChange2)
        
        let marketCapChange = "$" + coin.marketCapChange24H.removeOptional().formattedWithAbbreviations()
        let marketCapPercentageChange2 = coin.marketCapChangePercentage24H.removeOptional()
        let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentageChange2)
        
        let blockTime = (coinDetails?.blockTimeInMinutes ?? 0) == 0 ? "N/A" : (coinDetails?.blockTimeInMinutes ?? 0).toString()
        let blockStat = Statistic(title: "Block Time", value: blockTime)
        
        let hashing = coinDetails?.hashingAlgorithm ?? "N/A"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
        return [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
    }
}
