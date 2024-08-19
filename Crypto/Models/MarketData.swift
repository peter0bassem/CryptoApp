//
//  MarketData.swift
//  Crypto
//
//  Created by iCommunity app on 14/08/2024.
//

import Foundation

/*
 {
 "data": {
 "active_cryptocurrencies": 15034,
 "upcoming_icos": 0,
 "ongoing_icos": 49,
 "ended_icos": 3376,
 "markets": 1172,
 "total_market_cap": {
 "btc": 36706851.53431339,
 "eth": 820505046.9366314,
 "ltc": 35068001624.32848,
 "bch": 6501616961.363915,
 "bnb": 4239351074.7985883,
 "eos": 4441535297424.389,
 "xrp": 3875652703891.6724,
 "xlm": 22648543181153.46,
 "link": 211454799688.36536,
 "dot": 493009446828.75104,
 "yfi": 442809264.38301647,
 "usd": 2234201360520.4795,
 "aed": 8206154571150.91,
 "ars": 2099571737837555.5,
 "aud": 3366358323749.27,
 "bdt": 262450288831121.97,
 "bhd": 842141987223.7041,
 "bmd": 2234201360520.4795,
 "brl": 12192483664632.354,
 "cad": 3061190994117.1353,
 "chf": 1926585346197.2185,
 "clp": 2082007563841825.2,
 "cny": 15983253113027.484,
 "czk": 51038654430070.125,
 "dkk": 15119034982160.447,
 "eur": 2026025180351.2646,
 "gbp": 1738523680876.7683,
 "gel": 6021172666602.696,
 "hkd": 17400641627148.445,
 "huf": 798647220929097.5,
 "idr": 34934082777853616,
 "ils": 8304729769378.447,
 "inr": 187582750853615.28,
 "jpy": 328508945234923.8,
 "krw": 3027979083729289.5,
 "kwd": 683857757636.2719,
 "lkr": 668305770177663.2,
 "mmk": 4687354454371952,
 "mxn": 42304044211115.11,
 "myr": 9875170013500.51,
 "ngn": 3552380163227565.5,
 "nok": 23830212897246.156,
 "nzd": 3713376713266.6543,
 "php": 127231069345962.44,
 "pkr": 622566902776309.5,
 "pln": 8697962614038.214,
 "rub": 204092551606484.78,
 "sar": 8387813015372.104,
 "sek": 23233850933290.562,
 "sgd": 2938522168417.7593,
 "thb": 78057410033184.11,
 "try": 74986055657078.28,
 "twd": 71891012043946.4,
 "uah": 91810242054393.2,
 "vef": 223710582228.9158,
 "vnd": 55964181548148344,
 "zar": 40355384955476.02,
 "xdr": 1674290391761.803,
 "xag": 79978577441.08212,
 "xau": 903131215.9631954,
 "bits": 36706851534313.39,
 "sats": 3670685153431339
 },
 "total_volume": {
 "btc": 1300284.5544770353,
 "eth": 29065147.099440906,
 "ltc": 1242230781.516763,
 "bch": 230309922.0069229,
 "bnb": 150172583.40485272,
 "eos": 157334652905.51584,
 "xrp": 137289120116.35336,
 "xlm": 802290298647.1266,
 "link": 7490465635.490247,
 "dot": 17464112069.74369,
 "yfi": 15685846.728596153,
 "usd": 79143195323.10437,
 "aed": 290690582125.90283,
 "ars": 74374145087727.06,
 "aud": 119248138977.93906,
 "bdt": 9296903510401.496,
 "bhd": 29831602899.52833,
 "bmd": 79143195323.10437,
 "brl": 431900245517.2449,
 "cad": 108438049071.95146,
 "chf": 68246364475.042786,
 "clp": 73751960857694.53,
 "cny": 566182505021.9573,
 "czk": 1807966939759.8328,
 "dkk": 535568888209.4403,
 "eur": 71768869812.48354,
 "gbp": 61584565151.915825,
 "gel": 213290911395.76642,
 "hkd": 616391343850.9102,
 "huf": 28290866757650.367,
 "idr": 1237486909450757.2,
 "ils": 294182459046.75397,
 "inr": 6644834504350.314,
 "jpy": 11636931244217.75,
 "krw": 107261567507968.17,
 "kwd": 24224624083.667736,
 "lkr": 23673718510495.766,
 "mmk": 166042423787872.47,
 "mxn": 1498556617644.1492,
 "myr": 349812923328.121,
 "ngn": 125837680563736.06,
 "nok": 844149156492.5692,
 "nzd": 131540739218.71835,
 "php": 4506967702351.214,
 "pkr": 22053488489796.285,
 "pln": 308112136282.79224,
 "rub": 7229669161073.239,
 "sar": 297125557051.2336,
 "sek": 823023938224.144,
 "sgd": 104092691932.73645,
 "thb": 2765065386600.954,
 "try": 2656267315133.489,
 "twd": 2546630088365.9966,
 "uah": 3252238606586.2964,
 "vef": 7924608147.702447,
 "vnd": 1982446269001893.2,
 "zar": 1429528318399.3167,
 "xdr": 59309198286.37652,
 "xag": 2833119828.82734,
 "xau": 31992053.845458552,
 "bits": 1300284554477.0354,
 "sats": 130028455447703.53
 },
 "market_cap_percentage": {
 "btc": 53.77673792724629,
 "eth": 14.664281084650966,
 "usdt": 5.1989697163076105,
 "bnb": 3.4398307823523515,
 "sol": 3.0539106363546957,
 "usdc": 1.546515331116927,
 "xrp": 1.448619967339368,
 "steth": 1.1935413719309236,
 "ton": 0.7911511842997474,
 "doge": 0.6886749982824419
 },
 "market_cap_change_percentage_24h_usd": 2.7459588695163384,
 "updated_at": 1723628820
 }
 }
 */

struct GlobalData: Codable {
    let data: MarketData?
}

// MARK: - DataClass
struct MarketData: Codable {
    let activeCryptocurrencies, upcomingIcos, ongoingIcos, endedIcos: Int?
    let markets: Int?
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]?
    let marketCapChangePercentage24HUsd: Double?
    let updatedAt: Int?

    enum CodingKeys: String, CodingKey {
        case activeCryptocurrencies = "active_cryptocurrencies"
        case upcomingIcos = "upcoming_icos"
        case ongoingIcos = "ongoing_icos"
        case endedIcos = "ended_icos"
        case markets
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
        case updatedAt = "updated_at"
    }
    
    var marketCap: String {
        if let item = totalMarketCap?.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume?.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage?.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
}
