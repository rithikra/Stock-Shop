//
//  Trade.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/3/21.
//

import Foundation

class Trade: Codable{
    private var symbol: String
    private var type: String
    private var date: String
    private var targetDate: String
    private var optionCost: Double
    private var optionStrikePrice: Double
    
    private var expectedROI: Double
    
    private var minPrice: Double
    private var maxPrice: Double
    private var confidence: Int
    private var initialStockPrice: Double
    
    /*init(completion: @escaping ()->()){
        self.symbol = "AAPL"
        self.type = "Call"
        self.targetDate = "12/16/2022"
        self.optionStrikePrice = 15.45
        self.minPrice = 120.55
        self.maxPrice = 150.66
        self.initialStockPrice = 0
        /*let stock = Stock(symbol){
            self.initialStockPrice = stock.getPrice()
            completion();
        }*/
        
    }*/
    
    init(_ symbol: String, _ type: String, _ date: String, _ targetDate: String, _ optionCost: Double, _ optionStrikePrice: Double,
         _ minPrice: Double, _ maxPrice: Double, _ confidence: Int, _ initialStockPrice: Double){
        self.symbol = symbol
        self.type = type
        self.date = date
        self.targetDate = targetDate
        self.optionCost = optionCost
        self.optionStrikePrice = optionStrikePrice
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.confidence = confidence
        //calculate ROI here
        self.initialStockPrice = 150.00
        
        
        self.expectedROI = 0
        
        //calculate expected ROI
    }
    
    func getSymbol()->String{
        return self.symbol
    }
    
    func getType()->String{
        return self.type
    }
    
    func getExpiration()->String{
        return self.targetDate
    }
    func getMinPrice()->Double{
        return self.minPrice
    }
    
    func getInitialPrice()->Double{
        return self.initialStockPrice
    }
    
    func getOptionStrikePrice()->Double{
        return self.optionStrikePrice
    }
    
    
    
}
