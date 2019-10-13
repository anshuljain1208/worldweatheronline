//
//  RecentCitiesTest.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 12/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation
import XCTest
@testable import worldweatheronline

class RecentCities_Storage :RecentCities {
  override var storageURL: URL {
    return URL(string: "https://www.google.com")!
  }
}

class RecentCitiesTest: XCTestCase {

  var recentCities = RecentCities()

  override func setUp() {
    do {
      try FileManager.default.removeItem(at: RecentCities.storageURL)
    } catch {
      print("\(error)")
    }
    recentCities = RecentCities()
  }

  override func tearDown() {
    try? FileManager.default.removeItem(at: RecentCities.storageURL)
  }

  func testRecentCities_add_differnt() {
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
    recentCities.add(city: city)
    recentCities.add(city: city1)
    print("City Test \([city1,city])")
    print("RecentCities.sharedInstance.list \(recentCities.list)")
    XCTAssert([city1,city] == recentCities.list, "city should match")
    recentCities.add(city: city)
    XCTAssert([city,city1] == recentCities.list, "city should match")


  }

  //Should not crash
  func testRecentCities_wrong_storage() {
    let citySubData = Bundle.stubbedDataFromJson(filename: "city_only_name")
    let decoder = JSONDecoder()
    guard let city = try? decoder.decode(City.self, from: citySubData) else {
      XCTAssert(false, "city.json decode failed ")
      return
    }
    RecentCities_Storage.sharedInstance.add(city: city)
  }


  func testRecentCities_10_plus_add() {
    let jsonData = Bundle.stubbedDataFromJson(filename: "cityList")
    do {
      let decoder = JSONDecoder()
      let cityList = try decoder.decode([City].self, from: jsonData)
      for city in cityList {
        RecentCities.sharedInstance.add(city: city)
      }
      XCTAssert(RecentCities.sharedInstance.list.count == 10, "city should match")
    } catch {
      XCTAssert(false, "city.json decode failed \(error)")
    }
  }

}
