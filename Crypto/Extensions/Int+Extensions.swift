//
//  Int+Extensions.swift
//  Crypto
//
//  Created by iCommunity app on 01/08/2024.
//

import Foundation

extension Int {
    func toString() -> String {
        return String(self)
    }
}

extension Int? {
    func toString() -> String {
        return String(self ?? 0)
    }
    
    func removeOptional() -> Int {
        return self ?? 0
    }
}
