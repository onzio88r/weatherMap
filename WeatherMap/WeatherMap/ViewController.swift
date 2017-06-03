//
//  ViewController.swift
//  WeatherMap
//
//  Created by Daniele Rapali on 03/06/17.
//  Copyright © 2017 Daniele Rapali. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var selectHours: UIPickerView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weatherMain: UILabel!
    
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var temperatureMin: UILabel!
    
    @IBOutlet weak var temperatureMax: UILabel!
    
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDegree: UILabel!
    
    var selectedCity:NSDictionary!
    
    var dataSelected:NSArray = []
    
    var apiKEY = "e28f911e2aeed975dd0158a9a5c6af32"
    
    var cityID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        selectHours.delegate = self
        selectHours.dataSource = self
        
        showData(hour: "")
        
    }
    
    
    func showData(hour:String){
        activity.startAnimating()

        city.text = selectedCity.object(forKey: "name") as? String
        cityID = selectedCity.object(forKey: "id") as? String
        
        
        JSONModel().getJSON(url: "http://samples.openweathermap.org/data/2.5/forecast?id=\(cityID)&appid=\(apiKEY)"){ (result,errorString) -> Void in
            let list = result?.object(forKey: "list")
            self.dataSelected = list as! NSArray
            
            self.selectHours.reloadAllComponents()
            
            for elem in list as! NSArray{
                
                let dict = elem as! NSDictionary
                
                self.time.text = hour
                
                if(dict.object(forKey: "dt_txt") as? String == hour) {
                
                let weatherarray = dict.object(forKey: "weather")
                let windDict = dict.object(forKey: "wind") as! NSDictionary
                
                
                
                let main = dict.object(forKey: "main") as! NSDictionary
                
                self.temperatureMin.text = String((main.object(forKey: "temp_min") as? Double)!)
                self.temperatureMax.text = String((main.object(forKey: "temp_max") as? Double)!)
                self.temperature.text = String((main.object(forKey: "temp") as? Double)!)
                
                
                for object in weatherarray as! NSArray{
                    print(object)
                    let weather = object as! NSDictionary
                    self.weatherMain.text = weather.object(forKey: "main") as? String
                    self.weatherDescription.text = weather.object(forKey: "description") as? String
                    
                }
                self.windSpeed.text = String((windDict.object(forKey: "speed") as? Double)!)
                self.windDegree.text = String((windDict.object(forKey: "deg") as? Double)!).appending("°")
                
                
            }
            
            
        }
            
            self.activity.stopAnimating()
        
        }

        
    }
    
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSelected.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var text = "Select Hour"
        if( self.dataSelected.count != 0){
            
            let dict = self.dataSelected[row] as! NSDictionary
            text = (dict.object(forKey: "dt_txt") as? String)!
            
        }
        
        
        return text
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let dict = self.dataSelected[row] as! NSDictionary
        
       print(dict.object(forKey: "dt_txt") as? String)
        
        showData(hour: (dict.object(forKey: "dt_txt") as? String)!)
    }
    
   


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

