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
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let companies = [
        "Apple": "AAPL",
        "Microsoft": "MSFT",
        "Google": "GOOG",
        "Amazon": "AMZN",
        "Facebook": "FB"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        requestQuote(for: "AAPL")
    }
    
    private func requestQuote(for symbol: String) {
        let url = URL(string: "https://finance.yahoo.com/quote/AAPL\(symbol)")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200
            else {
                print("Network error")
                return
            }
            
            self.parseQuote(data: data)
            
        }.resume()
    }
    
    private func parseQuote(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String
            else {
                print("Invalid json format")
                return
            }
            
            print("company name", companyName)
            
        } catch {
            print("json parsing error:", error.localizedDescription)
        }
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
        
    }
    
}
