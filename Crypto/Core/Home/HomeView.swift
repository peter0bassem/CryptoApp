//
//  HomeView.swift
//  Crypto
//
//  Created by iCommunity app on 31/07/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortofolio = false // animate right
    @State private var showPortofolioView = false // new sheet
    @EnvironmentObject private var viewModel: HomeViewModel
    
    enum CurrentCoinCollection {
        case all, portfolio
    }
    @State var currentCoinsCollectionState: CurrentCoinCollection = .all
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView: Bool = false
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        ZStack {
            // Background
            Color.theme.background
                .ignoresSafeArea()
            
            // Content
            VStack  {
                homeHeader
                HomeStatsView(showPortofolio: $showPortofolio)
                SearchBarView(searchPlaceholder: "Search by name or symbol...", searchText: $viewModel.searchText)
                coinsHeader
                if !showPortofolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                if showPortofolio {
                    ZStack(alignment: .top) {
                        if viewModel.portofolioCoins.isEmpty && viewModel.searchText.isEmpty {
                            portofolioEmptyText
                        } else {
                            portofolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
//            .gesture(
//                DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                    .onEnded { value in
//                        switch(value.translation.width) {
//                        case (...0):
//                            if currentCoinsCollectionState == .all {
//                                currentCoinsCollectionState = .portfolio
//                                withAnimation(.spring) {
//                                    showPortofolio.toggle()
//                                }
//                            }
//                            case (0...): 
//                            if currentCoinsCollectionState == .portfolio {
//                                currentCoinsCollectionState = .all
//                                withAnimation(.spring) {
//                                    showPortofolio.toggle()
//                                }
//                            }
//                            withAnimation(.spring) {
//                                showPortofolio.toggle()
//                            }
//                        default: break
//                        }
//                    }
//            )
            
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin), isActive: $showDetailView, label: { 
                EmptyView()
            })
        )
        .sheet(isPresented: $showPortofolioView, content: {
            PortofolioView()
                .environmentObject(viewModel)
        })
        .sheet(isPresented: $showSettingsView, content: {
            SettingsView()
        })
    }
    
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortofolio ? "plus" : "info")
                .animation(.none, value: showPortofolio)
                .onTapGesture {
                    if showPortofolio {
                        showPortofolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortofolio)
                )
            Spacer()
            Text(showPortofolio ? "Portofolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(.none, value: showPortofolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortofolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortofolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var coinsHeader: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(.degrees(viewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            if showPortofolio {
                Spacer()
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(.degrees(viewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
                Spacer()
            } else {
                Spacer()
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(.degrees(viewModel.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    viewModel.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(.degrees(viewModel.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
        .animation(.none, value: showPortofolio)
    }
    
    private var allCoinsList: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewModel.allCoins) { coin in
                    CoinRowView(coin: coin, showHoldingsColums: showPortofolio)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                        .onTapGesture {
                            segue(coin: coin)
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
        
    }
    
    private var portofolioEmptyText: some View {
        Text("You haven't added any coins to your portofolio yet. Click + Button to get started.")
            .font(.callout)
            .foregroundStyle(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private var portofolioCoinsList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.portofolioCoins) { coin in
                    CoinRowView(coin: coin, showHoldingsColums: showPortofolio)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                        .onTapGesture {
                            segue(coin: coin)
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

struct HomeView_PreviewProvicer: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
                .toolbar(.hidden, for: .navigationBar)
        }
        .environmentObject(dev.homeViewModel)
    }
}
