//
//  Bundle+StubData.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 10/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation
import XCTest

extension Bundle {
  static func stubbedDataFromJson(filename: String) -> Data {
    return stubbedData(filename: filename, withExtension: "json")
  }

  static func stubbedData(filename: String, withExtension fileExtension: String) -> Data {
    guard  let stubURL = Bundle(for: CityTests.self).url(forResource: filename, withExtension: fileExtension) else {
      XCTAssert(false, "\(filename).\(fileExtension) file not found")
      fatalError()
    }
    guard let stubData = try? Data(contentsOf: stubURL) else {
      XCTAssert(false, "\(filename).\(fileExtension) file cannot be read")
      fatalError()
    }
    return stubData
  }

}
