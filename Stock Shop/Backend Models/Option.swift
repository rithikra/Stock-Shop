//
//  Option.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/4/21.
//

import Foundation

class Option{
    private var strikePrice: Double
    private var expirationDate: String
    private var type:  String
    private var Stock: String
    private var Delta: Double
    private var Gamma: Double
    private var Price: Double
    init(strikePrice: Double, expirationDate: String, Stock: String, Delta: Double, Gamma: Double, type: String, price: Double){
        self.strikePrice = strikePrice
        self.expirationDate = expirationDate
        self.Stock = Stock
        self.Price = price
        self.Delta = Delta
        self.Gamma = Gamma
        self.type = type
    }
    
    func getExpirationDate()->String{
        return self.expirationDate
    }
    
    func getStrikePrice()->Double{
        return self.strikePrice
    }
    
    func getDelta()->Double{
        return self.Delta
    }
    
    func getGamma()->Double{
        return self.Gamma
    }
    
    func getPrice()->Double{
        return self.Price
    }
    
    func getType()->String{
        return self.type
    }
}
