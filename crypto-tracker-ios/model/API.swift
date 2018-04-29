//
//  API.swift
//  crypto-tracker-ios
//
//  Created by Brett Lamy on 4/26/18.
//  Copyright © 2018 Brett Lamy. All rights reserved.
//

import Foundation



class API {
    
    static fileprivate let queue = DispatchQueue(label: "requests.queue", qos: .utility)
    static fileprivate let mainQueue = DispatchQueue.main
    
    fileprivate class func make(session: URLSession = URLSession.shared, request: URLRequest, closure: @escaping (_ json: [String: Any]?, _ error: Error?)->()) {
        let task = session.dataTask(with: request) { data, response, error in
            queue.async {
                guard error == nil else {
                    return
                }
                guard let data = data else {
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        mainQueue.async {
                            closure(json, nil)
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                    mainQueue.async {
                        closure(nil, error)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    class func getPrices(coins: [CoinType], currency: CurrencyType = .USD, closure: @escaping (_ prices: [CoinType: Double], _ error: Error?)->()) {
        let strCoins = coins.map { (coin) -> String in
            return "\(coin)"
        }.joined(separator: ",")
        
        let url = URL(string: "https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(strCoins)&tsyms=\(currency)")
        
        API.make(request: URLRequest(url: url!)) { json, error in
            var prices: [CoinType: Double] = [:]
            
            for (key, value) in json! {
                let coin = CoinType.allSupported.first(where: { (coin) -> Bool in
                    return "\(coin)" == key
                })!
                let price = value as! [String: NSNumber]
                prices[coin] = (price["\(currency)"])!.doubleValue
            }
            
            closure(prices, error)
        }
    }
    
    class func getHistoricalPrices(coin: CoinType, interval: HistoryInterval, currency: CurrencyType = .USD, closure:@escaping (_ history: [CoinHistory], _ error: Error?)->()) {
        // You can get either 1 report per hour or 1 report per day. Only the 24h report gets hourly.
        let apiForInterval = interval == .day ? "histohour" : "histoday"
        
        // Their limit is weird. Will return 8 records if you limit to 7.
        var limit: Int;
        switch interval {
        case .day:
            limit = 23
            break;
        case .week:
            limit = 6
            break;
        case .month:
            limit = 30
            break;
        case .year:
            limit = 364
            break
        }
        
        let url = URL(string: "https://min-api.cryptocompare.com/data/\(apiForInterval)?fsym=\(coin)&tsym=\(currency)&limit=\(limit)")

        API.make(request: URLRequest(url: url!)) { json, error in
            var history: [CoinHistory] = []
            
            let items = json!["Data"] as! [[String: Double]]
            for item in items {
                history.append(CoinHistory(
                    time: TimeInterval(item["time"]!),
                    close: item["close"]!,
                    high: item["high"]!,
                    low: item["low"]!,
                    open: item["open"]!,
                    volumefrom: item["volumefrom"]!,
                    volumeto: item["volumeto"]!
                ))
            }
            
            closure(history, error)
        }
    }
    
}
