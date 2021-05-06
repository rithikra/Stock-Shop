//
//  OptionsData.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/4/21.
//

import Foundation
class OptionsData{
    init(){
        
    }
    func optionsList(symbol: String, date: String, type: String, completion: @escaping ([Option])->()){
        //let symbol = "AAPL"
        let api_key = "6091d598bc2aa9.36422005"
        let tempURL: String = "https://eodhistoricaldata.com/api/options/\(symbol).US?api_token=\(api_key)&from=\(date)"
        var optionsListRV = [Option]()
        if let accessURL = URL(string: tempURL){
            var urlRequest = URLRequest(url: accessURL)
            urlRequest.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (
                data, response, error) in
                //print("TRUONGT O LOAD")
                if let error = error{
                    print("ERROR EXISTS")
                    print(error)
                }
                if let data = data {
                    do{
                        let JSON = try JSONSerialization.jsonObject(with: data, options: [])
                        //print(JSON)
                        if let JSON = JSON as? [String: AnyObject] {
                            if let receivedData = JSON["data"] as? Array<[String: AnyObject]>{
                                _ = receivedData.count
                                if let options = receivedData[0] as? [String: AnyObject]{
                                    if let actualOptions = options["options"] as? [String: AnyObject]{
                                        if let calls = actualOptions[type] as? Array<[String:AnyObject]>{
                                            for index in 0..<calls.count{
                                                let expirationDate: String = calls[index]["expirationDate"] as! String
                                                let type: String = calls[index]["type"] as! String
                                                let stringStrikePrice = calls[index]["strike"] as! NSNumber
                                                //print(stringStrikePrice)
                                                let strikePrice: Double = Double(stringStrikePrice.floatValue)
                                                //print(strikePrice)
                                                let stringdelta = calls[index]["delta"] as! NSNumber
                                                let delta: Double = Double(stringdelta.floatValue)
                                                let stringgamma = calls[index]["gamma"] as! NSNumber
                                                let gamma: Double = Double(stringgamma.floatValue)
                                                let stringprice = calls[index]["lastPrice"] as! NSNumber
                                                let price: Double = Double(stringprice.floatValue)
                                                //print(price)
                                                let newOption = Option(strikePrice: strikePrice, expirationDate: expirationDate, Stock: symbol, Delta: delta, Gamma: gamma, type: type, price: price)
                                                optionsListRV.append(newOption)
                                            }
                                            //print(calls[0])
                                            //print("Working")
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    catch let error {
                       print(error)
                       //print("ERROR")
                       exit(1)
                    }
                }
                completion(optionsListRV)
                
            }
            dataTask.resume()
            
        }
        
    }
}
