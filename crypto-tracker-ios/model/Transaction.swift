//
//  Transaction.swift
//  crypto-tracker-ios
//
//  Created by Brett Lamy on 4/26/18.
//  Copyright © 2018 Brett Lamy. All rights reserved.
//

import Foundation

enum TransactionType: Int, Codable {
    case Buy
    case Sell
}

class Transaction: Codable {
    public var coin: CoinType
    public var ammount: Double
    public var type: TransactionType
    public let timestamp = Date()
    
    init(coin: CoinType, ammount: Double, type: TransactionType) {
        self.coin = coin
        self.ammount = ammount
        self.type = type
    }
}
