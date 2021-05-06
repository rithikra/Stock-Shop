//
//  TradeCollectionViewController.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/4/21.
//

import Foundation
import UIKit


class TradeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var currentUser: User = User.sharedInstance
    override func viewDidLoad() {
        print("TRADE COLLECTION VIEW LOADING")
        collectionView.delegate = self
        collectionView.dataSource = self
        User.sharedInstance.load {
            self.collectionView.reloadData()
        }
    }
    @IBAction func refreshTapped(_ sender: Any) {
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
                self.collectionView.reloadData()
            }
        }
    }
    func viewwillAppear(){
        collectionView.delegate = self
        collectionView.dataSource = self
        User.sharedInstance.load {
            DispatchQueue.main.async {
                print("RELOADING DATA HERE IN TRADE COLLECTION VIEW")
                //print(User.sharedInstance.getWatchList()?.getStockList().count)
               // print(User.sharedInstance.getWatchList()?.getStockList()[1].getSymbol())
                self.collectionView.reloadData()
            }
            
        }
        
        //let currentWatchlist = currentUser.getWatchList()
        //print("CURRENT WATCHLIST: \(currentWatchlist)")
        currentUser = User.sharedInstance
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentUser.getTrades() != nil{
            //print("GETTING CURRENT TRADES count")
            //print(trades.count)
            return currentUser.getTrades()!.count
            
        }
        else{
            return 4
        }
            
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tradeCell",
                             for: indexPath) as! TradeViewCell
        let tradeList = currentUser.getTrades()
        let currentTrade = tradeList![indexPath.row]
        cell.symbolLabel.text = currentTrade.getSymbol().uppercased()
        cell.typeLabel.text = currentTrade.getType()
        let targetDate = currentTrade.getExpiration()
        cell.targetDateLabel.text = "Target Date: \(targetDate)"
        let price = currentTrade.getOptionStrikePrice()
        cell.strikePriceLabel.text = "Strike Price : \(price)"
        let initialPrice = currentTrade.getInitialPrice()
        let minPrice = currentTrade.getMinPrice()
        let diff = minPrice - initialPrice
        if diff < 0{
            cell.progressViewBar.setProgress(1.00, animated: false)
        }
        else{
            cell.progressViewBar.setProgress(0.05, animated: false)
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var awidth = self.view.bounds.width
        var aheight = self.view.bounds.height
        aheight = aheight/4
        //aheight = aheight
        awidth = awidth/2
        awidth = awidth - 6
        return CGSize(width: awidth, height: aheight)
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 shouldSelectItemAt indexPath: IndexPath) -> Bool{
        return true
    }
    override func collectionView(_ collectionView: UICollectionView,
                 didSelectItemAt indexPath: IndexPath)
    {
        print("SELECTI G ITEM AND WORKING")
        self.performSegue(withIdentifier: "mainSegue", sender:self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = collectionView.indexPathsForSelectedItems
        if let indexPath = indexPath?.first{
            currentUser.selectedTrade = currentUser.getTrades()![indexPath.row]
        }
    }
    
    
}
