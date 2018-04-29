//
//  CoinHistory.swift
//  crypto-tracker-ios
//
//  Created by Brett Lamy on 4/28/18.
//  Copyright © 2018 Brett Lamy. All rights reserved.
//

import Foundation

class CoinHistory {
    
    public let time: TimeInterval
    public let close: Double
    public let high: Double
    public let low: Double
    public let open: Double
    public let volumefrom: Double
    public let volumeto: Double
    public var mean: Double { // Best day Average we can get
        get {
            return ((self.high + self.low + self.open + self.close) / 4)
        }
    }
    
    init(time: TimeInterval, close: Double, high: Double, low: Double, open: Double, volumefrom: Double, volumeto: Double) {
        self.time = time
        self.close = close
        self.high = high
        self.low = low
        self.open = open
        self.volumefrom = volumefrom
        self.volumeto = volumeto
    }
    
}
