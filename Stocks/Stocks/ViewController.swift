//
//  ViewController.swift
//  Stocks
//
//  Created by Mikhail on 19.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var companies = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        
        // 3
        loadCompanies()
    }
    
    private func loadCompanies() {
        request(urlString: APIConstants.shared.getCompaniesURL()) { (data) in
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                
                guard
                    let json = jsonObject as? [[String: Any]]
                else {
                    print("Invalid json format")
                    return
                }
                
                json.forEach { (dict) in
                    if let companyName = dict["companyName"] as? String,
                        let symbol = dict["symbol"] as? String {
                        self.companies[companyName] = symbol
                    }
                }
                
                DispatchQueue.main.async {
                    self.companyPickerView.reloadComponent(0)
                    self.requestUpdate()
                }
                
            } catch {
                print("json parsing error:", error.localizedDescription)
            }
        }
        
    }
    
    private func requestUpdate() {
        if companies.count == 0 {
            companies = [
                "Apple": "AAPL",
                "Microsoft": "MSFT",
                "Google": "GOOG",
                "Amazon": "AMZN",
                "Facebook": "FB"
            ]
        }
            
        self.activityIndicator.startAnimating()
        [companyNameLabel, companySymbolLabel, priceLabel, priceChangeLabel].forEach { (label) in
            label.text = "-"
        }
        
        let selectedRow = companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(companies.values)[selectedRow]
        request(urlString: APIConstants.shared.getDetailsURL(for: selectedSymbol)) { (data) in
            self.parseQuote(data: data)
        }
        
        // 2
        request(urlString: APIConstants.shared.getLogoURL(for: selectedSymbol)) { (data) in
            self.parseImage(data: data)
        }
    }
    
    private func request(urlString: String, complition: @escaping (_ data: Data) -> ()) {
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200
            else {
                // 5
                DispatchQueue.main.async {
                    self.showError(description: "Network error \((response as? HTTPURLResponse)?.statusCode ?? 404)")
                }
                return
            }
            
            complition(data)
            
        }.resume()
    }
    
    private func parseQuote(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double
            else {
                print("Invalid json format")
                return
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName, symbol: companySymbol, price: price, priceChange: priceChange)
            }
            
        } catch {
            print("json parsing error:", error.localizedDescription)
        }
    }
    
    private func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double) {
        activityIndicator.stopAnimating()
        companyNameLabel.text = companyName
        companySymbolLabel.text = symbol
        priceLabel.text = "\(price)"
        
        // 1
        priceChangeLabel.textColor = priceChange < 0 ? .red : .green
        priceChangeLabel.text = "\(priceChange)"
    }
    
    private func parseImage(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let url = json["url"] as? String
            else {
                print("Invalid json format")
                return
            }
            self.loadImage(for: url)
            
        } catch {
            print("json parsing error:", error.localizedDescription)
        }
    }
    
    private func loadImage(for url: String) {
        let url = URL(string: url)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200
            else {
                print("Can not load image due to network error")
                return
            }
            
            DispatchQueue.main.async {
                self.companyLogo.image = UIImage(data: data)
            }
            
        }.resume()
    }
    
    private func showError(description: String) {
        let alert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return companies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let selectedSymbol = Array(companies.values)[row]
//        requestQuote(for: selectedSymbol)
        requestUpdate()
    }
    
}
