//
//  HomePageStockView.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/3/21.
//

import Foundation
import UIKit

class HomePageStockView: UITableView {
    class HomePageStockViewCell: UITableViewCell{
        @IBOutlet weak var symbolLabel: UILabel!
        @IBOutlet weak var priceLabel: UILabel!
        @IBOutlet weak var changeLabel: UILabel!
        
    }
    var currentUser: User = User.sharedInstance
    func viewDidLoad() {
        User.sharedInstance.load {
            self.reloadData()
        }
        currentUser = User.sharedInstance
        _ = currentUser.getWatchList()
    }
    
    func viewwillAppear(){
        
        reloadData()
        let currentWatchlist = currentUser.getWatchList()
        //print("CURRENT WATCHLIST: \(currentWatchlist)")
        currentUser = User.sharedInstance
        
        
    }
    
}
