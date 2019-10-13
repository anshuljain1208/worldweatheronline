//
//  Astronomy.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 10/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation

enum AstronomyCodingKeys: String, CodingKey {
  case sunrise = "sunrise"
  case sunset = "sunset"
  case moonrise = "moonrise"
  case moonset = "moonset"
  case moonPhase = "moon_phase"
  case moonIllumination = "moon_illumination"
}

struct Astronomy: Decodable {
  let sunrise:String?
  let sunset:String?
  let moonrise:String?
  let moonset:String?
  let moonPhase:String?
  let moonIllumination:String?

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AstronomyCodingKeys.self)
    sunrise = try container.decodeIfPresent(String.self, forKey: .sunrise)
    sunset = try container.decodeIfPresent(String.self, forKey: .sunset)
    moonrise = try container.decodeIfPresent(String.self, forKey: .moonrise)
    moonset = try container.decodeIfPresent(String.self, forKey: .moonset)
    moonPhase = try container.decodeIfPresent(String.self, forKey: .moonPhase)
    moonIllumination = try container.decodeIfPresent(String.self, forKey: .moonIllumination)
  }

}
