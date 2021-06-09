//
//  IndividualTradeViewController.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/5/21.
//

import Foundation
import UIKit
import EventKit
import EventKitUI
import MessageUI

//the viewer for showing individual trades
class IndividualTradeViewController: UIViewController, MFMessageComposeViewControllerDelegate{
    
    //create new message
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    var currentUser = User.sharedInstance
    //view did load function
    override func viewDidLoad() {
        print("NEW VIEW LOADING")
        currentUser.load(completion: {
            
        })
        currentUser = User.sharedInstance
    }
    //vie will appeara function
    override func viewWillAppear(_ animated: Bool) {
        currentUser.load(completion: {
            let selectedStock = self.currentUser.selectedStock
            self.stockSymbolLabel.text = self.currentUser.selectedStock!.getSymbol().uppercased()
            let price = selectedStock!.getPrice()
            let priceString = String(format: "%.2f", price)
            let change = selectedStock!.getChange() * 100
            let changeString = String(format: "%.2f", change)
            self.currentPriceLabel.text = "Price: $\(priceString)"
            self.changeLabel.text = "Percent Change: \(changeString)%"
        })
        currentUser = User.sharedInstance
        
    }
    @IBOutlet weak var stockSymbolLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    //deleting the stock
    @IBAction func deleteButtonTapped(_ sender: Any) {
        currentUser.deleteStock(index: currentUser.selectedIndex!)
        self.dismiss(animated: false, completion: nil)
    }
    //crreating a calendar aalert -- eventKIT
    @IBAction func createAlertButtonTapped(_ sender: Any) {
        let store = EKEventStore.init()
        store.requestAccess(to: .event) { (granted, error) in
          if let error = error {
            print("request access error: \(error)")
          } else if granted {
            print("access granted")
          } else {
            print("access denied")
          }
        }
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        let endDate = Date.init(timeInterval: 3600, since: Date())
        event.calendar = eventStore.defaultCalendarForNewEvents
        let stockName = self.currentUser.selectedStock!.getSymbol().uppercased()
        event.title = "\(stockName) - watch stock "
        event.startDate = Date()
        event.endDate = endDate

        do {
          try eventStore.save(event, span: .thisEvent)
        } catch {
          print("saving event error: \(error)")
        }
        
    }
    //just going back to the older screen
    @IBAction func backButtonTapped(_ sender: Any) {
        //self.dismiss()
        self.dismiss(animated: false, completion: nil)
    }
    //messageUI --> showing messageKIT
    @IBAction func shareButtonTapped(_ sender: Any) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
         
        // Configure the fields of the interface.
        composeVC.recipients = ["4088218125"]
        _ = currentUser.selectedStock
        //let name = currentStock!.getSymbol
        //let price = currentStock!.getPrice
        let rv = "I'm using Stock Shop and plan on buying stock today! Join the app to see my current trades!"
        composeVC.body = rv
         
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
}
