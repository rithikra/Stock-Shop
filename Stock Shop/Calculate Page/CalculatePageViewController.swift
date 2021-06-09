//
//  CalculatePageViewController.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/4/21.
//

import Foundation
import UIKit

class CalculatePageViewController: UIViewController{
    var currentUser = User.sharedInstance
    var allOptions = [Option]()
    var pageSymbol = ""
    var globalCurrentStockPrice = 0.0
    var globalMin = 0.0
    var globalMax = 0.0
    var globalbestOption = Option(strikePrice: 0.0, expirationDate: "", Stock: "", Delta: 0.0, Gamma: 0.0, type: "", price: 0.0)
    var globalBestROI = 0.0
    
    @IBOutlet weak var symbolTextField: UITextField!
    
    @IBOutlet weak var predictionDateTextField: UITextField!
    
    @IBOutlet weak var submitErrorButtonLabel: UILabel!
    
    override func viewDidLoad() {
        submitErrorButtonLabel.text = ""
        ResultView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        submitErrorButtonLabel.text = ""
        ResultView.isHidden = true
    }
    //submitting and checking if stock exists and gettinv alue
    @IBAction func submitButtonTapped(_ sender: Any) {
        //check for correct inputs
        //check if stock exists
        
        submitErrorButtonLabel.text = "Loading..."
        //var personalcode: Int = 3
        let currentText = symbolTextField.text
        let date = self.predictionDateTextField.text!
        let typeInt = PriceDirectionSegControl.selectedSegmentIndex
        print("TYPE INT \(typeInt)")
        let type = (typeInt == 0 ? "CALL" : "PUT")
        print(type)
        if (currentText == "" || currentText == nil){
            submitErrorButtonLabel.text = "Please insert text into search bar"
            submitErrorButtonLabel.textColor = UIColor.red
        }
        else if (date.isEmpty || date.count != 10){
            submitErrorButtonLabel.text = "Please fix the date formatting"
            submitErrorButtonLabel.textColor = UIColor.red
        }
        else{
            pageSymbol = currentText!
            let requester = TiingoRequest()
            requester.checkifExists(symbol: currentText!, complete: {
                code in
                print("CODE RETURNED \(code)")
                //personalcode = code
                if (code == 2){
                    let optionsFinder = OptionsData()
                    optionsFinder.optionsList(symbol: self.pageSymbol, date: date, type: type, completion: { [self]
                        optionList in
                        self.allOptions = optionList
                        requester.getStockPriceInfo(self.pageSymbol, complete: {
                            rv in
                            var currentStockPrice = rv[1]
                            globalCurrentStockPrice = currentStockPrice
                            var newOption = Option(strikePrice: 0, expirationDate: "n/a", Stock: pageSymbol, Delta: 0, Gamma: 0, type: "STOCK", price: currentStockPrice)
                            self.allOptions.append(newOption)
                            self.labelChange(5)
                        })
                        
                    })
                    
                    
                }
                else{
                    self.labelChange(code)
                }
                
                
               
            })
        }
        //get all option data
    }
    //resigning keyboard
    @IBAction func backgroundTapped(_ sender: Any) {
        symbolTextField.resignFirstResponder()
        predictionDateTextField.resignFirstResponder()
        minValueTextField.resignFirstResponder()
        maxValueTextField.resignFirstResponder()
        
        self.becomeFirstResponder()
        
    }
    //changing the label --> showing what is hapening on calculate page
    func labelChange(_ code: Int){
        DispatchQueue.main.async { [self] in
            if (code == 1){
                self.submitErrorButtonLabel.text = "\(self.pageSymbol) is not a valid symbol!"
                self.submitErrorButtonLabel.textColor = UIColor.red
            }
            else if (code == 2){
                self.submitErrorButtonLabel.text = "\(self.pageSymbol) has been found but no option data present!"
                self.submitErrorButtonLabel.textColor = UIColor.black
            }
            else if (code == 4){
                self.submitErrorButtonLabel.text = "\(self.pageSymbol) had an error when parsing option data!"
                self.submitErrorButtonLabel.textColor = UIColor.red
            }
            else if (code == 5){
                let tempPriceString = String(format: "%.2f", self.globalCurrentStockPrice)
                self.submitErrorButtonLabel.text = "\(self.pageSymbol) ($\(tempPriceString)) option data has loaded"
                self.submitErrorButtonLabel.textColor = UIColor.black
            }
            for option in self.allOptions{
                print("NEW OPTION")
                print(option.getExpirationDate())
                print(option.getStrikePrice())
                print(option.getPrice())
            }
        }
    }
    
    
    @IBOutlet weak var minValueTextField: UITextField!
    
    @IBOutlet weak var maxValueTextField: UITextField!
    
    @IBOutlet weak var PriceDirectionSegControl: UISegmentedControl!
    
    @IBOutlet weak var confidenceIntervalSlider: UISlider!
    
    @IBOutlet weak var ReturnOutput: UILabel!
    //calculate and show the best option value
    @IBAction func calculateButtonTapped(_ sender: Any) {
        //text control / error
        
        //calculations
        var currentStockPrice = 0.0
        for option in allOptions{
            if option.getType() == "STOCK"{
                currentStockPrice = option.getPrice()
            }
        }
        
        let minValue = Double(minValueTextField.text!)
        let maxValue = Double(maxValueTextField.text!)
        globalMin = minValue!
        globalMax = maxValue!
        //let confidenceInterval = Double(confidenceIntervalSlider.value)
        //print("CONFIDENCE INTERVAL:  \(confidenceInterval)")
        let rvCalculate = calculate(minValue: minValue!, maxValue: maxValue!, stockPrice: currentStockPrice, optionList: allOptions)
        let (bestOption, bestROI) = rvCalculate
        //var bestOption = rvCalculate
        let Date = bestOption.getExpirationDate()
        var Cost = 0.0
        _ = bestOption.getStrikePrice()
        _ = bestOption.getType()
        if bestOption.getType() != "STOCK"{
            Cost = bestOption.getPrice() * 100
        }
        else{
            Cost = bestOption.getPrice()
        }
        let StrikePrice = bestOption.getStrikePrice()
        let rvString = """
        The best option strategy will have an expiration
        on \(Date). The strike price is $\(StrikePrice)
        and the estimated ROI is \(bestROI) with a cost of \(Cost)
"""
        globalBestROI = bestROI
        globalbestOption = bestOption
        resultsOutput(option: bestOption, ROI: bestROI)
        //ReturnOutput.text = rvString
        print(rvString)
    }
    //the actual calculate function --> calculates the optimal value and returns the optoin value
    func calculate(minValue: Double, maxValue: Double, stockPrice: Double, optionList: [Option])->(Option, Double){
        _ = [(Option,Double)]()
        var max_ROI = 0.0
        var maxOption: Option = optionList[1]
        for option in optionList{
            if option.getType() == "CALL"{
                //var profit: Double = 0.0
                var initialcost = option.getPrice()
                initialcost = initialcost * 100
                let strikePrice = option.getStrikePrice()
                if (strikePrice * 1.2) > maxValue{
                    continue
                }
                if (initialcost <= 1){
                    continue
                }
                else{
                    var profit1: Double =  minValue - strikePrice
                    if profit1 < 0{
                        profit1 = 0.0
                    }
                    profit1 = profit1 * 0.8
                    var profit2: Double =  maxValue - strikePrice
                    if profit2 < 0{
                        profit2 = 0.0
                    }
                    profit2 = profit2 * 0.8
                    profit1 = profit1 * 100
                    profit2 = profit2 * 100
                    let averageprofit = (profit1 + profit2)/2
                    let ROI = averageprofit / initialcost
                    if ROI > max_ROI{
                        max_ROI = ROI
                        maxOption = option
                    }
                    
                }
            }
            if option.getType() == "PUT"{
                //var profit: Double = 0.0
                var initialcost = option.getPrice()
                initialcost = initialcost * 100
                let strikePrice = option.getStrikePrice()
                if strikePrice > maxValue{
                    continue
                }
                if (initialcost <= 1){
                    continue
                }
                else{
                    var profit1: Double =  strikePrice - minValue
                    if profit1 < 0{
                        profit1 = 0.0
                    }
                    profit1 = profit1 * 0.8
                    var profit2: Double =  strikePrice - maxValue
                    if profit2 < 0{
                        profit2 = 0.0
                    }
                    profit2 = profit2 * 0.8
                    profit1 = profit1 * 100
                    profit2 = profit2 * 100
                    let averageprofit = (profit1 + profit2)/2
                    let ROI = averageprofit / initialcost
                    if ROI > max_ROI{
                        max_ROI = ROI
                        maxOption = option
                    }
                    
                }
            }
            else{
                var ROImin =  minValue / option.getPrice()
                var ROImax = maxValue / option.getPrice()
                if ROImin < 1{
                    ROImin = 1 - ROImin
                }
                if ROImax < 1{
                    ROImax = 1 - ROImax
                }
                let averageROI = (ROImin + ROImax)/2
                
                if averageROI > max_ROI{
                    max_ROI = averageROI
                    maxOption = option
                }
            }
            
        }
        return (maxOption, max_ROI)
        
        
    }
    //printing the actual results output
    func resultsOutput(option: Option, ROI: Double){
        resultsStockNameLabel.text = pageSymbol.uppercased()
        
        let roi = String(format: "%.2f", ROI)
        resultsROILabel.text = "ROI: \(roi)"
        
        
        if option.getType() != "STOCK"{
            let expiration = option.getExpirationDate()
            resultsExpirationDateLabel.text = "Expiration: \(expiration)"
            let type = option.getType()
            let strikeprice = String(format: "%.2f", option.getStrikePrice())
            resultsStockPriceTypeLabel.text = "$\(strikeprice) \(type)"
            let cost = String(format: "%.2f", option.getPrice() * 100)
            resultsOptionCost.text = "Cost: $ \(cost)"
        }
        else{
            resultsExpirationDateLabel.text = "Expiration: N/A"
            resultsStockPriceTypeLabel.text = "STOCK"
            let cost = String(format: "%.2f", option.getPrice())
            resultsOptionCost.text = "Cost: $\(cost)"
        }
        ResultView.isHidden = false
        
        
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let symbol = pageSymbol
        let type = globalbestOption.getType()
        let date = globalbestOption.getExpirationDate()
        let targetDate = globalbestOption.getExpirationDate()
        let optionCost = globalbestOption.getPrice()
        let optionStrikePrice = globalbestOption.getStrikePrice()
        let initialStockPrice = globalCurrentStockPrice
        let newTrade: Trade = Trade(symbol, type, date, targetDate, optionCost, optionStrikePrice,
        globalMin, globalMax, 100, initialStockPrice)
        var currentTrades = currentUser.getTrades()
        currentTrades?.append(newTrade)
        currentUser.setTrades(trades: currentTrades!)
        currentUser.save()
        /*if let tabBarController = self.UITabBarController {
                tabBarController.selectedIndex = 3
            }
        return true*/
    }
    
    @IBOutlet weak var resultsOptionCost: UILabel!
    @IBOutlet weak var ResultView: UIView!
    
    @IBOutlet weak var resultsExpirationDateLabel: UILabel!
    @IBOutlet weak var resultsROILabel: UILabel!
    @IBOutlet weak var resultsStockPriceTypeLabel: UILabel!
    @IBOutlet weak var resultsStockNameLabel: UILabel!
}
