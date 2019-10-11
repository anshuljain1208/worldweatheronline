//
//  CurrentCondition.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 10/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//
import Foundation

enum CurrentConditionCodingKeys: String, CodingKey {
  case time = "observation_time"
  case temperatureInC = "temp_C"
  case temperatureInF = "temp_F"
  case weatherDescription = "weatherDesc"
  case weatherCode = "weatherCode"
  case windSpeedInMiles = "windspeedMiles"
  case windSpeedInKmph = "windspeedKmph"
  case windDirection = "110"
  case windDirection16Point = "ESE"
  case precipitationInMM = "precipMM"
  case precipitationInInches = "precipInches"
  case humidity = "humidity"
  case visibility = "visibility"
  case visibilityInMiles = "visibilityMiles"
  case pressure = "pressure"
  case pressureInInches = "pressureInches"
  case cloudCover = "cloudcover"
  case uvIndex = "uvIndex"
  case temperatureFeelingInC = "FeelsLikeC"
  case temperatureFeelingInF = "FeelsLikeF"
  case weatherIconUrl = "weatherIconUrl"
}

struct CurrentCondition: Decodable, CustomStringConvertible {
  let time:Date?
  let temperatureInC:Int?
  let temperatureInF:Int?
  let weatherDescription:String?
  //TODO make it Enum
  let weatherCode:Int?
  let windSpeedInMiles:Int?
  let windSpeedInKmph:Int?
  let windDirection:Int?
  let windDirection16Point:String?
  let precipitationInMM:Double?
  let precipitationInInches:Double?
  let humidity:Double?
  let visibility:Int?
  let visibilityInMiles:Int?
  let pressure:Int?
  let pressureInInches:Double?
  let cloudCover:Int?
//  let uvIndex:Int?
  let temperatureFeelingInC:Int?
  let temperatureFeelingInF:Int?
  let weatherIconUrl:URL?

  var description: String {
    return "CurrentCondition"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CurrentConditionCodingKeys.self)
    if let timestamp = try container.decodeNumericIfPresent(Double.self, forKey: .time) {
      self.time = Date(timeIntervalSince1970: timestamp)
    } else {
      self.time = Date()
    }
    temperatureInC = try container.decodeNumericIfPresent(Int.self, forKey: .temperatureInC)
    temperatureInF = try container.decodeNumericIfPresent(Int.self, forKey: .temperatureInF)
    weatherDescription = try container.decodeStringIfPresent(forKey: .weatherDescription)
    weatherCode = try container.decodeNumericIfPresent(Int.self, forKey: .weatherCode)
    windSpeedInMiles = try container.decodeNumericIfPresent(Int.self, forKey: .windSpeedInMiles)
    windSpeedInKmph = try container.decodeNumericIfPresent(Int.self, forKey: .windSpeedInKmph)
    windDirection = try container.decodeNumericIfPresent(Int.self, forKey: .windDirection)
    windDirection16Point = try container.decodeStringIfPresent(forKey: .windDirection16Point)
    precipitationInMM = try container.decodeNumericIfPresent(Double.self, forKey: .precipitationInMM)
    precipitationInInches = try container.decodeNumericIfPresent(Double.self, forKey: .precipitationInInches)
    humidity = try container.decodeNumericIfPresent(Double.self, forKey: .humidity)
    visibility = try container.decodeNumericIfPresent(Int.self, forKey: .visibility)
    visibilityInMiles = try container.decodeNumericIfPresent(Int.self, forKey: .visibilityInMiles)
    pressure = try container.decodeNumericIfPresent(Int.self, forKey: .pressure)
    pressureInInches = try container.decodeNumericIfPresent(Double.self, forKey: .pressureInInches)
    cloudCover = try container.decodeNumericIfPresent(Int.self, forKey: .cloudCover)
//    uvIndex = try container.decodeNumericIfPresent(Int.self, forKey: .uvIndex)
    temperatureFeelingInC = try container.decodeNumericIfPresent(Int.self, forKey: .temperatureFeelingInC)
    temperatureFeelingInF = try container.decodeNumericIfPresent(Int.self, forKey: .temperatureFeelingInF)
    let urlString = try container.decodeStringIfPresent(forKey: .weatherIconUrl) ?? ""
    weatherIconUrl = URL(string: urlString)
  }
}
