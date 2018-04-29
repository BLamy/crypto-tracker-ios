//
//  AddTransactionViewController.swift
//  crypto-tracker-ios
//
//  Created by Brett Lamy on 4/26/18.
//  Copyright © 2018 Brett Lamy. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textbox: UITextField!
    
    var type: TransactionType = .Buy {
        didSet {
            self.submitButton.titleLabel?.text = "\(self.type)"
        }
    }
    
    
    // MARK: Private Helpers
    
    private func invalidAlert(_ message: String) {
        let alertController = UIAlertController(title: "Invalid Amount", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CoinType.allSupported.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(CoinType.allSupported[row])"
    }

    
    // MARK: IBActions
    
    @IBAction func onSubmit(_ sender: Any) {
        let coinType = CoinType.allSupported[self.picker.selectedRow(inComponent: 0)]
        
        if let ammount = Double(self.textbox.text!) {
            if ammount < 0 {
                self.invalidAlert("Please only enter positive numbers")
                return
            }
            
            let oldAmmount = Ledger.shared.balance(for: coinType)
            if self.type == .Sell && oldAmmount - ammount < 0 {
                self.invalidAlert("You do not have that much \(coinType) to sell")
                return
            }
            
            Ledger.shared.add(transaction: Transaction(coin: coinType, ammount: ammount, type: self.type))
            self.dismiss(animated: true, completion: nil)
        } else {
            let type = "\(self.type)".lowercased()
            self.invalidAlert("Please enter a valid ammount to \(type)")
        }
    }
    
    @IBAction func closeViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didToggleTransactionType(_ sender: UISegmentedControl) {
        self.type = sender.selectedSegmentIndex == 0 ? .Buy : .Sell;
    }
    
    
    // MARK: Lifecycle Hooks
    
    override func viewWillAppear(_ animated: Bool) {
        self.textbox.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
