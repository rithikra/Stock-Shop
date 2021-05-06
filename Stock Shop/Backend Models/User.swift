//
//  User.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/1/21.
import Firebase
import CodableFirebase
//
class User: Codable{
    
    static var sharedInstance = User()
    private var userID: String?
    private var username: String?
    private var email: String?
    
    private var watchList: Watchlist?
    
    private var plannedTrades: [Trade]?
    
    public var selectedTrade: Trade?
    public var selectedStock: Stock?
    public var selectedIndex: Int?
    init(){
        
    }
    init(UID: String){
        //retrieve from firestore database
        self.userID = "null "
        username = "null "
        email = "null "
        watchList = Watchlist()
        plannedTrades = [Trade]()
        selectedIndex = 0
       // print("KEY PART OF TESTING")
        //print(watchList!.getStockList()[0].getPrice())
        Firestore.firestore().collection("users").document(UID).getDocument { document, error in
            if let error = error{
                print(error)
            }
            if let document = document {
                let model = try! FirestoreDecoder().decode(User.self, from: document.data()!)
                self.userID = model.userID
                self.email = model.email
                self.username = model.username
                self.watchList = model.watchList
                self.plannedTrades = model.plannedTrades
                self.selectedStock = model.selectedStock
                self.selectedIndex = model.selectedIndex
                //print(self.username)
                //print(self.email)
                print("Sucessful data recovery")
                
            }
        }
        User.sharedInstance = self
        
        
    }
    init(_ UID: String, _ UName: String, _ UEmail: String) {
        userID = UID
        username = UName
        email = UEmail
        watchList = Watchlist()
        plannedTrades = [Trade]()
        plannedTrades = newTradeInitation()
        selectedTrade = nil
        self.selectedStock = nil
        
        
            
        
        let docData = try! FirestoreEncoder().encode(self)
        Firestore.firestore().collection("users").document(UID).setData(docData){
            err in
            if let error = err{
                print("error writing document \(error)")
            }
            else{
                print("document written successfully")
            }
        }
        User.sharedInstance = self
        
        
        //place in firestore database
    }
    
    func newTradeInitation()->[Trade]{
        var _: Trade = Trade("AAPL", "CALL", "05/04/2021", "12/02/2022", 1550.50, 15.00, 12.5, 17.5, 8, 100.5)
        //plannedTrades.append(trade1)
        let trade2: Trade = Trade("TSLA", "CALL", "05/04/2021", "12/02/2022", 1550.50, 15.00, 12.5, 17.5, 8, 100.5)
        let trade3: Trade = Trade("AAPL", "CALL", "05/04/2021", "12/02/2022", 1550.50, 15.00, 12.5, 17.5, 8, 100.5)
        
        var newTrades = [Trade]()
        
        //newTrades.
        newTrades.append(trade2)
        newTrades.append(trade3)
        return newTrades
        
    }
    func getEmail()->String{
        if email != nil{
            return self.email!
        }
        else{
            return "email attribute nil"
        }
    }
    
    func getUsername()->String{
        if username != nil{
            return self.username!
        }
        else{
            return "username attribute nil"
        }
        
    }
    
    
    
    func setWatchList(_ newWatchList: Watchlist){
        self.watchList = newWatchList
        let docData = try! FirestoreEncoder().encode(self)
        Firestore.firestore().collection("users").document(self.userID!).setData(docData){
            err in
            if let error = err{
                print("error writing document \(error)")
            }
            else{
                //print("document written successfully")
            }
        }
        
    }
    
    func getWatchList()->Watchlist?{
        return self.watchList
    }
    
    func getTrades()->[Trade]?{
        return self.plannedTrades
    }
    
    func setTrades(trades: [Trade]){
        self.plannedTrades = trades
        let docData = try! FirestoreEncoder().encode(self)
        Firestore.firestore().collection("users").document(self.userID!).setData(docData){
            err in
            if let error = err{
                print("error writing document \(error)")
            }
            else{
                //print("document written successfully")
            }
        }
        
    }
    
    func save(){
        let docData = try! FirestoreEncoder().encode(self)
        Firestore.firestore().collection("users").document(self.userID!).setData(docData){
            err in
            if let error = err{
                print("error writing document \(error)")
            }
            else{
                //print("document written successfully")
            }
        }
    }
    
    
    func load(completion: @escaping ()->(Void)){
        Firestore.firestore().collection("users").document(User.sharedInstance.userID!).getDocument { document, error in
            if let error = error{
                print(error)
            }
            if let document = document {
                let model = try! FirestoreDecoder().decode(User.self, from: document.data()!)
                self.userID = model.userID
                self.email = model.email
                self.username = model.username
                self.watchList = model.watchList
                self.plannedTrades = model.plannedTrades
                self.selectedStock = model.selectedStock
                self.selectedIndex = model.selectedIndex
                //print(self.username)
                //print(self.email)
                print("Sucessful data recovery when loading")
                User.sharedInstance = self
                //print(User.sharedInstance.getWatchList()!.getStockList().count)
                
                completion()
                
            }
        }
        
    }
    
    func deleteStock(index: Int){
        var watchlist = self.getWatchList()
        var stockList = watchlist!.getStockList()
        stockList.remove(at: selectedIndex!)
        watchlist!.setStockList(setList: stockList)
        self.setWatchList(watchlist!)
        self.save()
    }
    
}
import Foundation
