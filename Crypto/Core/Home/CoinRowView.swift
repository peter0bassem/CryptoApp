//
//  CoinRowView.swift
//  Crypto
//
//  Created by iCommunity app on 01/08/2024.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldingsColums: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            rankAndCoinBasicInfo
            holdingsColumn
            coinPriceAndChangePercentage
        }
        .font(.subheadline)
        .contentShape(Rectangle())
        .padding(.trailing, 20)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingsColums: false)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, showHoldingsColums: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CoinRowView {
    @ViewBuilder
    private var rankAndCoinBasicInfo: some View {
        Text(coin.rank.toString())
            .font(.caption)
            .foregroundStyle(Color.theme.secondaryText)
            .frame(minWidth: 30)
        CoinImageView(coin: coin)
            .frame(width: 30, height: 30)
        Text(coin.symbol.removeOptional().uppercased())
            .font(.headline)
            .padding(.leading, 6)
            .foregroundStyle(Color.theme.accent)
    }
    
    @ViewBuilder
    private var holdingsColumn: some View {
        if showHoldingsColums {
            Spacer()
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                    .bold()
                Text(coin.currentHoldings.asNumberString())
                
            }
            .foregroundStyle(Color.theme.accent)
            Spacer()
        } else {
            Spacer()
        }
    }
    
    private var coinPriceAndChangePercentage: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            Text(coin.priceChangePercentage24H.asPercentString())
                .foregroundStyle(coin.priceChangePercentage24H.removeOptional() >= 0 ? Color.theme.green : Color.theme.red)
        }
    }
}
