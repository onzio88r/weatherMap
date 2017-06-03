//
//  JSONModel.swift
//  WeatherMap
//
//  Created by Daniele Rapali on 03/06/17.
//  Copyright © 2017 Daniele Rapali. All rights reserved.
//

import UIKit

class JSONModel: NSObject {
    
    
    func getJSON(url:String, withCompletionHandler:@escaping (NSDictionary?,String?) -> Void) {
        
        let url = URL(string: url)
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard error == nil else { //control if are present errors
                withCompletionHandler(nil,String(describing: error))
                return
            }
            
            guard let data = data else {
                withCompletionHandler(nil,String(describing: error))
                return
            }
            
            do {
                let httpStatus = response as? HTTPURLResponse
                if httpStatus?.statusCode == 200 { //controll if the response is 200 --> OK
                    
                    //print("status is \(httpStatus?.statusCode)")
                    //print("Data received is = \(String(data: data, encoding: .utf8)!)")
                    let parsedData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    withCompletionHandler(parsedData as NSDictionary?,nil)
                }else{
                    print("statusCode should be 200, but is \(String(describing: httpStatus?.statusCode))")
                    print("response = \(response!)")
                    print("Error Data received is = \(String(data: data, encoding: .utf8)!)")
                    withCompletionHandler(nil,String(data: data, encoding: .utf8)!)
                    return
                    
                }
            }
        }).resume()

    }
    
    
    func cityList(withCompletionHandler:@escaping (Any?,String?) -> Void) {
        
        do {
            if let file = Bundle.main.url(forResource: "city.list", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    
                    withCompletionHandler(object as NSDictionary?,nil)
                } else if let object = json as? [Any] {
                    // json is an array
                    withCompletionHandler(object,nil)

                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
       
    }
}
