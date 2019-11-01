//
//  ViewController.swift
//  ctavenne-Lab7
//
//  Created by Cody Tavenner on 4/17/19.
//  Copyright © 2019 Cody Tavenner. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var textArea: UITextView!
    var n: Double = 0
    var s:Double = 0
    var e:Double = 0
    var w:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func submit(_ sender: UIButton) {
        if (city.text?.isEmpty)!{
            // show the alert controller to select an image for the row
            let alertController = UIAlertController(title: "Textfield can not be empty", message: "", preferredStyle: .alert)
            
            
            let cancelAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            let geoCoder = CLGeocoder();
            let addressString = city.text!
            
            
            CLGeocoder().geocodeAddressString(addressString, completionHandler: {(placemarks, error) in
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    let location = placemark.location
                    let lat = location!.coordinate.latitude
                    let lon = location!.coordinate.longitude
                    print(lat)
                    print(lon)
                    self.n = lat + 10
                    self.s = lat - 10
                    self.e = abs(lon) - 10
                    self.w = abs(lon) + 10
                    print(self.n)
                    print(self.e)
                }
            })
            

        }
       
        
    }
    
    @IBAction func earthquake(_ sender: UIButton) {
        if (city.text?.isEmpty)!{
            // show the alert controller to select an image for the row
            let alertController = UIAlertController(title: "Textfield can not be empty", message: "", preferredStyle: .alert)
            
            
            let cancelAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            var date = ""
            var mag = ""
            var results = ""
            var nt = String(format: "%0.2f", self.n)
            var st = String(format: "%0.2f", self.s)
            var et = String(format: "%0.2f", self.e)
            var wt = String(format: "%0.2f", self.w)
            print(nt)
            
            let urlAsString = "http://api.geonames.org/earthquakesJSON?formatted=true&north="+nt+"&south="+st+"&east="+et+"&west="+wt+"&username=ctavenne"+"&style=full"
            
            
            let url = URL(string: urlAsString)!
            let urlSession = URLSession.shared
            
            
            let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                var err: NSError?
                
                
                var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                if (err != nil) {
                    print("JSON Error \(err!.localizedDescription)")
                }
                
                print(jsonResult)
                
                
                let setOne = jsonResult["earthquakes"]! as! NSArray
                print(setOne)
                
                
                for i in 0...9{
                    let y = setOne[i] as? [String: AnyObject]
                    date = (y!["datetime"] as? NSString)! as String
                    mag = String((y!["magnitude"] as? NSNumber)!.doubleValue)
                    
                    results += "Date: " + date + "\n" + "Magnitude: " + mag + "\n"
                    
                }
                
                
                
                DispatchQueue.main.async
                    {
                        self.textArea.text = results
                }
                
            })
            
            jsonQuery.resume()
        }
        }
       
    
}

