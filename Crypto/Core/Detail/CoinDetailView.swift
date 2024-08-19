//
//  CoinDetailView.swift
//  Crypto
//
//  Created by iCommunity app on 19/08/2024.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    var body: some View {
        ZStack {
            if let coin = coin {
                CoinDetailView(coin: coin)
            }
        }
    }
}

struct CoinDetailView: View {
    
    let coin: Coin
    @StateObject private var coinDetailViewModel: CoinDetailViewModel
    @State private var showFullDescription: Bool = false
    
    private let colums: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        self.coin = coin
        self._coinDetailViewModel = StateObject(wrappedValue: CoinDetailViewModel(with: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: coin)
                    .padding(.vertical)
                VStack(spacing: 20, content: {
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalDetailsTitle
                    Divider()
                    additionalStatisticsGrid
                    websiteSection
                })
                .padding()
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle(coin.name ?? "")
        .navigationBarTitleDisplayMode(.large)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItems
            }
        })
    }
}

extension CoinDetailView {
    @ViewBuilder
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = coinDetailViewModel.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
//                                .animation(showFullDescription ? Animation.easeInOut : .none, value: showFullDescription)
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "See less..." : "See more...")
                            .font(.caption)
                            .bold()
                    }
                    .tint(Color.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    @ViewBuilder
    private var overviewGrid: some View {
        LazyVGrid(
            columns: colums,
            alignment: .leading,
            spacing: spacing) {
                ForEach(coinDetailViewModel.statistics) { statistic in
                    StatisticView(statistic: statistic)
                }
            }
    }
    
    @ViewBuilder
    private var additionalDetailsTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var additionalStatisticsGrid: some View {
        LazyVGrid(
            columns: colums,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(coinDetailViewModel.additionalStatistics) { statistic in
                    StatisticView(statistic: statistic)
                }
            }
    }
    
    @ViewBuilder
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(coin.symbol.removeOptional().uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: coin)
                .frame(width: 25, height: 25)
        }
    }
    
    @ViewBuilder
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteURL = coinDetailViewModel.websiteURL,
            let url = URL(string: websiteURL) {
                Link("Website", destination: url)
            }
            if let redditURL = coinDetailViewModel.redditURL,
            let url = URL(string: redditURL) {
                Link("Reddit", destination: url)
            }
        }
        .tint(Color.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}

#Preview {
    NavigationView {
        CoinDetailView(coin: DeveloperPreview.shared.coin)
    }
}
