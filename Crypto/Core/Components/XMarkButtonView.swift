//
//  XMarkButtonView.swift
//  Crypto
//
//  Created by iCommunity app on 14/08/2024.
//

import SwiftUI

struct XMarkButtonView: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Image(systemName: "xmark")
        })
    }
}

#Preview {
    XMarkButtonView(action: { })
}
