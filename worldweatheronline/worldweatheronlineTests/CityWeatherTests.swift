//
//  CityWeatherTests.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import XCTest
@testable import worldweatheronline

class CityWeatherTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testCity_valid() {
      let citySubData = Bundle.stubbedDataFromJson(filename: "cityHourly")
      let decoder = JSONDecoder()
      do {
        let cityHourly = try decoder.decode(HourlyCondition.self, from: citySubData)
        print(cityHourly.description);
      } catch {
        XCTAssert(false, "cityHourly.json decode failed \(error)")
      }
    }

  func testCityList_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "cityHourlyList")
    let decoder = JSONDecoder()
    do {
      let cityHourly = try decoder.decode([HourlyCondition].self, from: citySubData)
      print(cityHourly.description);
    } catch {
      XCTAssert(false, "cityHourlyList.json decode failed \(error)")
    }
  }

  func testAstronomy_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "astronomy")
    let decoder = JSONDecoder()
    do {
      let astronomy = try decoder.decode(Astronomy.self, from: citySubData)
      print(astronomy.description);
    } catch {
      XCTAssert(false, "astronomy.json decode failed \(error)")
    }
  }

  func testCurrentCondition_no_date_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "current_condition_no_url")
    let decoder = JSONDecoder()
    do {
      let astronomy = try decoder.decode(CurrentCondition.self, from: citySubData)
      print(astronomy.description);
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

  func testCityDayWeather_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "cityDayWeather")
    let decoder = JSONDecoder()
    do {
      let astronomy = try decoder.decode(CityDayWeather.self, from: citySubData)
      print(astronomy.description);
    } catch {
      XCTAssert(false, "cityWeather.json decode failed \(error)")
    }
  }

  func testCityDayWeather_1_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "cityDayWeather_1")
    let decoder = JSONDecoder()
    do {
      let astronomy = try decoder.decode(CityDayWeather.self, from: citySubData)
      print(astronomy.description);
    } catch {
      XCTAssert(false, "cityWeather.json decode failed \(error)")
    }
  }

  func testCityWeather_valid() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "cityWeather")
    let decoder = JSONDecoder()
    do {
      let cityWeather = try decoder.decode(CityWeatherWrapper.self, from: citySubData)
      print(cityWeather.description);
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
