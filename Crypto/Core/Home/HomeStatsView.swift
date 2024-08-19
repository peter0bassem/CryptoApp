//
//  HomeStatsView.swift
//  Crypto
//
//  Created by iCommunity app on 14/08/2024.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Binding var showPortofolio: Bool
    
    var body: some View {
//        GeometryReader { proxy in
//            HStack {
//                ForEach(homeViewModel.statistics) {
//                    StatisticView(statistic: $0)
//                        .frame(width: proxy.size.width / 3)
//                }
//            }
//            .frame(width: proxy.size.width, alignment: showPortofolio ? .trailing : .leading)
//        }
//        .background(Color.blue)
//        .frame(height: homeViewModel.statisticViewHeight)
//        .onAppear {
//            let _ = print("self.homeViewModel.statisticViewHeight in HomeStatsView: \(self.homeViewModel.statisticViewHeight)")
//        }
        
        
        
        HStack {
            ForEach(homeViewModel.statistics) {
                StatisticView(statistic: $0)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortofolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(showPortofolio: .constant(false))
        .environmentObject(DeveloperPreview.shared.homeViewModel)
}
