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
  case windDirection = "winddirDegree"
  case windDirection16Point = "winddir16Point"
  case precipitationInMM = "precipMM"
  case precipitationInInches = "precipInches"
  case humidity = "humidity"
  case visibilityInKm = "visibility"
  case visibilityInMiles = "visibilityMiles"
  case pressureInMillibars = "pressure"
  case pressureInInches = "pressureInches"
  case cloudCover = "cloudcover"
  case uvIndex = "uvIndex"
  case temperatureFeelingInC = "FeelsLikeC"
  case temperatureFeelingInF = "FeelsLikeF"
  case weatherIconUrl = "weatherIconUrl"
}

struct CurrentCondition: Decodable {
  let time:Date?
  private let temperatureInC:Int?
  private let temperatureInF:Int?
  let weatherDescription:String?
  //TODO make it Enum
  let weatherCode:Int?
  private let windSpeedInMiles:Int?
  private let windSpeedInKmph:Int?
  let windDirection:Int?
  let windDirection16Point:String?
  let precipitationInMM:Double?
  let precipitationInInches:Double?
  let humidity:Double?
  private let visibilityInKm:Int?
  private let visibilityInMiles:Int?
  private let pressureInMillibars:Int?
  private let pressureInInches:Double?
  let cloudCover:Int?
//  let uvIndex:Int?
  private let temperatureFeelingInC:Int?
  private let temperatureFeelingInF:Int?
  let weatherIconUrl:URL?

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
    windDirection16Point = try container.decodeIfPresent(String.self, forKey: .windDirection16Point)
    precipitationInMM = try container.decodeNumericIfPresent(Double.self, forKey: .precipitationInMM)
    precipitationInInches = try container.decodeNumericIfPresent(Double.self, forKey: .precipitationInInches)
    humidity = try container.decodeNumericIfPresent(Double.self, forKey: .humidity)
    visibilityInKm = try container.decodeNumericIfPresent(Int.self, forKey: .visibilityInKm)
    visibilityInMiles = try container.decodeNumericIfPresent(Int.self, forKey: .visibilityInMiles)
    pressureInMillibars = try container.decodeNumericIfPresent(Int.self, forKey: .pressureInMillibars)
    pressureInInches = try container.decodeNumericIfPresent(Double.self, forKey: .pressureInInches)
    cloudCover = try container.decodeNumericIfPresent(Int.self, forKey: .cloudCover)
//    uvIndex = try container.decodeNumericIfPresent(Int.self, forKey: .uvIndex)
    temperatureFeelingInC = try container.decodeNumericIfPresent(Int.self, forKey: .temperatureFeelingInC)
    temperatureFeelingInF = try container.decodeNumericIfPresent(Int.self, forKey: .temperatureFeelingInF)
    let urlString = try container.decodeStringIfPresent(forKey: .weatherIconUrl) ?? ""
    weatherIconUrl = URL(string: urlString)
  }

  var temperature:String {
    return UserPreferenceFormatter.localizedTemp(inCelsius: self.temperatureInC, inFahrenheit: self.temperatureInF)
  }

  var temperatureFeeling:String {
    return UserPreferenceFormatter.localizedTemp(inCelsius: self.temperatureFeelingInC, inFahrenheit: self.temperatureFeelingInF)
  }

  var visibility:String {
    return UserPreferenceFormatter.localizedDistance(inKM: visibilityInKm, inMiles: visibilityInMiles)
  }

  var windSpeed:String {
    return UserPreferenceFormatter.localizedSpeed(inKilometersPerHour: windSpeedInKmph, inMilesPerHour: windSpeedInMiles)
  }

  var pressure:String {
    return UserPreferenceFormatter.localizedPressure(inMillibars: pressureInMillibars, inchesOfMercury: pressureInInches)
  }
}
