//
//  CityWeatherTests.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import XCTest
@testable import Weather

class CityWeatherTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
  //MARK HourlyCondition test
    func testCity_valid() {
      let citySubData = Bundle.stubbedDataFromJson(filename: "cityHourly")
      let decoder = JSONDecoder()
      do {
        let cityHourly = try decoder.decode(HourlyCondition.self, from: citySubData)
        XCTAssert(cityHourly.heat == UserPreferenceFormatter.localizedTemp(inCelsius: 27, inFahrenheit: 80), "heat check failed")
        XCTAssert(cityHourly.dewPoint == UserPreferenceFormatter.localizedTemp(inCelsius: 20, inFahrenheit: 69), "dewPoint check failed")
        XCTAssert(cityHourly.windChill == UserPreferenceFormatter.localizedTemp(inCelsius: 25, inFahrenheit: 77), "windChill check failed")
        XCTAssert(cityHourly.windGust == UserPreferenceFormatter.localizedDistance(inKM: 14 , inMiles: 9), "avgTemp check failed")
        XCTAssert(cityHourly.windGust == UserPreferenceFormatter.localizedDistance(inKM: 14 , inMiles: 9), "avgTemp check failed")
        XCTAssert(cityHourly.chanceOfRain == 0, "chanceOfRain check failed")
        XCTAssert(cityHourly.chanceOfRemDry == 90, "chanceOfRemDry check failed")
        XCTAssert(cityHourly.chanceOfWindy == 0, "chanceOfWindy check failed")
        XCTAssert(cityHourly.chanceOfOvercast == 13, "chanceOfOvercast check failed")
        XCTAssert(cityHourly.chanceOfSunshine == 89, "chanceOfSunshine check failed")
        XCTAssert(cityHourly.chanceOfFrost == 0, "chanceOfFrost check failed")
        XCTAssert(cityHourly.chanceOfHighTemp == 30, "chanceOfHighTemp check failed")
        XCTAssert(cityHourly.chanceOfFog == 0, "chanceOfFog check failed")
        XCTAssert(cityHourly.chanceOfSnow == 0, "chanceOfSnow check failed")
        XCTAssert(cityHourly.chanceOfThunder == 0, "chanceOfThunder check failed")
      } catch {
        XCTAssert(false, "cityHourly.json decode failed \(error)")
      }
    }

  func testCityList_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "cityHourlyList")
    let decoder = JSONDecoder()
    do {
      let cityHourly = try decoder.decode([HourlyCondition].self, from: citySubData)
      XCTAssert(cityHourly.count == 4, "cityHourly count should 4 but it is \(cityHourly.count)")
    } catch {
      XCTAssert(false, "cityHourlyList.json decode failed \(error)")
    }
  }

  //MARK Astronomy test
  func testAstronomy_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "astronomy")
    let decoder = JSONDecoder()
    do {
      let astronomy = try decoder.decode(Astronomy.self, from: citySubData)
      XCTAssert(astronomy.sunrise == "06:59 AM", "sunrise check failed")
      XCTAssert(astronomy.sunset == "06:35 PM", "sunset check failed")
      XCTAssert(astronomy.moonrise == "05:19 PM", "moonrise check failed")
      XCTAssert(astronomy.moonset == "04:02 AM", "moonset check failed")
      XCTAssert(astronomy.moonPhase == "Waxing Gibbous", "moonPhase check failed")
      XCTAssert(astronomy.moonIllumination == "77", "moonIllumination check failed")
    } catch {
      XCTAssert(false, "astronomy.json decode failed \(error)")
    }
  }

  func testCurrentCondition_no_url() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "current_condition_no_url")
    let decoder = JSONDecoder()
    do {
      let currentCondition = try decoder.decode(CurrentCondition.self, from: citySubData)
      XCTAssert(currentCondition.cloudCover == 0, "cloudCover check failed")
      XCTAssert(currentCondition.humidity == 85, "humidity check failed")
      XCTAssert(currentCondition.precipitationInInches == 0.0, "precipitationInInches check failed")
      XCTAssert(currentCondition.precipitationInMM == 0.0, "precipitationInMM check failed")
      XCTAssert(currentCondition.windDirection16Point == "ESE", "windDirection16Point check failed")
      XCTAssert(currentCondition.windDirection == 110, "windDirection check failed")
      XCTAssert(currentCondition.weatherIconUrl == nil, "weatherIconUrl check failed")
      XCTAssert(currentCondition.weatherDescription == "Sunny", "weatherDescription check failed")
      XCTAssert(currentCondition.weatherCode == 113, "weatherCode check failed")
      XCTAssert(currentCondition.time == Date(timeIntervalSince1970: 1570714471), "time check failed")
      XCTAssert(currentCondition.pressure == UserPreferenceFormatter.localizedPressure(inMillibars: 1016, inchesOfMercury: 30), "pressure check failed")
      XCTAssert(currentCondition.windSpeed == UserPreferenceFormatter.localizedSpeed(inKilometersPerHour: 11, inMilesPerHour: 7), "maxTemp conversion failed")
      XCTAssert(currentCondition.visibility == UserPreferenceFormatter.localizedDistance(inKM: 16, inMiles: 9), "avgTemp conversion failed")
      XCTAssert(currentCondition.temperatureFeeling == UserPreferenceFormatter.localizedTemp(inCelsius: 29, inFahrenheit: 85), "avgTemp conversion failed")
      XCTAssert(currentCondition.temperature == UserPreferenceFormatter.localizedTemp(inCelsius: 26, inFahrenheit: 79), "maxTemp conversion failed")
    } catch {
      XCTAssert(false, "astronomy.json decode failed \(error)")
    }
  }

  func testCurrentCondition_invalid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "current_condition_invalid")
    let decoder = JSONDecoder()
    do {
      let _ = try decoder.decode(CurrentCondition.self, from: citySubData)
      XCTAssert(false, "should throw error")
    } catch {
      XCTAssert(true)
    }
  }

  //MARK CityDayWeather test
  func testCityDayWeather_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "cityDayWeather")
    let decoder = JSONDecoder()
    do {
      let weather = try decoder.decode(CityDayWeather.self, from: citySubData)
      XCTAssert(weather.avgTemp == UserPreferenceFormatter.localizedTemp(inCelsius: 27, inFahrenheit: 80), "avgTemp check failed")
      XCTAssert(weather.maxTemp == UserPreferenceFormatter.localizedTemp(inCelsius: 30, inFahrenheit: 86), "maxTemp check failed")
      XCTAssert(weather.minTemp == UserPreferenceFormatter.localizedTemp(inCelsius: 24, inFahrenheit: 75), "avgTemp check failed")
      XCTAssert(weather.uvIndex == 7, "avgTemp check failed")
      XCTAssert(weather.totalSnowInCM == 0.0, "maxTemp check failed")
      XCTAssert(weather.sunHour == 7.3, "avgTemp check failed")
} catch {
      XCTAssert(false, "cityWeather.json decode failed \(error)")
    }
  }

  func testCityDayWeather_1_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "cityDayWeather_1")
    let decoder = JSONDecoder()
    do {
      _ = try decoder.decode(CityDayWeather.self, from: citySubData)
    } catch {
      XCTAssert(false, "cityWeather.json decode failed \(error)")
    }
  }

  //MARK CityWeatherWrapper test
  func testCityWeather_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "cityWeather")
    let decoder = JSONDecoder()
    do {
      _ = try decoder.decode(CityWeatherWrapper.self, from: citySubData)
} catch {
      XCTAssert(false, "cityWeather.json decode failed \(error)")
    }
  }

  func testCityWeather_invalid() {
    let citySubData = "{\"data1\":\"\"}".data(using: .utf8)!
    let decoder = JSONDecoder()
    do {
      _ = try decoder.decode(CityWeatherWrapper.self, from: citySubData)
      XCTAssert(false,"should thrpw Exception")
    } catch (let error as DataError) {
      XCTAssert(error.errorDescription == "Something went wrong. Please try again","Wrong error description")
    } catch {
      XCTAssert(false,"should throw DataError \(error)")
    }
  }

  func testCityWeather_invalid_1() {
    let citySubData = "{\"data\":\"\"}".data(using: .utf8)!
    let decoder = JSONDecoder()
    do {
      let _ = try decoder.decode(CityWeatherWrapper.self, from: citySubData)
      XCTAssert(false,"should throw")
    } catch {
    }
  }

}
