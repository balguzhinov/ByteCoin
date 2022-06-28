//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Абай on 19/02/2022.
//

import Foundation

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "FD07366E-A714-426E-8880-D240940B88A4"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil{
                    print("error")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coinData = self.parseJSON(safeData) {
                        self.delegate?.didUpdatePrice(self, data: coinData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinData?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let coinData = CoinData(rate: decodedData.rate, asset_id_quote: decodedData.asset_id_quote)
            return coinData
        } catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
protocol CoinManagerDelegate{
    func didFailWithError(error: Error)
    func didUpdatePrice(_ coinManager: CoinManager, data: CoinData)
}
