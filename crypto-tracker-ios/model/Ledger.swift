//
//  Ledger.swift
//  crypto-tracker-ios
//
//  Created by Brett Lamy on 4/26/18.
//  Copyright © 2018 Brett Lamy. All rights reserved.
//

import Foundation

class Ledger {
    
    private var transactions: [Transaction] = []
    
    private init(_ transactions: [Transaction]) {
        self.transactions = transactions
    }
    
    public static let shared: Ledger = {
        if let data = UserDefaults.standard.data(forKey: "transactions") {
            let transactions = try? JSONDecoder().decode([Transaction].self, from: data)
            return Ledger(transactions!)
        }
        return Ledger([])
    }()

    public func add(transaction: Transaction) {
        self.transactions.append(transaction)
        let data = try? JSONEncoder().encode(self.transactions)
        UserDefaults.standard.set(data, forKey: "transactions")
    }
    
    public func getTransactions() -> [Transaction] {
        return self.transactions
    }
    
    public func getTransactions(for coin: CoinType) -> [Transaction] {
        return self.transactions.filter({ transaction -> Bool in
            transaction.coin == coin
        })
    }
    
    public func balance(for coin: CoinType) -> Double {
        return self.transactions.reduce(0.0) { (total, transaction) -> Double in
            if (transaction.coin != coin) {
                return total
            }
            if (transaction.type == .Buy) {
                return total + transaction.ammount
            } else {
                return total - transaction.ammount
            }
        }
    }
}
