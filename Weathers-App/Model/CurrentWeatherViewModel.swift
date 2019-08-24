//
//  CurrentWeatherViewModel.swift
//  Weathers-App
//
//  Created by Arash on 8/20/19.
//  Copyright © 2019 Arash. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeatherViewModel {

    let tempreature : String
    let humidity : String
    let precipitaionProbability : String
    let summary : String
    let icon : UIImage
    
//    init(model : CurrentWeather) {
//
//        let roundedTempreature = Int(model.temoreature)
//        self.tempreature = "\(roundedTempreature)"
//
//        let humidityPecentValue = Int(model.humidity * 100)
//        self.humidity = "\(humidityPecentValue)%"
//
//        let precipPercentValue = Int(model.precipitaionProbability * 100)
//        self.precipitaionProbability = "\(precipPercentValue)%"
//
//        self.summary = model.summary
//
//        let weatherIcon = WeatherIcon(rawValue : model.icon)
////        self.icon = weatherIcon.image
//
//    }
}

