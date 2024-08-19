//
//  HomeViewModel.swift
//  Crypto
//
//  Created by iCommunity app on 01/08/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @MainActor @Published private(set) var statistics: [Statistic] = []
    
    @Published private(set) var allCoins: [Coin] = []
    @Published private(set) var portofolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portofolioDataService = PortofolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        DispatchQueue.main.async { [weak self] in
            self?.addSubscribers()
        }
    }
    
    @MainActor
    func addSubscribers() {
//        Task {
//            await coinDataService.$allCoins
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self] coins in
//                    self?.allCoins = coins
//                }
//                .store(in: &cancellables)
//        }
        
        // updates allCoins
        Task {
            await $searchText
                .combineLatest(coinDataService.$allCoins, $sortOption)
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .map(filterAndSortCoins)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] filteredCoins in
                    self?.allCoins = filteredCoins
                }
                .store(in: &cancellables)
        }
        
        // updates portofolio coins
        Task {
            await $allCoins
                .combineLatest(portofolioDataService.$portofolios)
                .map(mapAllCoinsToPortofolioCoins)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] portofolioCoins in
//                    guard let self = self else { return }
                    self?.portofolioCoins = self?.sortPortofolioCoinsIfNeeded(coins: portofolioCoins) ?? []
                }
                .store(in: &cancellables)
        }

        // updates market data
        Task {
            await marketDataService.$marketData
                .combineLatest($portofolioCoins)
                .map(mapGlobalMarketData)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] stats in
                    self?.statistics = stats
                    self?.isLoading = false
                }
                .store(in: &cancellables)
                
        }
    }
    
    func reloadData() {
        isLoading = true
        Task {
//            isLoading = true
            await coinDataService.getCoins()
            await marketDataService.getData()
            HapticManager.notification(type: .success)
        }
    }
    
    func updatePortofolio(coin: Coin, amount: Double) {
        Task {
            await portofolioDataService.updatePortofolio(coin: coin, amount: amount)
        }
    }
    
    private func mapGlobalMarketData(data: MarketData?, portofolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = data else { return stats }
        let marketCap = Statistic(title: "Marlet Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let bitcoinDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        let portofolioValue = portofolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
        let previousValue = portofolioCoins.map {
            let currentValue = $0.currentHoldingsValue
            let percentChange = $0.priceChangePercentage24H.removeOptional() / 100
            return currentValue / (1 + percentChange)
        }.reduce(0.0, +)
        let percentageChange = ((portofolioValue - previousValue) / previousValue)
        
        let portofolio = Statistic(title: "Portofolio Value", value: portofolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, bitcoinDominance, portofolio])
        return stats
    }
    
    private func sortPortofolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        // will only sort by holdings or reversedHoldings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default: return coins
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rank:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price, .holdings:
            coins.sort(by: { $0.currentPrice.removeOptional() < $1.currentPrice.removeOptional() })
        case .priceReversed, .holdingsReversed:
            coins.sort(by: { $0.currentPrice.removeOptional() > $1.currentPrice.removeOptional() })
        }
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sortOption: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else { return coins }
        return coins.filter { $0.name.removeOptional().lowercased().contains(text.lowercased()) || $0.symbol.removeOptional().lowercased().contains(text.lowercased()) || $0.id.removeOptional().lowercased().contains(text.lowercased()) }
    }
    
    private func mapAllCoinsToPortofolioCoins(allCoins: [Coin], portofolioEntities: [PortofolioEntity]) -> [Coin] {
        allCoins
            .compactMap { coin in
                guard let entity = portofolioEntities.first(where: { $0.coinID == coin.id }) else { return nil }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
}
