//
//  CityWeather.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 11/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation

enum CityWeatherWrapperCodingKeys: String, CodingKey {
  case data = "data"
}

public enum DataError: Error {
    case emptyResponse
}

extension DataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "Something went wrong. Please try again"
       }
    }
}

struct CityWeatherWrapper: Decodable, CustomStringConvertible {
  let data:CityWeather

  var description: String {
    return "CityWeatherWrapper" + " " + data.description
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CityWeatherWrapperCodingKeys.self)
    if let data = try container.decodeIfPresent(CityWeather.self, forKey: .data) {
      self.data = data
    }
    else {
      throw DataError.emptyResponse
    }
  }
}

enum CityWeatherCodingKeys: String, CodingKey {
  case currentCondition = "current_condition"
  case weather = "weather"
  case request = "request"
  case animMaps = "animMaps"
}


struct CityWeather: Decodable, CustomStringConvertible {
  let currentConditionList:[CurrentCondition]
  let dayWeather:[CityDayWeather]

  var description: String {
    return "CityWeather"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CityWeatherCodingKeys.self)
    if let currentConditionList = try container.decodeIfPresent([CurrentCondition].self, forKey: .currentCondition) {
      self.currentConditionList = currentConditionList
    } else {
      self.currentConditionList = [CurrentCondition]()
    }
    if let dayWeather = try container.decodeIfPresent([CityDayWeather].self, forKey: .weather) {
      self.dayWeather = dayWeather
    } else {
      self.dayWeather = [CityDayWeather]()
    }
  }

}
