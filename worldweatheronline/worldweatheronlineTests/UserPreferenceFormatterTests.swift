//
//  UserPreferenceFormatterTests.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 13/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation
import XCTest
@testable import worldweatheronline

class UserPreferenceFormatterMock: UserPreferenceFormatter {
  static var locale: Locale? = nil
  override class func measurementFormatter() -> MeasurementFormatter {
     let formatter = MeasurementFormatter()
     if let locale = UserPreferenceFormatterMock.locale {
        formatter.locale = locale
      }
      return formatter
  }
}

class UserPreferenceFormatterTests: XCTestCase {

  func testDistance() {
    let km:Double = 10
    let miles:Double = 6 //6.21371
    UserPreferenceFormatterMock.locale = Locale(identifier: "en_US")
    let distance_us = UserPreferenceFormatterMock.distance(distanceInKM: km)
    XCTAssert("\(Int(miles)) mi" == distance_us, "Should be equal \(miles) == \(distance_us)")
    let distance_us_1 = UserPreferenceFormatterMock.distance(distanceInMiles: miles)
    XCTAssert("\(Int(miles)) mi" == distance_us_1, "Should be equal \(miles) == \(distance_us_1)")

    let distance_us_2 = UserPreferenceFormatterMock.localizedDistance(inKM: nil, inMiles: Int(miles))
    XCTAssert("\(Int(miles)) mi" == distance_us_2, "Should be equal \(miles) == \(distance_us_2)")

    let distance_us_3 = UserPreferenceFormatterMock.localizedDistance(inKM: Int(km), inMiles: nil)
    XCTAssert("\(Int(miles)) mi" == distance_us_3, "Should be equal \(miles) == \(distance_us_3)")


    UserPreferenceFormatterMock.locale = Locale(identifier: "en_IN")
    let distance_in = UserPreferenceFormatterMock.distance(distanceInMiles: miles)
    XCTAssert("\(Int(km)) km" == distance_in, "Should be equal \(km) == \(distance_in)")

    let distance_in_1 = UserPreferenceFormatterMock.distance(distanceInKM: km)
    XCTAssert("\(Int(km)) km" == distance_in_1, "Should be equal \(km) == \(distance_in)")

    let distance_in_2 = UserPreferenceFormatterMock.localizedDistance(inKM: nil, inMiles: Int(miles))
    XCTAssert("\(Int(km)) km" == distance_in_2, "Should be equal \(km) == \(distance_in_2)")

    let distance_in_3 = UserPreferenceFormatterMock.localizedDistance(inKM: Int(km), inMiles: nil)
    XCTAssert("\(Int(km)) km" == distance_in_3, "Should be equal \(km) == \(distance_in_3)")

    let distance = UserPreferenceFormatterMock.localizedDistance(inKM: nil, inMiles: nil)
    XCTAssert("Unknown" == distance, "Should be equal Unknown == \(distance)")
  }

  func testTemperature() {
    let celsius:Double = 10
    let fahrenheit:Double = 50 //6.21371
    UserPreferenceFormatterMock.locale = Locale(identifier: "en_US")
    let temp_us = UserPreferenceFormatterMock.temperature(tempInC: celsius)
    XCTAssert("\(Int(fahrenheit))°F" == temp_us, "Should be equal \(fahrenheit) == \(temp_us)")
    let temp_us_1 = UserPreferenceFormatterMock.temperature(tempInF: fahrenheit)
    XCTAssert("\(Int(fahrenheit))°F" == temp_us_1, "Should be equal \(fahrenheit) == \(temp_us_1)")

    let temp_us_2 = UserPreferenceFormatterMock.localizedTemp(inCelsius: nil, inFahrenheit: Int(fahrenheit))
    XCTAssert("\(Int(fahrenheit))°F" == temp_us_2, "Should be equal \(fahrenheit) == \(temp_us_2)")

    let temp_us_3 = UserPreferenceFormatterMock.localizedTemp(inCelsius: Int(celsius), inFahrenheit: nil)
    XCTAssert("\(Int(fahrenheit))°F" == temp_us_3, "Should be equal \(fahrenheit) == \(temp_us_3)")


    UserPreferenceFormatterMock.locale = Locale(identifier: "en_IN")
    let temp_in = UserPreferenceFormatterMock.temperature(tempInC: celsius)
    XCTAssert("\(Int(celsius))°C" == temp_in, "Should be equal \(celsius) == \(temp_in)")

    let temp_in_1 = UserPreferenceFormatterMock.temperature(tempInF: fahrenheit)
    XCTAssert("\(Int(celsius))°C" == temp_in_1, "Should be equal \(celsius) == \(temp_in_1)")

    let temp_in_2 = UserPreferenceFormatterMock.localizedTemp(inCelsius: nil, inFahrenheit: Int(fahrenheit))
    XCTAssert("\(Int(celsius))°C" == temp_in_2, "Should be equal \(celsius) == \(temp_in_2)")

    let temp_in_3 = UserPreferenceFormatterMock.localizedTemp(inCelsius: Int(celsius), inFahrenheit: nil)
    XCTAssert("\(Int(celsius))°C" == temp_in_3, "Should be equal \(celsius) == \(temp_in_3)")

    let temp = UserPreferenceFormatterMock.localizedTemp(inCelsius:nil, inFahrenheit: nil)
    XCTAssert("Unknown" == temp, "Should be equal Unknown == \(temp)")
  }

  func testSpeed() {
    let km:Double = 10
    let miles:Double = 6 //6.21371
    UserPreferenceFormatterMock.locale = Locale(identifier: "en_US")
    let speed_us = UserPreferenceFormatterMock.speed(speedInKilometersPerHour: km)
    XCTAssert("\(Int(miles)) mph" == speed_us, "Should be equal \(miles) == \(speed_us)")
    let speed_us_1 = UserPreferenceFormatterMock.speed(speedInMilesPerHour: miles)
    XCTAssert("\(Int(miles)) mph" == speed_us_1, "Should be equal \(miles) == \(speed_us_1)")

    let speed_us_2 = UserPreferenceFormatterMock.localizedSpeed(inKilometersPerHour: nil, inMilesPerHour: Int(miles))
    XCTAssert("\(Int(miles)) mph" == speed_us_2, "Should be equal \(miles) == \(speed_us_2)")

    let speed_us_3 = UserPreferenceFormatterMock.localizedSpeed(inKilometersPerHour: Int(km), inMilesPerHour: nil)
    XCTAssert("\(Int(miles)) mph" == speed_us_3, "Should be equal \(miles) == \(speed_us_3)")


    UserPreferenceFormatterMock.locale = Locale(identifier: "en_IN")
    let speed_in = UserPreferenceFormatterMock.speed(speedInKilometersPerHour: km)
    //Results is different on ios12 and ios 13
    XCTAssert("\(Int(km)) kph" == speed_in || "\(Int(km)) km/hr" == speed_in, "Should be equal \(km) == \(speed_in)")

    let speed_in_1 = UserPreferenceFormatterMock.speed(speedInMilesPerHour: miles)
    XCTAssert("\(Int(km)) kph" == speed_in_1 || "\(Int(km)) km/hr" == speed_in_1, "Should be equal \(km) == \(speed_in_1)")

    let speed_in_2 = UserPreferenceFormatterMock.localizedSpeed(inKilometersPerHour: nil, inMilesPerHour: Int(miles))
    XCTAssert("\(Int(km)) kph" == speed_in_2 || "\(Int(km)) km/hr" == speed_in_2 , "Should be equal \(km) == \(speed_in_2)")

    let speed_in_3 = UserPreferenceFormatterMock.localizedSpeed(inKilometersPerHour: Int(km), inMilesPerHour: nil)
    XCTAssert("\(Int(km)) kph" == speed_in_3 || "\(Int(km)) km/hr" == speed_in_3, "Should be equal \(km) == \(speed_in_3)")

    let speed = UserPreferenceFormatterMock.localizedSpeed(inKilometersPerHour: nil, inMilesPerHour: nil)
    XCTAssert("Unknown" == speed, "Should be equal Unknown == \(speed)")
  }

  func testPressure() {
    let km:Double = 203
    let miles:Double = 6 //6.21371
    UserPreferenceFormatterMock.locale = Locale(identifier: "en_US")
    let pressure_us = UserPreferenceFormatterMock.pressure(inMillibars: km)
    XCTAssert("\(Int(miles)) inHg" == pressure_us, "Should be equal \(miles) == \(pressure_us)")
    let pressure_us_1 = UserPreferenceFormatterMock.pressure(inchesOfMercury: miles)
    XCTAssert("\(Int(miles)) inHg" == pressure_us_1, "Should be equal \(miles) == \(pressure_us_1)")

    let pressure_us_2 = UserPreferenceFormatterMock.localizedPressure(inMillibars: nil, inchesOfMercury: miles)
    XCTAssert("\(Int(miles)) inHg" == pressure_us_2, "Should be equal \(miles) == \(pressure_us_2)")

    let pressure_us_3 = UserPreferenceFormatterMock.localizedPressure(inMillibars: Int(km), inchesOfMercury: nil)
    XCTAssert("\(Int(miles)) inHg" == pressure_us_3, "Should be equal \(miles) == \(pressure_us_3)")


    UserPreferenceFormatterMock.locale = Locale(identifier: "en_IN")
    let pressure_in = UserPreferenceFormatterMock.pressure(inMillibars: km)
    XCTAssert("\(Int(km)) hPa" == pressure_in, "Should be equal \(km) == \(pressure_in)")

    let pressure_in_1 = UserPreferenceFormatterMock.pressure(inchesOfMercury: miles)
    XCTAssert("\(Int(km)) hPa" == pressure_in_1, "Should be equal \(km) == \(pressure_in_1)")

    let pressure_in_2 = UserPreferenceFormatterMock.localizedPressure(inMillibars: nil, inchesOfMercury: miles)
    XCTAssert("\(Int(km)) hPa" == pressure_in_2, "Should be equal \(km) == \(pressure_in_2)")

    let pressure_in_3 = UserPreferenceFormatterMock.localizedPressure(inMillibars: Int(km), inchesOfMercury: nil)
    XCTAssert("\(Int(km)) hPa" == pressure_in_3, "Should be equal \(km) == \(pressure_in_3)")

    let pressure = UserPreferenceFormatterMock.localizedPressure(inMillibars: nil, inchesOfMercury: nil)
    XCTAssert("Unknown" == pressure, "Should be equal Unknown == \(pressure)")
  }

}
