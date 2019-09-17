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
    
    fileprivate let ApiKey = "c26ca9f48d914e931409cc37b7736f03"
    let WeayherUrl =  "https://api.openweathermap.org/data/2.5/forecast"
    
    //TODO:Define Instance
    
    let locationManager = CLLocationManager()
    var currentWeather = CurrentWeather()
    var activityIndicator = UIActivityIndicatorView()
    //MARK:Outlet
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempreatureLabel: UILabel!
    @IBOutlet weak var iconName: UIImageView!
    @IBOutlet weak var humidityPercent: UILabel!
    @IBOutlet weak var maxValue: UILabel!
    @IBOutlet weak var minValue: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var segmentTempValue: UISegmentedControl!
    @IBOutlet weak var RefreshButton: UIButton!
    
    //MARK:Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
    toggleRefreshAnimation(true)
        updateDataUI()
        
    }
    func toggleRefreshAnimation (_ on : Bool) {
        
        RefreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        }else {
            activityIndicator.stopAnimating()
            
        }
    }
    @IBAction func segmentChanged(_ sender: Any?) {
       
        let tempF = currentWeather.tempreatureF
        let tempC = currentWeather.tempreatureC
        let minTempF = currentWeather.minTempF
        let minTempC = currentWeather.minTempC
        let maxTempF = currentWeather.maxTempF
        let maxTempC = currentWeather.maxTempC
        
        if segmentTempValue.selectedSegmentIndex == 0 {
            
            currentWeather.tempreature = Int(tempC)
            currentWeather.minTemp = minTempC
            currentWeather.maxTemp = maxTempC
        }
        if segmentTempValue.selectedSegmentIndex == 1 {
            
            currentWeather.tempreature = Int(tempF)
            currentWeather.minTemp = minTempF
            currentWeather.maxTemp = maxTempF   
        }
        
            updateDataUI()
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
                
                self.cityName.text = "Connection Issues"
            
            }
        }
        
    }
    
    
    //MARK:Update Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
           
            let params : [String : String] = ["q" : "karaj" , "appid" : ApiKey]
            getWeatherData(url: WeayherUrl, parameters: params) 
        
        }
    
    }
    
    //MARK:Update Location Failed
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
 
        cityName.text = "Location Unavailable"
    
    }
    
     //MARK:Update Weather Data
    
    func updateWeatherData (json : JSON) {
        
        if let tempResult = json["list"][0]["main"]["temp"].double{
            
            currentWeather.tempreatureF = Double((tempResult - 273.15) * 1.8)
            currentWeather.tempreatureC = Double(tempResult - 273.15)
            currentWeather.tempreature = Int(currentWeather.tempreatureC)
            currentWeather.minTempK = json["list"][0]["main"]["temp_min"].double!
            currentWeather.maxTempK = json["list"][0]["main"]["temp_max"].double!
            currentWeather.minTempF = Int((currentWeather.minTempK - 273.15) * 1.8)
            currentWeather.minTempC = Int(currentWeather.minTempK - 273.15)
            currentWeather.maxTempF = Int((currentWeather.maxTempK - 273.15) * 1.8)
            currentWeather.maxTempC = Int(currentWeather.maxTempK - 273.15)
            currentWeather.minTemp = currentWeather.minTempC
            currentWeather.maxTemp = currentWeather.maxTempC
            currentWeather.city = json["city"]["name"].stringValue
        currentWeather.summary = json["list"][0]["weather"][0]["description"].stringValue
        currentWeather.humidity = json["list"][0]["main"]["humidity"].int!
        currentWeather.pressure = json["list"][0]["main"]["pressure"].int!
        currentWeather.iconName = json["list"][0]["weather"][0]["icon"].stringValue

        updateDataUI()
        }
        else {
            cityName.text = "Weather Unavialble"
        }
  
    }


    func updateDataUI () {
        
        iconName.image = UIImage(named: currentWeather.iconName)
        cityName.text = currentWeather.city
        tempreatureLabel.text = currentWeather.tempreatureStr
        humidityPercent.text = currentWeather.humidityStr
        summaryLabel.text = currentWeather.summary
        minValue.text = currentWeather.minTempValue
        maxValue.text = currentWeather.maxTempValue
        
    }
    
    //MARK : - Implement Method Delegate
  
    func managedCity(city: String) {
 
    let params : [String : String] = ["q" : city , "appid" : ApiKey]
    getWeatherData(url: WeayherUrl, parameters: params)
    
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? AddCityTableViewController {
            vc.delegate = self

        }
    }
}

//MARK : - Add Extension For Get Data From Weather Model

extension CurrentWeather {
    
    var tempreatureStr : String {
        
        return "\(Int(tempreature))º"
        
    }
    
    var humidityStr : String {
        
        return "\(Int(humidity))%"
    }
    
    var minTempValue : String {
        
        return "\(Int(minTemp))º"
        
    }
    
    var maxTempValue : String {
        
        return "\(Int(maxTemp))º"
        
    }
    
    
}
