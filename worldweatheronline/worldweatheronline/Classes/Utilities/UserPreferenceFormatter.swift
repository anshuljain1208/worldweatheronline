//
//  UserPreferenceFormatter.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 13/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation

class UserPreferenceFormatter {
  class func measurementFormatter() -> MeasurementFormatter {
      return MeasurementFormatter()
  }

  class func temperature(tempInC: Double) -> String{
    let mf = self.measurementFormatter()
      mf.numberFormatter.maximumFractionDigits = 0
      let t = Measurement(value: tempInC, unit: UnitTemperature.celsius)
      return (String(format:"%@", mf.string(from: t)))
  }

  class func temperature(tempInF: Double) -> String{
      let mf = self.measurementFormatter()
      mf.numberFormatter.maximumFractionDigits = 0
      let t = Measurement(value: tempInF, unit: UnitTemperature.fahrenheit)
      return (String(format:"%@", mf.string(from: t)))
  }

  class func distance(distanceInKM: Double) -> String{
      let mf = self.measurementFormatter()
      mf.numberFormatter.maximumFractionDigits = 0
      let t = Measurement(value: distanceInKM, unit: UnitLength.kilometers)
      return (String(format:"%@", mf.string(from: t)))
  }

  class func distance(distanceInMiles: Double) -> String{
      let mf = self.measurementFormatter()
      mf.numberFormatter.maximumFractionDigits = 0
      let t = Measurement(value: distanceInMiles, unit: UnitLength.miles)
      return (String(format:"%@", mf.string(from: t)))
  }

  class func speed(speedInKilometersPerHour: Double) -> String{
      let mf = self.measurementFormatter()
      mf.numberFormatter.maximumFractionDigits = 0
      let t = Measurement(value: speedInKilometersPerHour, unit: UnitSpeed.kilometersPerHour)
      return (String(format:"%@", mf.string(from: t)))
  }

  class func speed(speedInMilesPerHour: Double) -> String{
      let mf = self.measurementFormatter()
      mf.numberFormatter.maximumFractionDigits = 0
      let t = Measurement(value: speedInMilesPerHour, unit: UnitSpeed.milesPerHour)
      return (String(format:"%@", mf.string(from: t)))
  }

  class func pressure(inMillibars: Double) -> String{
      let mf = self.measurementFormatter()
      mf.numberFormatter.maximumFractionDigits = 0
      let t = Measurement(value: inMillibars, unit: UnitPressure.millibars)
      return (String(format:"%@", mf.string(from: t)))
  }

  class func pressure(inchesOfMercury: Double) -> String {
      let mf = self.measurementFormatter()
      mf.numberFormatter.maximumFractionDigits = 0
      let t = Measurement(value: inchesOfMercury, unit: UnitPressure.inchesOfMercury)
      return (String(format:"%@", mf.string(from: t)))
  }

  class func date(fromString string:String) -> Date? {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter.date(from: string)
  }
}

extension UserPreferenceFormatter {
  class func localizedTemp(inCelsius:Int?, inFahrenheit :Int?) ->String {
    if let celsius = inCelsius {
      return self.temperature(tempInC:Double(celsius))
    }
    if let fahrenheit = inFahrenheit {
      return self.temperature(tempInF: Double(fahrenheit))
    }
    return "Unknown"
  }

  class func localizedDistance(inKM:Int?, inMiles :Int?) ->String {
    if let km = inKM {
      return self.distance(distanceInKM:Double(km))
    }
    if let miles = inMiles {
      return self.distance(distanceInMiles: Double(miles))
    }
    return "Unknown"
  }

  class func localizedSpeed(inKilometersPerHour kmph:Int?, inMilesPerHour mph:Int?) ->String {
    if let km = kmph {
      return self.speed(speedInKilometersPerHour:Double(km))
    }
    if let miles = mph {
      return self.speed(speedInMilesPerHour: Double(miles))
    }
    return "Unknown"
  }

  class func localizedPressure(inMillibars millibars:Int?, inchesOfMercury inches:Double?) ->String {
    if let mb = millibars {
      return self.pressure(inMillibars:Double(mb))
    }
    if let inch = inches {
      return self.pressure(inchesOfMercury: inch)
    }
    return "Unknown"
  }

  class func localizedStringTime(date: Date)->String {
    return DateFormatter.localizedString(from:date , dateStyle: .short, timeStyle: .none)
  }
}
