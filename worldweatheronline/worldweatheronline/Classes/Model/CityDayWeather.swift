//
//  CityWeather.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 11/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation


enum CityDayWeatherCodingKeys: String, CodingKey {
  case date = "date"
  case astronomy = "astronomy"
  case maxTempInC = "maxtempC"
  case maxTempInF = "maxtempF"
  case minTempInC = "mintempC"
  case minTempInF = "mintempF"
  case avgTempInC = "avgtempC"
  case avgTempInF = "avgtempF"
  case totalSnowInCM = "totalSnow_cm"
  case sunHour = "sunHour"
  case uvIndex = "uvIndex"
  case hourly = "hourly"
}

struct CityDayWeather: Decodable {
  let date:Date?
  let astronomy:[Astronomy]
  private let maxTempInC:Int?
  private let maxTempInF:Int?
  private let minTempInC:Int?
  private let minTempInF:Int?

  private let avgTempInC:Int?
  private let avgTempInF:Int?
  let totalSnowInCM:Float?
  let sunHour:Float?
  let uvIndex:Int?
  let hourly:[HourlyCondition]

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CityDayWeatherCodingKeys.self)
    maxTempInC = try container.decodeNumericIfPresent(Int.self, forKey: .maxTempInC)
    maxTempInF = try container.decodeNumericIfPresent(Int.self, forKey: .maxTempInF)
    minTempInC = try container.decodeNumericIfPresent(Int.self, forKey: .minTempInC)
    minTempInF = try container.decodeNumericIfPresent(Int.self, forKey: .minTempInF)
    avgTempInC = try container.decodeNumericIfPresent(Int.self, forKey: .avgTempInC)
    avgTempInF = try container.decodeNumericIfPresent(Int.self, forKey: .avgTempInF)
    uvIndex = try container.decodeNumericIfPresent(Int.self, forKey: .uvIndex)
    totalSnowInCM = try container.decodeNumericIfPresent(Float.self, forKey: .totalSnowInCM)
    sunHour = try container.decodeNumericIfPresent(Float.self, forKey: .sunHour)
    if let astronomy = try container.decodeIfPresent([Astronomy].self, forKey: .astronomy) {
      self.astronomy = astronomy
    } else {
      self.astronomy = [Astronomy]()
    }
    if let hourly = try container.decodeIfPresent([HourlyCondition].self, forKey: .hourly) {
      self.hourly = hourly
    } else {
      self.hourly = [HourlyCondition]()
    }
    let dateString = try container.decodeIfPresent(String.self, forKey: .date)
    if let dateString = dateString {
      date = UserPreferenceFormatter.date(fromString: dateString);
    } else {
      date = Date();
    }
  }

  var maxTemp:String {
    return UserPreferenceFormatter.localizedTemp(inCelsius: self.maxTempInC, inFahrenheit: self.maxTempInF)
  }

  var minTemp:String {
    return UserPreferenceFormatter.localizedTemp(inCelsius: self.minTempInC, inFahrenheit: self.minTempInF)
  }

  var avgTemp:String {
    return UserPreferenceFormatter.localizedTemp(inCelsius: self.avgTempInC, inFahrenheit: self.avgTempInF)
  }
}
