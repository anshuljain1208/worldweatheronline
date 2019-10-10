//
//  City.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 10/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation

enum CityCodingKeys: String, CodingKey {
  case areaName
  case country
  case region
  case latitude
  case longitude
  case population
}

struct City: Decodable, CustomStringConvertible {
  let name: String
  let country: String?
  let region: String?
  let latitude: Double?
  let longitude: Double?
  let population: Double?
  static func decodeContainerValue(_ container: KeyedDecodingContainer<CityCodingKeys>, forKey key:CityCodingKeys ) throws -> String? {
    let valueList = try container.decodeIfPresent([[String:String]].self, forKey: key)
    return valueList?.first?["value"]
  }

  static func decodeDouble(_ container: KeyedDecodingContainer<CityCodingKeys>, forKey key:CityCodingKeys ) throws -> Double? {
    if let value = try container.decodeIfPresent(String.self, forKey: key) {
      return Double(value)
    }
    return nil
  }


  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CityCodingKeys.self)
    if let name = try City.decodeContainerValue(container, forKey: .areaName) {
      self.name = name
    } else {
      self.name = "Unknown"
    }
    country = try City.decodeContainerValue(container, forKey: .country)
    region = try City.decodeContainerValue(container, forKey: .region)
    latitude = try City.decodeDouble(container, forKey: .latitude)
    longitude = try City.decodeDouble(container, forKey: .longitude)
    population = try City.decodeDouble(container, forKey: .population)
  }
  var description:String {
    return "name:\(name), " + "country:\(country ?? "No Coutry"), " + "region:\(region ?? "No Region")"
  }
}
