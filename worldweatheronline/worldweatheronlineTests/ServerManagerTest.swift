//
//  ServerManagerTest.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 12/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation
import XCTest
@testable import worldweatheronline

class ServerManagerMock: ServerManager {

  var mockData:Data? = nil
  var mockError:HTTPError? = nil

  override func fetechJsonDataFromURL(url:URL, requestIdentifier:String = UUID().uuidString,completeionHandler:@escaping ServerResponseHandler)  {
    if let mockData = self.mockData {
      completeionHandler(.success(mockData))
    } else if let mockError = self.mockError {
      completeionHandler(.failure(mockError))
    }
  }
}

class ServerManagerTest: XCTestCase {

  
}
