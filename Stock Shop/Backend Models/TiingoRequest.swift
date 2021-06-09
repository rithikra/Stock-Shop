//
//  TiingoRequest.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/3/21.
//

import Foundation

class TiingoRequest{
    init(){
        
    }
    
    func getInitialStockInfo(_ symbol: String, complete: @escaping (String) -> (Void)){
        var stockName = String()
        let tempURL: String = "https://api.tiingo.com/tiingo/daily/\(symbol)?token=41abedc5390bd43a21c1b743bdfdbb54f0443157"
        //returning open, close
        //DispatchQueue.main.sync {
        if let accessURL = URL(string: tempURL){
            var urlRequest = URLRequest(url: accessURL)
            urlRequest.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                //print("TRUONGT O LOAD")
                if let error = error{
                    print("ERROR EXISTS")
                    print(error)
                }
                //print("TESTING API CALL")
                if let data = data {
                    do{
                        //print("TESTING API CALL 2x")
                        let JSON = try JSONSerialization.jsonObject(with: data, options: [])
                        //print(JSON)
                        
                            if let JSON = JSON as? [String: AnyObject] {
                                if let name = JSON["name"] as? String{
                                    stockName = name
                                }
                            }
                        
                    }
                    catch let error {
                       print(error)
                       //print("ERROR")
                       exit(1)
                    }
                }
                complete(stockName)
            }
            dataTask.resume()
            //return stockName

        }
        
        else{
        
            //return "no Stock Name"
        }
        //}
    }
    func getStockPriceInfo(_ symbol: String, complete: @escaping ([Double]) -> (Void)){
        var returnArray = [Double]()
        let tempURL: String = "https://api.tiingo.com/tiingo/daily/\(symbol)/prices?token=41abedc5390bd43a21c1b743bdfdbb54f0443157"
        //returning open, close
        //DispatchQueue.main.sync {
        if let accessURL = URL(string: tempURL){
            //print("LET US IN")
            var urlRequest = URLRequest(url: accessURL)
            //urlRequest.setValue("Client-ID \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                //print("TRUONGT O LOAD")
                if let error = error{
                    print("ERROR EXISTS")
                    print(error)
                }
                if let data = data {
                    do{
                        //print("TESTING API CALL")
                        let JSON = try JSONSerialization.jsonObject(with: data, options: [])
                        //print(JSON)
                        //print(JSON[0]["close"])
                        
                            if let json = JSON as? Array<[String: AnyObject]> {
                                let currentJSON = json[0]
                                
                                if let open = currentJSON["open"] as? NSNumber, let close = currentJSON["close"] as? NSNumber {
                                    //print("if statement execution")
                                    returnArray.append(Double(open.floatValue))
                                    returnArray.append(Double(close.floatValue))
                                    //print(returnArray)
                                }
                            }
                        
                       
                    }
                    catch let error {
                       print(error)
                       //print("ERROR")
                       exit(1)
                    }
                }
                complete(returnArray)
            }
            dataTask.resume()
        }
        //}
        //return returnArray
    }
    
    func checkifExists(symbol: String, complete: @escaping (Int) -> (Void)){
        var stockName = String()
        let tempURL: String = "https://api.tiingo.com/tiingo/daily/\(symbol)?token=41abedc5390bd43a21c1b743bdfdbb54f0443157"
        //returning open, close
        //DispatchQueue.main.sync {
        if let accessURL = URL(string: tempURL){
            var urlRequest = URLRequest(url: accessURL)
            urlRequest.httpMethod = "GET"
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                //print("TRUONGT O LOAD")
                if let error = error{
                    print("ERROR EXISTS")
                    complete(1)
                    print(error)
                }
                //print("TESTING API CALL")
                if let data = data {
                    do{
                        //print("TESTING API CALL 2x")
                        let JSON = try JSONSerialization.jsonObject(with: data, options: [])
                        //print(JSON)
                        
                            if let JSON = JSON as? [String: AnyObject] {
                                if let name = JSON["name"] as? String{
                                    stockName = name
                                    complete(2)
                                }
                                else{
                                    complete(1)
                                }
                            }
                        
                    }
                    catch let error {
                       print(error)
                        complete(1)
                       exit(1)
                    }
                    
                }
                else{
                    complete(1)
                }
                
            }
            dataTask.resume()
        }
        
    }
}
