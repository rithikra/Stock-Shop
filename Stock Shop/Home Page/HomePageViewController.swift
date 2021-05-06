//
//  HomePageViewController.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/3/21.
//

import Foundation
import UIKit
import FirebaseAuth

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var HomePageTableView: HomePageStockView!
    
    var currentUser: User = User.sharedInstance
    override func viewDidLoad(){
        HomePageTableView.dataSource = self
        HomePageTableView.delegate = self
    }
    @IBOutlet weak var MainLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        let stockList = currentUser.getWatchList()!.getStockList()
        for index in 0..<stockList.count{
            let currentStock = stockList[index]
            currentStock.updateStockValues(handler: {
                currentStock in
                let tempWatchList = self.currentUser.getWatchList()
                var tempStockList = tempWatchList?.getStockList()
                tempStockList![index] = currentStock
                tempWatchList?.setStockList(setList: tempStockList!)
                self.currentUser.setWatchList(tempWatchList!)
                self.currentUser.save()
            })
        }
        _ = currentUser.getUsername()
        MainLabel.text = "Welcome!"
        User.sharedInstance.load {
            DispatchQueue.main.async {
                print("RELOADING DATA HERE")
                //print(User.sharedInstance.getWatchList()?.getStockList().count)
               // print(User.sharedInstance.getWatchList()?.getStockList()[1].getSymbol())
                self.HomePageTableView.reloadData()
            }
            
        }
        //User.sharedInstance.load()
        
       
        
        /*currentUser = User.sharedInstance
        print(currentUser.getUsername())
        var watchList = currentUser.getWatchList()
        print("WATCHLIST: \(String(describing: watchList))")
        let stockList = watchList!.getStockList()
        var updatedStockList = [Stock]()
        for stock in stockList{
            stock.updateStockValues()
            updatedStockList.append(stock)
        }
        watchList!.setStockList(setList: updatedStockList)*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let currentWatchlist = currentUser.getWatchList()
        //print("CURRENT WATCHLIST AMOUNT: \(currentWatchlist?.getStockList().count)")
        
        let currentStockList = currentWatchlist?.getStockList()
        if currentStockList!.isEmpty{
            print("STOCK LIST EMPTY")
            return 1
        }
        else {
            return currentStockList!.count
        }
    }
    func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       // Reuse or create a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell",
                             for: indexPath) as! HomePageStockViewCell
        let stockList = currentUser.getWatchList()!.getStockList()
        let currentStock = stockList[indexPath.row]
        
        //currentStock.updateStockValues(handler: <#(Stock) -> Void#>)
        
        //print(currentStock)
        
       // Fetch the data for the row.
       // Configure the cell’s contents with data from the fetched object.
        let lowercaseSymbol = currentStock.getSymbol()
        let upperCase = lowercaseSymbol.uppercased()
        cell.symbolLabel.text = upperCase
        let change:Double = currentStock.getChange() * 100
        
        let twoDecimalPoints: String = String (format: "%.2f", change)
        var rv: String = ""
        if change > 0{
            rv = "+" + (twoDecimalPoints) + "%"
        }
        else{
            rv = (twoDecimalPoints) + "%"
        }
        cell.changeLabel.text = rv
        cell.priceLabel.text = String(format: "%.2f", currentStock.getPrice())
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let watchList = currentUser.getWatchList()
        let stockList = watchList?.getStockList()
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        //print(indexPath.row)
        //if indexPath.row != nil{
            let chosenStock = stockList![indexPath.row]
            currentUser.selectedStock = chosenStock
            currentUser.selectedIndex = Int(indexPath.row)
            currentUser.save()
            //print(chosenStock.getPrice())
        //}
    }
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(identifier: "login")
        self.self.view.window!.rootViewController = loginVC
    }
    func selectRow(at indexPath: IndexPath?,
          animated: Bool,
          scrollPosition: UITableView.ScrollPosition){
        let watchList = currentUser.getWatchList()
        let stockList = watchList?.getStockList()
        if indexPath?.row != nil{
            let chosenStock = stockList![indexPath!.row]
            currentUser.selectedStock = chosenStock
            currentUser.selectedIndex = Int(indexPath!.row)
            currentUser.save()
            print(chosenStock.getPrice())
        }
    }
    @IBAction func reloadButtonTapped(_ sender: Any) {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        _ = currentUser.getWatchList()!.getStockList()
        /*for index in 0..<stockList.count{
            let currentStock = stockList[index]
            currentStock.updateStockValues(handler: {
                currentStock in
                var tempWatchList = self.currentUser.getWatchList()
                var tempStockList = tempWatchList?.getStockList()
                tempStockList![index] = currentStock
                tempWatchList?.setStockList(setList: tempStockList!)
                self.currentUser.setWatchList(tempWatchList!)
                self.currentUser.save()
                //self.HomePageTableView.reloadData()
            })
        }*/
        User.sharedInstance.load {
            DispatchQueue.main.async {
                print("RELOADING DATA HERE")
                //print(User.sharedInstance.getWatchList()?.getStockList().count)
                //print(User.sharedInstance.getWatchList()?.getStockList()[0].getSymbol())
                self.HomePageTableView.reloadData()
            }
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        //let indexPath = self.indexPathsForSelectedRow
        //if let indexPath = indexPath?.first{
            //currentUser.selectedTrade = currentUser.getTrades()![indexPath.row]
        //}
    }
}
