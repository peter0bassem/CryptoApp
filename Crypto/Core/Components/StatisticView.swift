//
//  StatisticView.swift
//  Crypto
//
//  Created by iCommunity app on 14/08/2024.
//

import SwiftUI

struct StatisticView: View {
    
    let statistic: Statistic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(statistic.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(.degrees(statistic.percentageChange.removeOptional() > 0 ? 0 : 180))
                Text(statistic.percentageChange.removeOptional().asPercentString())
                    .font(.caption)
                .bold()
            }
            .foregroundStyle(statistic.percentageChange.removeOptional() > 0 ? Color.theme.green : Color.theme.red)
            .opacity(statistic.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

#Preview {
    Group {
        StatisticView(statistic: DeveloperPreview.shared.statistic1)
        StatisticView(statistic: DeveloperPreview.shared.statistic2)
        StatisticView(statistic: DeveloperPreview.shared.statistic3)
    }
}
