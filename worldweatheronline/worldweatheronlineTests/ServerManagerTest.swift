//
//  ServerManagerTest.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 12/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation
import XCTest
@testable import Weather

class ServerManagerMock: ServerManager {

  var mockData:Data? = nil
  var mockError:HTTPError? = nil

  override func fetechDataFromURL(url:URL, requestIdentifier:String = UUID().uuidString, completeionHandler:@escaping ServerResponseHandler) -> Operation  {
    if let mockData = self.mockData {
      completeionHandler(.success(mockData))
    } else if let mockError = self.mockError {
      completeionHandler(.failure(mockError))
    }
    return Operation()
  }
}

class ServerManagerTest: XCTestCase {

  func testSearch_success() {
      let manager = ServerManagerMock()
      let jsonData = Bundle.stubbedDataFromJson(filename: "serachResults")
      manager.mockData = jsonData
      manager.dynamicSearch(city: "London") { (result) in
      switch result {
      case .success(let searchResult):
        let mockResults = try? SearchResult(query: "London", jsonData: jsonData);
        XCTAssert(searchResult.results.count == mockResults?.results.count, "result count should be same")
        XCTAssert(searchResult.results == mockResults?.results, "result  should be same")
        case .failure(let error):
        XCTAssert(false, "failure should not happen \(error)")
      }
    }
  }

  func testSearch_failure_http() {
    let manager = ServerManagerMock()
    manager.mockError = HTTPError.badHTTPStatus(reason: "Unknown", code: 123)
    manager.dynamicSearch(city: "London") { (result) in
    switch result {
    case .success(_):
      XCTAssert(false, "should fail")
    case .failure(let error):
      if let httpError = error as? HTTPError {
        switch httpError {
        case .badHTTPStatus(let reason, let code):
          XCTAssert(code == 123, "error code 123")
          XCTAssert(reason == "Unknown", "error code 123")
        case .url(_),.server(_, _),.genric(_):
          XCTAssert(false, "error should badHTTPStatus")
        }

      }
      else {
        XCTAssert(false, "error should be of type HTTPError \(error)")
      }
    }
  }
  }

    func testSearch_failure_json() {
      let manager = ServerManagerMock()
      let jsonData = "serachResults".data(using: .utf8)!
      manager.mockData = jsonData
      manager.dynamicSearch(city: "London") { (result) in
      switch result {
      case .success(_):
        XCTAssert(false, "should fail")
      case .failure(let error):
        if let httpError = error as? DecodingError {
          switch httpError {
          case .dataCorrupted:
            XCTAssert(true, "dataCorrupted should be thrown")
          default:
            XCTAssert(false, "error should dataCorrupted")
          }

        } else {
          XCTAssert(false, "error should be of type HTTPError")
        }
      }
    }

  }

  func cityToSearch() -> City {
    let citySubData = Bundle.stubbedDataFromJson(filename: "city")
    let decoder = JSONDecoder()
    return try! decoder.decode(City.self, from: citySubData)
  }

  func testWeather_success() {
      let manager = ServerManagerMock()
      let jsonData = Bundle.stubbedDataFromJson(filename: "cityWeather")
      manager.mockData = jsonData
      manager.weather(forCity: cityToSearch()) { (result) in
      switch result {
      case .success(let cityWeather):
        let decoder = JSONDecoder()
        let weather = try! decoder.decode(CityWeatherWrapper.self, from: jsonData)
        XCTAssert(weather.data.currentConditionList.count == cityWeather.currentConditionList.count, "weather.data should not be nil")
        XCTAssert(weather.data.dayWeather.count == cityWeather.dayWeather.count, "weather.data should not be nil")
      case .failure(let error):
        XCTAssert(false, "failure should not happen \(error)")
      }
    }
  }

  func testWeather_failure_http() {
    let manager = ServerManagerMock()
    manager.mockError = HTTPError.badHTTPStatus(reason: "Unknown", code: 123)
    manager.weather(forCity: cityToSearch()) { (result) in
      switch result {
      case .success(_):
        XCTAssert(false, "should fail")
      case .failure(let error):
        if let httpError = error as? HTTPError {
          switch httpError {
          case .badHTTPStatus(let reason, let code):
            XCTAssert(code == 123, "error code 123")
            XCTAssert(reason == "Unknown", "error code 123")
          case .url(_),.server(_, _),.genric(_):
            XCTAssert(false, "error should badHTTPStatus")
          }

        }
        else {
          XCTAssert(false, "error should be of type HTTPError \(error)")
        }
      }
    }
  }

    func testWeather_failure_json() {
      let manager = ServerManagerMock()
      let jsonData = "serachResults".data(using: .utf8)!
      manager.mockData = jsonData
      manager.weather(forCity: cityToSearch()) { (result) in
      switch result {
      case .success(_):
        XCTAssert(false, "should fail")
      case .failure(let error):
        if let httpError = error as? DecodingError {
          switch httpError {
          case .dataCorrupted:
            XCTAssert(true, "dataCorrupted should be thrown")
          default:
            XCTAssert(false, "error should dataCorrupted")
          }

        } else {
          XCTAssert(false, "error should be of type HTTPError")
        }
      }
    }
  }

  func testSerevrManager_cancel_operation() {
    let manager = ServerManager()
    manager.isSuspended = true
    let operation1 = manager.fetechDataFromURL(url: ServerEndPoint.endPoint, requestIdentifier: "Same"){ (result) in}
    let operation2 = manager.fetechDataFromURL(url: ServerEndPoint.endPoint, requestIdentifier: "Same"){ (result) in}
    let operation3 = manager.fetechDataFromURL(url: ServerEndPoint.endPoint, requestIdentifier: "Same-1"){ (result) in}
    XCTAssert(operation1.isCancelled, "isCancelled should be true")
    XCTAssert(!operation2.isCancelled, "isCancelled should be false")
    XCTAssert(!operation3.isCancelled, "isCancelled should be false")
    manager.cancelAllDownloads(identifer: "Same")
    XCTAssert(operation2.isCancelled, "isCancelled should be false")
    XCTAssert(!operation3.isCancelled, "isCancelled should be false")
    manager.cancelAllDownloads(identifer: nil)
    XCTAssert(operation3.isCancelled, "isCancelled should be false")
  }
}

