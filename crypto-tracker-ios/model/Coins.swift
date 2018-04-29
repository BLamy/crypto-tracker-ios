//
//  Coins.swift
//  crypto-tracker-ios
//
//  Created by Brett Lamy on 4/26/18.
//  Copyright © 2018 Brett Lamy. All rights reserved.
//

import Foundation

enum CoinTypes {
    case BTC
    case ETH
    case BCH
    case LTC
    
    static let allSupported = [BTC, ETH, BCH, LTC]
}
