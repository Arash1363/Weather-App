//
//  CurrentWeather.swift
//  Weathers-App
//
//  Created by Arash on 8/19/19.
//  Copyright © 2019 Arash. All rights reserved.
//

import Foundation

class CurrentWeather {
    
    var tempreature : Double = 0.0
    var tempreatureC : Double = 0.0
    var tempreatureF : Double = 0.0
    var minTemp : Double = 0.0
    var maxTemp : Double = 0.0
    var minTempK : Double = 0.0
    var minTempF : Double = 0.0
    var minTempC : Double = 0.0
    var maxTempK : Double = 0.0
    var maxTempF : Double = 0.0
    var maxTempC : Double = 0.0
    var humidity : Double = 0.0
    var pressure : Double = 0.0
    var summary : String = ""
    var iconName : String = ""
    var city : String = ""
    
    func updateWeatherIcon (rawValue : String) -> String {
        
        let iconNameText = rawValue
        
        switch (rawValue) {
        case iconNameText :
            return iconNameText
    
        default:
            return "nothing"
        }
    
    }
}
