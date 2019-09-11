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

class ViewController: UIViewController , CLLocationManagerDelegate , ManageCityDelegate{


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
    @IBOutlet weak var segmentTempValue: UISegmentedControl!
    
    //MARK:Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Setup Location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    @IBAction func changeCity(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ManageCityItem", sender: self)
        
    }
    
    @IBAction func reloadButton(_ sender: UIButton) {
    
        updateDataUI()
        
    }
    
    @IBAction func segmentChanged(_ sender: Any?) {
        let tempF = currentWeather.tempreatureF
        let tempC = currentWeather.tempreatureC
        
        if segmentTempValue.selectedSegmentIndex == 0 {
            
            currentWeather.tempreature = tempC
        }
        if segmentTempValue.selectedSegmentIndex == 1 {
            
            currentWeather.tempreature = tempF
        }
        
            updateDataUI()
    }
    //MARK:Networking
    
    func getWeatherData(url : String , parameters : [String : String]) {
        
        Alamofire.request(url , method: .get , parameters: parameters).responseJSON {
            respone in
            if respone.result.isSuccess {
                print("Success result data")
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
 
        cityName.text = "Location Unavailable"
    
    }
    
     //MARK:Update Weather Data
    
    func updateWeatherData (json : JSON) {
        
        if let tempResult = json["currently"]["temperature"].double{
            currentWeather.tempreatureF = Double(tempResult)
            currentWeather.tempreatureC = Double(tempResult - 32) / 1.8
            currentWeather.tempreature = currentWeather.tempreatureC
        currentWeather.city = json["timezone"].stringValue
        currentWeather.summary = json["minutely"]["summary"].stringValue
        currentWeather.humidity = json["currently"]["humidity"].double!
        currentWeather.precipitaionProbability = json["currently"]["precipProbability"].int!
        currentWeather.iconName = json["currently"]["icon"].stringValue
    
        //currentWeather.iconName = currentWeather.updateWeatherIcon(rawValue: String)
        print(currentWeather.iconName)
        updateDataUI()
        }
        else {
            cityName.text = "Weather Unavialble"
        }
  
    }


    func updateDataUI () {
        
        cityName.text = currentWeather.city
        tempreatureLabel.text = String(currentWeather.tempreature)
        humidityPercent.text = String(currentWeather.humidity)
        summaryLabel.text = currentWeather.summary
        
        
    }
    
    //MARK : - Implement Method Delegate
  
func managedCity(city: String) {
    
    currentWeather.city = city
    updateDataUI()
    
}

}
