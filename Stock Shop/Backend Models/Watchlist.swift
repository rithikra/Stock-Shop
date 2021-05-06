//
//  Watchlist.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/3/21.
//

import Foundation

class Watchlist: Codable{
    private var stockList: [Stock]
    //testign out functionality of changes
    //trying to commit again
    //list of watching stocks
    //list of alarms
    //list of plays
   /* func setCurrentUser(currentUser: User){
        User.sharedInstance = currentUser
    }
    func getCurrentUser() ->User{
        return User.sharedInstance
    }*/
    init(){
        //retrieve from firestore database
        stockList = [Stock]()
        let appleStock = Stock(symbol: "AAPL")
        let teslaStock = Stock(symbol: "TSLA")
        stockList.append(appleStock)
        stockList.append(teslaStock)
        print(stockList[0].getPrice())
        
        
        //add in 3 base level stocks when initializing
        
    }
    func getStockList()->[Stock]{
        return self.stockList
    }
    
    func setStockList(setList: [Stock]){
        self.stockList = setList
    }
    
    func addStockList(_ currentStock: Stock){
        stockList.append(currentStock)
    }

    func deleteStockList(_ index: Int){
        //maybe add error bounding here --> checking if in range
        stockList.remove(at: index)
    }
    
}
