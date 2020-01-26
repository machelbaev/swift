//
//  APIConstants.swift
//  Stocks
//
//  Created by Mikhail on 26.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

struct APIConstants {
    
    static let shared = APIConstants()
    
    let token = "pk_fc7b67021ff740fead2a925feb18ba4a"
    
    func getDetailsURL(for symbol: String) -> String {
        return "https://cloud.iexapis.com/stable/stock/\(symbol)/quote/?token=\(self.token)"
    }
    
    func getLogoURL(for symbol: String) -> String {
        return "https://cloud.iexapis.com/stable/stock/\(symbol)/logo/?token=\(self.token)"
    }
    
    func getCompaniesURL() -> String {
        return "https://cloud.iexapis.com/stable/stock/market/list/mostactive?token=\(token)"
    }
}
