//
//  ViewController.swift
//  ByteCoin
//
//  Created by Абай on 19/02/2022.
//

import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var coinManager = CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        coinManager.delegate = self
        currencyLabel.text = ""
        bitcoinLabel.text = "Select a currency"

    }
}
//MARK: - Coin Manager Delegate
    extension ViewController : CoinManagerDelegate{
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdatePrice(_ coinManager: CoinManager, data: CoinData) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.1f", data.rate)
            self.currencyLabel.text = data.asset_id_quote
        }
    }
    }
    
//MARK: - UI Picker View Data Source and Delegate
extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
    




