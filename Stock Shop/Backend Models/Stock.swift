//
//  Stock.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/3/21.
//

import Foundation

class Stock: Codable{
    private var symbol: String
    private var name: String
    private var price: Double
    private var change: Double
    //private var currentUser = User.sharedInstance
    
    init(symbol: String){
        //retrieve from firestore database
        self.symbol = symbol
        let requester = TiingoRequest()
        self.name = "TEST NAME"
        _ = ""
        let closingprice = [200.5,200.5]
        self.price = closingprice[1]
        self.change = 0
        requester.getInitialStockInfo(symbol){
            stockname in
            //print("RETURNED NAME: \(stockname)")
            self.name = stockname
            //print("SET NAME \(self.name)")
        }
        //print("NAME CHANGED: \(self.name)")
        requester.getStockPriceInfo(symbol){
            priceData in
            //print ("RETURNED DATA: \(priceData)")
            self.price = priceData[1]
            //print("SET DATA: \(self.price)")
        }
        //print("PRICE CHANGED: \(self.price)")
        //self.change = 0
        
        //retrieve from Tiingo API
    }
    init(){
        self.symbol = "TESTE"
        self.name = "test name"
        self.price = 200.5
        self.change = 0
    }
    
    func getSymbol()->String{
        return self.symbol
    }
    
    func updateStockValues(handler: @escaping (Stock)->Void){
        let stockSymbol = self.symbol
        let requester = TiingoRequest()
        requester.getStockPriceInfo(stockSymbol){
            stockValues in
            self.price = stockValues[0]
            var currentChange: Double = stockValues[1] - stockValues[0]
            currentChange = currentChange / stockValues[1]
            self.change = currentChange
            handler(self)
        }
       

    }
    
    func getPrice()->Double{
        //call from API and set it

        return self.price
        //retrieve price from tingo API
    }
    
    func getChange()->Double{
        return self.change
    }
    
    init(symbol: String, completion: @escaping (Stock)->(Void)){
        //retrieve from firestore database
        self.symbol = symbol
        let requester = TiingoRequest()
        self.name = "TEST NAME"
        _ = ""
        let closingprice = [200.5,200.5]
        self.price = closingprice[1]
        self.change = 0
        requester.getInitialStockInfo(symbol){
            stockname in
            //print("RETURNED NAME: \(stockname)")
            self.name = stockname
            //print("SET NAME \(self.name)")
        }
        //print("NAME CHANGED: \(self.name)")
        requester.getStockPriceInfo(symbol){
            priceData in
            //print ("RETURNED DATA: \(priceData)")
            self.price = priceData[1]
            self.change = priceData[1]-priceData[0]
            self.change = self.change / priceData[0]
            //print("SET DATA: \(self.price)")
            completion(self)
        }
        //print("PRICE CHANGED: \(self.price)")
        //self.change = 0
        
        //retrieve from Tiingo API
    }

    
}
