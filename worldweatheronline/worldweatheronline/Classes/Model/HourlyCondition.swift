//
//  HourlyCondition.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 10/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation

enum HourlyConditionCodingKeys: String, CodingKey {
  case heatIndexInC = "HeatIndexC"
  case heatIndexInF = "HeatIndexF"
  case dewPointInC = "DewPointC"
  case dewPointInF = "DewPointF"
  case windChillInC = "WindChillC"
  case windChillInF = "WindChillF"
  case windGustInMiles = "WindGustMiles"
  case windGustInKmph = "WindGustKmph"
  case chanceOfRain = "chanceofrain"
  case chanceOfRemDry = "chanceofremdry"
  case chanceOfWindy = "chanceofwindy"
  case chanceOfOvercast = "chanceofovercast"
  case chanceOfSunshine = "chanceofsunshine"
  case chanceOfFrost = "chanceoffrost"
  case chanceOfHighTemp = "chanceofhightemp"
  case chanceOfFog = "chanceoffog"
  case chanceOfSnow = "chanceofsnow"
  case chanceOfThunder = "chanceofthunder"
}

struct HourlyCondition: Decodable {

  let conditions:CurrentCondition
  private let heatIndexInC:Int?
  private let heatIndexInF:Int?
  private let dewPointInC:Int?
  private let dewPointInF:Int?
  private let windChillInC:Int?
  private let windChillInF:Int?
  private let windGustInMiles:Int?
  private let windGustInKmph:Int?
  let chanceOfRain:Int?
  let chanceOfRemDry:Int?
  let chanceOfWindy:Int?
  let chanceOfOvercast:Int?
  let chanceOfSunshine:Int?
  let chanceOfFrost:Int?
  let chanceOfHighTemp:Int?
  let chanceOfFog:Int?
  let chanceOfSnow:Int?
  let chanceOfThunder:Int?


  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: HourlyConditionCodingKeys.self)
    conditions = try CurrentCondition(from: decoder)
    heatIndexInC = try container.decodeNumericIfPresent(Int.self, forKey: .heatIndexInC)
    heatIndexInF = try container.decodeNumericIfPresent(Int.self, forKey: .heatIndexInF)
    dewPointInC = try container.decodeNumericIfPresent(Int.self, forKey: .dewPointInC)
    dewPointInF = try container.decodeNumericIfPresent(Int.self, forKey: .dewPointInF)
    windChillInC = try container.decodeNumericIfPresent(Int.self, forKey: .windChillInC)
    windChillInF = try container.decodeNumericIfPresent(Int.self, forKey: .windChillInF)
    windGustInMiles = try container.decodeNumericIfPresent(Int.self, forKey: .windGustInMiles)
    windGustInKmph = try container.decodeNumericIfPresent(Int.self, forKey: .windGustInKmph)
    chanceOfRain = try container.decodeNumericIfPresent(Int.self, forKey: .chanceOfRain)
    chanceOfRemDry = try container.decodeNumericIfPresent(Int.self, forKey: .chanceOfRemDry)
    chanceOfWindy = try container.decodeNumericIfPresent(Int.self, forKey: .chanceOfWindy)
    chanceOfOvercast = try container.decodeNumericIfPresent(Int.self, forKey: .chanceOfOvercast)
    chanceOfSunshine = try container.decodeNumericIfPresent(Int.self, forKey: .chanceOfSunshine)
    chanceOfFrost = try container.decodeNumericIfPresent(Int.self, forKey: .chanceOfFrost)
    chanceOfHighTemp = try container.decodeNumericIfPresent(Int.self, forKey: .chanceOfHighTemp)
    chanceOfFog = try container.decodeNumericIfPresent(Int.self, forKey: .chanceOfFog)
    chanceOfSnow = try container.decodeNumericIfPresent(Int.self, forKey: .chanceOfSnow)
    chanceOfThunder = try container.decodeNumericIfPresent(Int.self, forKey: .chanceOfThunder)
  }

  var windGust:String {
    return UserPreferenceFormatter.localizedDistance(inKM: windGustInKmph, inMiles: windGustInMiles)
  }

  var windChill:String {
    return UserPreferenceFormatter.localizedTemp(inCelsius: self.windChillInC, inFahrenheit: self.windChillInF)
  }

  var dewPoint:String {
    return UserPreferenceFormatter.localizedTemp(inCelsius: self.dewPointInC, inFahrenheit: self.dewPointInF)
  }

  var heat:String {
    return UserPreferenceFormatter.localizedTemp(inCelsius: self.heatIndexInC, inFahrenheit: self.heatIndexInF)
  }
}
