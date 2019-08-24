//
//  ViewController.swift
//  Weathers-App
//
//  Created by Arash on 8/19/19.
//  Copyright © 2019 Arash. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController , CLLocationManagerDelegate , ChangeCityDelegate {
   
    //MARK:Define API
    
    fileprivate let ApiKey = "9f2ad630fb65dd2f44a2752a4933b2c9"
    let WeayherUrl =  "https://api.darksky.net/forecast/9f2ad630fb65dd2f44a2752a4933b2c9/37.8267,-122.4233"
    
    //TODO:Define Instance
    
    let locationManager = CLLocationManager()
    var currentWeather = CurrentWeather()
    //MARK:Outlet
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempreatureLabel: UILabel!
    @IBOutlet weak var humidityPercent: UILabel!
    @IBOutlet weak var rainPercent: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    //@IBOutlet weak var segmentTempValue: UISegmentedControl!
    
    //MARK:Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Setup Location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    @IBAction func changeCity(_ sender: Any) {
    
        performSegue(withIdentifier: "changeCity", sender: self)
        
    }
    
    @IBAction func reloadButton(_ sender: Any) {
    
    }
    
    
    //MARK:Networking
    
    func getWeatherData(url : String , parameters : [String : String]) {
        
        Alamofire.request(url , method: .get , parameters: parameters).responseJSON {
            respone in
            if respone.result.isSuccess {
                
                let weatherJson : JSON = JSON(respone.result.value!)
                print(weatherJson)
                self.updateWeatherData(json: weatherJson)
            
            }
            else {
                
                print("Error \(String(describing: respone.result.error))")
                self.cityName.text = "Connection Issues"
            }
        }
        
    }
    
    
    //MARK:Update Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat" : latitude , "lon" : longitude , "appid" : ApiKey]
            getWeatherData(url: WeayherUrl, parameters: params)
            
        
        }
    
    }
    
    //MARK:Update Location Failed
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error")
        cityName.text = "Location Unavailable"
    
    }
    
     //MARK:Update Weather Data
    
    func updateWeatherData (json : JSON) {
        
        if let tempResult = json["currently"]["temperature"].double{
            currentWeather.tempreature = Double(tempResult - 32) / 1.8
        currentWeather.city = json["timezone"].stringValue
        currentWeather.summary = json["minutely"]["summary"].stringValue
        currentWeather.humidity = json["currently"]["humidity"].double!
        currentWeather.precipitaionProbability = json["currently"]["precipProbability"].int!
        //currentWeather.icon = json["icon"].stringValue
        //currentWeather.iconName = currentWeather.updateWeatherIcon(rawValue: String)
        }
        else {
            cityName.text = "Weather Unavialble"
        }
            updateDataUI()
        
    }
    
    //MARK:Implement Delegate Method
    
    func setCity(city: String) {
        
        cityName.text = city
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCity" {
                let desVC = segue.destination as! ChangeCityViewController
                desVC.delegate = self
                
        }
    }
    
    func updateDataUI () {
        
        cityName.text = currentWeather.city
        tempreatureLabel.text = String(currentWeather.tempreature)
        humidityPercent.text = String(currentWeather.humidity)
        summaryLabel.text = currentWeather.summary
        
        
    }
}

