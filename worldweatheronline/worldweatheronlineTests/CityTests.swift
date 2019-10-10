//
//  worldweatheronlineTests.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import XCTest
@testable import worldweatheronline

class CityTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testCity_valid() {
      let citySubData = Bundle.stubbedDataFromJson(filename: "city")
      let decoder = JSONDecoder()
      do {
        let city = try decoder.decode(City.self, from: citySubData)
        print(city.description);
      } catch {
        XCTAssert(false, "city.json decode failed \(error)")
      }
    }

  func testCity_valid_onlyName() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "city_only_name")
    let decoder = JSONDecoder()
    do {
      let city = try decoder.decode(City.self, from: citySubData)
      print(city.description);
    } catch {
      XCTAssert(false, "city.json decode failed \(error)")
    }
  }

  func testCity_No_Name() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "city_no_name")
    let decoder = JSONDecoder()
    do {
      let city = try decoder.decode(City.self, from: citySubData)
      XCTAssert(city.name == "Unknown", "city name should Unknown \(city.name)")
    } catch {
      XCTAssert(false, "city.json decode failed \(error)")
    }
  }

  func testCity_invalid_json() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "city_invalid")
    let decoder = JSONDecoder()
    do {
      let city = try decoder.decode(City.self, from: citySubData)
      XCTAssert(false, "Should fail \(city)")
    } catch _ as DecodingError {
      XCTAssert(true)
    } catch  {
      XCTAssert(false, "should throw DecodingError \(error)")
    }
  }

    func testCityListDecodable() {
      let jsonData = Bundle.stubbedDataFromJson(filename: "cityList")
      do {
        let decoder = JSONDecoder()
        let city = try decoder.decode([City].self, from: jsonData)
        print(city);
      } catch {
        XCTAssert(false, "city.json decode failed \(error)")
      }
    }

    func testSearchResultDecodable() {
      let jsonData = Bundle.stubbedDataFromJson(filename: "serachResults")
      do {
        let searchResult = try SerachResult(query: "serachResults", jsonData: jsonData)
        print(searchResult);
      } catch {
        XCTAssert(false, "city.json decode failed \(error)")
      }
    }
  
   func testSearchResult_empty() {
     let jsonData = Bundle.stubbedDataFromJson(filename: "serachResults_empty")
     do {
       let searchResult = try SerachResult(query: "serachResults", jsonData: jsonData)
       print(searchResult.description);
     } catch {
       XCTAssert(false, "city.json decode failed \(error)")
     }
   }

    func testSearchResult_none() {
       let jsonData = Bundle.stubbedDataFromJson(filename: "serachResults_none")
       do {
         let searchResult = try SerachResult(query: "serachResults", jsonData: jsonData)
         print(searchResult.description);
       } catch {
         XCTAssert(false, "city.json decode failed \(error)")
       }

    }


}
