//
//  worldweatheronlineTests.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import XCTest
@testable import Weather

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
        XCTAssert(city.name == "Seabrook", "name should be Seabrook")
        XCTAssert(city.latitude == 30.032, "latitude should be 30.032")
        XCTAssert(city.longitude == -90.013, "longitude should be -90.013")
        XCTAssert(city.country == "United States of America", "country should be United States of America")
        XCTAssert(city.region == "Louisiana", "region should be Louisiana")
        XCTAssert(city.population == 0, "region should be population")

        let encoder = JSONEncoder()
        let data = try encoder.encode(city)
        let encodedCity = try decoder.decode(City.self, from: data)
        XCTAssert(city == encodedCity, "city not match")
        XCTAssert(city.population == encodedCity.population, "population not match")
        XCTAssert(city.latitude == encodedCity.latitude, "latitude not match")
        XCTAssert(city.longitude == encodedCity.longitude, "name not match")
      } catch {
        XCTAssert(false, "city.json decode failed \(error)")
      }
    }

  func testCity_valid_onlyName() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "city_only_name")
    let decoder = JSONDecoder()
    do {
      let city = try decoder.decode(City.self, from: citySubData)
      XCTAssert(city.name == "Seabrook", "name should be Seabrook")
      XCTAssert(city.latitude == nil, "latitude should be nil")
      XCTAssert(city.longitude == nil, "longitude should be nil")
      XCTAssert(city.country == nil, "country should be nil")
      XCTAssert(city.region == nil, "region should be nil")
    } catch {
      XCTAssert(false, "city.json decode failed \(error)")
    }
  }

  func testCity_equality() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "city_only_name")
    let decoder = JSONDecoder()
    guard let city = try? decoder.decode(City.self, from: citySubData) else {
      XCTAssert(false, "city.json decode failed ")
      return
    }
    let citySubData1 = Bundle.stubbedDataFromJson(filename: "city")
    guard let city1 = try? decoder.decode(City.self, from: citySubData1) else {
      XCTAssert(false, "city.json decode failed ")
      return
    }
    XCTAssert(city != city1, "city should not match")

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

  //MARK SearchResult Test
    func testSearchResultDecodable() {
      let jsonData = Bundle.stubbedDataFromJson(filename: "serachResults")
      do {
        let searchResult = try SearchResult(query: "serachResults", jsonData: jsonData)
        XCTAssert(searchResult.query == "serachResults", "query wrong")
        XCTAssert(searchResult.results.count == 10, "searchResult.results.count is 0")
        print(searchResult);
      } catch {
        XCTAssert(false, "city.json decode failed \(error)")
      }
    }
  
   func testSearchResult_empty() {
     let jsonData = Bundle.stubbedDataFromJson(filename: "serachResults_empty")
     do {
       let searchResult = try SearchResult(query: "serachResults", jsonData: jsonData)
      XCTAssert(searchResult.query == "serachResults", "query wrong")
      XCTAssert(searchResult.results.count == 0, "searchResult.results.count is 0")
} catch {
       XCTAssert(false, "city.json decode failed \(error)")
     }
   }

    func testSearchResult_none() {
       let jsonData = Bundle.stubbedDataFromJson(filename: "serachResults_none")
       do {
         let searchResult = try SearchResult(query: "serachResults", jsonData: jsonData)
         XCTAssert(searchResult.query == "serachResults", "query wrong")
         XCTAssert(searchResult.results.count == 0, "searchResult.results.count is 0")
       } catch {
         XCTAssert(false, "city.json decode failed \(error)")
       }

    }


}
