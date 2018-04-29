//
//  CoinDetailsViewController.swift
//  crypto-tracker-ios
//
//  Created by Brett Lamy on 4/26/18.
//  Copyright © 2018 Brett Lamy. All rights reserved.
//

import UIKit

class CoinDetailsViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var chart: Chart!
    public var coin: CoinType = .BTC
    
    var selectedInterval = HistoryInterval.week {
        didSet {
            self.refreshPrices(self)
        }
    }
    
    var history: [CoinHistory] = [] {
        didSet {
            self.reloadChart()
        }
    }
    
    // MARK: Private Helpers
    
    func reloadChart() {
        // We will create a new series each time so we must remove the old ones
        self.chart.removeAllSeries()
        
        // Figure out the date range bounds
        let min = self.history.first!.time
        let max = self.history.last!.time

            
        // Creates an evenly distributed scale ranging between the min and max timestamps
        let numberOfLabels: Int = self.selectedInterval == .year ? 11 : 6;
        let xInterval = (max - min) / Double(numberOfLabels)
        self.chart.xLabels = (0...numberOfLabels).map { i -> Double in
            min + (xInterval * Double(i))
        };
        
        // Formats the labels to friendly strings
        self.chart.xLabelsFormatter = {
            let dateFormatter = DateFormatter()
            switch self.selectedInterval {
            case .day:
                dateFormatter.dateFormat = "h a"
                return dateFormatter.string(from: Date.init(timeIntervalSince1970: $1))
            case .week:
                dateFormatter.dateFormat = "E"
                return dateFormatter.string(from: Date.init(timeIntervalSince1970: $1))
            case .month:
                dateFormatter.dateFormat = "MM/dd"
                return dateFormatter.string(from: Date.init(timeIntervalSince1970: $1))
            case .year:
                dateFormatter.dateFormat = "MM"
                let monthNumber = Int(dateFormatter.string(from: Date.init(timeIntervalSince1970: $1)))!
                return DateFormatter().shortMonthSymbols[monthNumber - 1]
            }
        }
        
        // Add the series to the chart
        self.chart.add(ChartSeries(data: self.history.map { his -> (x: Double, y: Double) in
            (x: his.time, y: his.mean)
        }))
        
        // Force a reload of the chart
        chart.setNeedsDisplay()
    }
    
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ledger.shared.getTransactions(for: self.coin).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let transaction = Ledger.shared.getTransactions(for: self.coin)[indexPath.row]
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"

        cell.title?.text = "\(transaction.coin)"
        cell.subtitle?.text = dateFormatter.string(from: transaction.timestamp)
        cell.detail?.text = "\(transaction.ammount)"
        cell.detail?.textColor = transaction.type == .Buy ? .green : .red
        return cell
    }
    
    // MARK: IBActions
    
    @IBAction func refreshPrices(_ sender: Any) {
        API.getHistoricalPrices(coin: self.coin, interval: self.selectedInterval) { history, error in
            self.history = history;
        }
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.selectedInterval = .day
            break
        case 1:
            self.selectedInterval = .week
            break
        case 2:
            self.selectedInterval = .month
            break
        case 3:
            self.selectedInterval = .year
            break
        default:
            break
        }
    }
    
    // MARK: Lifecycle Hooks
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(self.coin.rawValue)"
        self.refreshPrices(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        chart.setNeedsDisplay()
    }
}


