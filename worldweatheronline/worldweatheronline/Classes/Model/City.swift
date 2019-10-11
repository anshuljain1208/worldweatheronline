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

extension KeyedDecodingContainer {
  public func decodeStringIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> String? {
    let valueList = try self.decodeIfPresent([[String:String]].self, forKey: key)
    return valueList?.first?["value"]
  }

  public func decodeNumericIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T? where T : LosslessStringConvertible {
      if let value = try self.decodeIfPresent(String.self, forKey: key) {
        return T(value)
    }
    return nil
  }
}

struct City: Decodable, CustomStringConvertible {
  let name: String
  let country: String?
  let region: String?
  let latitude: Double?
  let longitude: Double?
  let population: Double?

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CityCodingKeys.self)
    if let name = try container.decodeStringIfPresent(forKey: .areaName) {
      self.name = name
    } else {
      self.name = "Unknown"
    }
    country = try container.decodeStringIfPresent(forKey: .country)
    region = try container.decodeStringIfPresent(forKey: .region)
    latitude = try container.decodeNumericIfPresent(Double.self, forKey: .latitude)
    longitude = try container.decodeNumericIfPresent(Double.self, forKey: .longitude)
    population = try container.decodeNumericIfPresent(Double.self, forKey: .population)
  }
  var description:String {
    return "name:\(name), " + "country:\(country ?? "No Coutry"), " + "region:\(region ?? "No Region")"
  }
}
