//
//  Coin.swift
//  Crypto
//
//  Created by iCommunity app on 31/07/2024.
//

import Foundation

/*
 Coin geko api info: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 
 {
 "id": "bitcoin",
 "symbol": "btc",
 "name": "Bitcoin",
 "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
 "current_price": 66526,
 "market_cap": 1312806485784,
 "market_cap_rank": 1,
 "fully_diluted_valuation": 1397042989004,
 "total_volume": 25951454601,
 "high_24h": 66695,
 "low_24h": 65488,
 "price_change_24h": 238.05,
 "price_change_percentage_24h": 0.35911,
 "market_cap_change_24h": 4335662806,
 "market_cap_change_percentage_24h": 0.33135,
 "circulating_supply": 19733778,
 "total_supply": 21000000,
 "max_supply": 21000000,
 "ath": 73738,
 "ath_change_percentage": -9.7711,
 "ath_date": "2024-03-14T07:10:36.635Z",
 "atl": 67.81,
 "atl_change_percentage": 98018.13462,
 "atl_date": "2013-07-06T00:00:00.000Z",
 "roi": null,
 "last_updated": "2024-07-31T14:02:01.595Z",
 "sparkline_in_7d": {
 "price": [
 66438.95525412414,
 66476.10276492724,
 ]
 },
 "price_change_percentage_24h_in_currency": 0.3591143074631156
 }
 */

struct Coin: Identifiable, Codable {
    let id, symbol, name: String?
    let image: String?
    let currentPrice, marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    
    let currentHoldings: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    func updateHoldings(amount: Double) -> Self {
        return .init(id: self.id, symbol: self.symbol, name: self.name, image: self.image, currentPrice: self.currentPrice, marketCap: self.marketCap, marketCapRank: self.marketCapRank, fullyDilutedValuation: self.fullyDilutedValuation, totalVolume: self.totalVolume, high24H: self.high24H, low24H: self.low24H, priceChange24H: self.priceChange24H, priceChangePercentage24H: self.priceChangePercentage24H, marketCapChange24H: self.marketCapChange24H, marketCapChangePercentage24H: self.marketCapChangePercentage24H, circulatingSupply: self.circulatingSupply, totalSupply: self.totalSupply, maxSupply: self.maxSupply, ath: self.ath, athChangePercentage: self.athChangePercentage, athDate: self.athDate, atl: self.atl, atlChangePercentage: self.atlChangePercentage, atlDate: self.atlDate, lastUpdated: self.lastUpdated, sparklineIn7D: self.sparklineIn7D, priceChangePercentage24HInCurrency: self.priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingsValue: Double {
        return (currentHoldings ?? 0.0) * (currentPrice ?? 0.0)
    }
    
    var rank: Int {
        return marketCapRank.toInt()
    }
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
    let price: [Double]?
}
