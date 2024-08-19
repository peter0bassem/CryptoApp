//
//  String+Extensions.swift
//  Crypto
//
//  Created by iCommunity app on 01/08/2024.
//

import Foundation

extension String? {
    func removeOptional() -> String {
        return String(self ?? "")
    }
}

extension String {
    func toDouble() -> Double? {
        return Double(self)
    }
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
