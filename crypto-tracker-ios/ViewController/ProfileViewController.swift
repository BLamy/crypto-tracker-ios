//
//  SecondViewController.swift
//  crypto-tracker-ios
//
//  Created by Brett Lamy on 4/26/18.
//  Copyright © 2018 Brett Lamy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    var prices: [CoinType: Double] = [:] {
        didSet {
            self.tableView.reloadData()
            let networth = self.prices.reduce(0) { (acc: Double, keyValue: (CoinType, Double)) -> Double in
                acc + Ledger.shared.balance(for: keyValue.0) * keyValue.1
            }
            self.title = "$\(networth)"
        }
    }

    // MARK: IBActions
    
    @IBAction func refreshPrices(_ sender: Any) {
        API.getPrices(coins: CoinType.allSupported, currency: .USD) { prices, error in
            self.prices = prices;
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let coin = CoinType.allSupported[indexPath.row]
        let balance = Ledger.shared.balance(for: coin)
        let total = balance * prices[coin]!
        let cellText = NSMutableAttributedString(string: coin.rawValue)
        cellText.append(NSAttributedString(string: "(\(coin))", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.gray ]))
        cell.title?.attributedText = cellText
        cell.subtitle?.text = "\(balance)"
        cell.detail?.text = "$\(total)"
        return cell
    }
    
    // MARK: Lifecycle Hooks
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.title = "Profile";
        if segue.identifier == "viewDetails" {
            if let cell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPath(for: cell)!
                let vc = segue.destination as! CoinDetailsViewController
                vc.coin = CoinType.allSupported[indexPath.row]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshPrices(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

