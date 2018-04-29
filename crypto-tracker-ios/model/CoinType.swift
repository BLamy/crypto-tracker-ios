//
//  Coins.swift
//  crypto-tracker-ios
//
//  Created by Brett Lamy on 4/26/18.
//  Copyright © 2018 Brett Lamy. All rights reserved.
//

import Foundation

// Adding coins to this enum will automatically add them to the app.
// The cryptocompare API supports roughly 5000 coins. 
public enum CoinType: String, Codable {
    case BTC = "Bitcoin"
    case ETH = "Ethereum"
    case BCH = "Bitcoin Cash"
    case LTC = "Litecoin"
    case XRP = "Ripple"
    case XMR = "Monero"
    case DASH = "Dash"
    case USDT = "Tether"
    case DOGE = "Dogecoin"
    case REQ = "Request Network"
    
    static let allSupported = [BTC, ETH, BCH, LTC, XRP, XMR, DASH, USDT, DOGE, REQ]
}
