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

extension KeyedEncodingContainer {
  public mutating func encodeStringIfPresent(_ value: String?, forKey key: KeyedEncodingContainer<K>.Key) throws {
    if let text = value {
      let dict = ["value": text]
      let list = [dict]
      try self.encode(list, forKey: key)
    }
  }

  public mutating func encodeDoubleIfPresent(_ value: Double?, forKey key: KeyedEncodingContainer<K>.Key) throws {
    if let text = value {
      try self.encode(String(text), forKey: key)
    }
  }

  public mutating func encodeIntIfPresent(_ value: Int?, forKey key: KeyedEncodingContainer<K>.Key) throws {
    if let text = value {
      try self.encode(String(text), forKey: key)
    }
  }

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

struct City: Decodable, CustomStringConvertible, Encodable {
  let name: String
  let country: String?
  let region: String?
  let latitude: Double?
  let longitude: Double?
  let population: Int?

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
    population = try container.decodeNumericIfPresent(Int.self, forKey: .population)
  }

  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CityCodingKeys.self)
      try container.encodeStringIfPresent(name, forKey: .areaName)
      try container.encodeStringIfPresent(country, forKey: .country)
      try container.encodeStringIfPresent(region, forKey: .region)
      try container.encodeDoubleIfPresent(latitude, forKey: .latitude)
      try container.encodeDoubleIfPresent(longitude, forKey: .longitude)
      try container.encodeIntIfPresent(population, forKey: .population)
  }

  var description:String {
    return "name:\(name), " + "country:\(country ?? "No Coutry"), " + "region:\(region ?? "No Region")"
  }
}

extension City: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    if lhs.name == rhs.name, lhs.region == rhs.region, lhs.region == rhs.region {
      return true
    }
    return false
  }
}
