//
//  CurrencyType.swift
//  crypto-tracker-ios
//
//  Created by Brett Lamy on 4/26/18.
//  Copyright © 2018 Brett Lamy. All rights reserved.
//

import Foundation

// The cryptocompare API supports converting to several different currencies.
// We only support USD
public enum CurrencyType: Int {
    case USD
    static let allSupported = [USD]
}
