//
//  TableViewController.swift
//  WeatherMap
//
//  Created by Daniele Rapali on 03/06/17.
//  Copyright © 2017 Daniele Rapali. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var cityDictionaries: [[String : NSDictionary]] = []//array of all dictionaries.
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        JSONModel().cityList(){ (result,errorString) -> Void in
            
            for elem in result as! NSArray{
                
                //let dict:NSDictionary = elem as! NSDictionary
                self.cityDictionaries.append(["name" : elem as! NSDictionary])
                
            }
            

            
        }
        

        
        print("city : ",self.cityDictionaries.count)
 
        UserDefaults.standard.set(self.cityDictionaries, forKey: "cityList")

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cityDictionaries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        let object = self.cityDictionaries[indexPath.row] as NSDictionary
        let dictCity = object["name"] as! NSDictionary
        cell.textLabel?.text =  dictCity["name"] as? String
       cell.detailTextLabel?.text = flag(country: (dictCity["country"] as? String)!)
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.performSegue(withIdentifier: "details", sender: self.cityDictionaries[indexPath.row] )

    }

  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get a reference to the second view controller
        let details = segue.destination as! ViewController
        let object = sender as! NSDictionary
        let dictCity = object["name"] as! NSDictionary
        // set a variable in the second view controller with the data to pass
        details.selectedCity = dictCity
    }
    
    
}

func flag(country:String) -> String {
    let base : UInt32 = 127397
    var s = ""
    for v in country.unicodeScalars {
        s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    print(s)
    return String(s)
}
