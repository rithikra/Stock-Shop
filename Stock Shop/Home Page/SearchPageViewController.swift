//
//  SearchPageViewController.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/4/21.
//

import Foundation
import UIKit


class SearchPageViewController: UIViewController{
    var pageSymbol: String = ""
    var pageCode: Int = 3
    override func viewDidLoad() {
        
    }

    @IBAction func tapRecognized(_ sender: Any) {
        self.becomeFirstResponder()
        SearchText.resignFirstResponder()
    }
    @IBOutlet weak var SearchText: UITextField!
    
    @IBOutlet weak var errorMessageField: UILabel!
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        //dismiss view
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any){
        let currentText = SearchText.text
        if (currentText == "" || currentText == nil){
            errorMessageField.text = "Please insert text into search bar"
            errorMessageField.textColor = UIColor.red
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
        else{
            pageSymbol = currentText!
            let requester = TiingoRequest()
            requester.checkifExists(symbol: currentText!, complete: {
                code in
                print("CODE RETURNED \(code)")
                self.labelChange(code)
                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
               
            })
        }
    }
    
    func labelChange(_ code: Int){
        DispatchQueue.main.async {
            if (code == 1){
                self.errorMessageField.text = "\(self.pageSymbol) is not a valid symbol!"
                self.errorMessageField.textColor = UIColor.red
                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
            }
            else if (code == 2){
                self.errorMessageField.text = "\(self.pageSymbol) has been found!"
                self.errorMessageField.textColor = UIColor.black
                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
            }
        }
       
            
        
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        //make sure that stock is verified before if i have time
        _ = Stock(symbol: pageSymbol, completion: {
            newStock in
            print("NEW STOCK CHANGE AFATER RETURNING")
            print(newStock.getChange())
            self.updateCurrentStockList(newStock)
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
            
        })
        
        
    }
    
    func updateCurrentStockList(_ currentStock: Stock){
        DispatchQueue.main.async {
            let currentUser = User.sharedInstance
            let currentWatchlist = currentUser.getWatchList()
            currentWatchlist!.addStockList(currentStock)
            currentUser.setWatchList(currentWatchlist!)
            self.dismiss(animated: false, completion: nil)
            currentUser.save()
        }
    }
}
