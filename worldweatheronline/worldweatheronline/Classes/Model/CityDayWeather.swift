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

struct CityDayWeather: Decodable, CustomStringConvertible {
  let date:Date?
  let astronomy:[Astronomy]
  let maxTempInC:Int?
  let maxTempInF:Int?
  let minTempInC:Int?
  let minTempInF:Int?

  let avgTempInC:Int?
  let avgTempInF:Int?
  let totalSnowInCM:Float?
  let sunHour:Float?
  let uvIndex:Int?
  let hourly:[HourlyCondition]

  var description: String {
    return "CityDayWeather"
  }

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
      date = Date();
    } else {
      date = Date();
    }
  }

}
