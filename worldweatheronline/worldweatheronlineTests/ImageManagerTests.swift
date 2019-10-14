//
//  ImageManagerTests.swift
//  worldweatheronlineTests
//
//  Created by Anshul Jain on 13/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation
import XCTest
@testable import Weather

class ImageManagerMock: ImageManager {

  var mockData:[Data] = [Data]()
  var mockError:HTTPError? = nil

  //wsymbol_0004_black_low_cloud, wsymbol_0009_light_rain_showers
  @discardableResult
  override func fetechImageFromURL(url:URL,completeionHandler:@escaping ServerResponseHandler) -> Operation   {
    if let mockData = self.mockData.first {
      self.mockData.remove(at: 0)
      completeionHandler(.success(mockData))
    } else if let mockError = self.mockError {
      completeionHandler(.failure(mockError))
    } else {
      XCTAssert(false,"should not reach here")
    }
    return Operation()
  }
}

class ImageManagerTests: XCTestCase {

  var imageManager = ImageManagerMock()
  override func setUp() {
    imageManager = ImageManagerMock()
  }

  func mockURL() -> URL {
    return URL(string: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png")!
  }

  func mockURL1() -> URL {
    return URL(string: "http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_0009_black_low_cloud.png")!
  }

  func testDownload_image() {
    let data = Bundle.stubbedData(filename: "wsymbol_0004_black_low_cloud", withExtension: "png")
    let data1 = Bundle.stubbedData(filename: "wsymbol_0009_light_rain_showers", withExtension: "png")
    imageManager.mockData.append(data)
    imageManager.mockData.append(data1)
    imageManager.fetechImage(forURL: mockURL()) { (result) in
      switch result {
      case .success(let image):
        XCTAssert(image == self.imageManager.image(forKey: self.mockURL().key),"should not reach here")
      case .failure(_):
        XCTAssert(false,"should not reach here")
      }
    }
    imageManager.fetechImage(forURL: mockURL1()) { (result) in
      switch result {
      case .success(let image):
        XCTAssert(image == self.imageManager.image(forKey: self.mockURL1().key),"should not reach here")
      case .failure(_):
        XCTAssert(false,"should not reach here")
      }
    }
    imageManager[mockURL().key] = nil
    XCTAssert(imageManager[mockURL().key] == nil,"should not reach here")

  }

  func testDownload_image_failure() {
    let mockError = HTTPError.server(reason: "Server down", code: 100)
    imageManager.mockError = mockError
    imageManager.fetechImage(forURL: mockURL()) { (result) in
      switch result {
      case .success(_):
        XCTAssert(false,"should not reach here")
      case .failure(let error):
        switch error {
        case .server(let reason, let code):
          XCTAssert(code == 100, "error code 123")
          XCTAssert(reason == "Server down", "Server down should be the reason")
        case .url(_),.badHTTPStatus(_, _),.genric(_):
          XCTAssert(false, "error should badHTTPStatus")
        }
      }
    }
  }

  func testDownload_image_failure_wrong_data() {
    let data = Bundle.stubbedDataFromJson(filename: "serachResults")
    imageManager.mockData.append(data)
    imageManager.fetechImage(forURL: mockURL()) { (result) in
      switch result {
      case .success(_):
        XCTAssert(false,"should not reach here")
      case .failure(let error):
        switch error {
        case .server(_, let code):
          XCTAssert(code == 400, "error code 400")
        case .url(_),.badHTTPStatus(_, _),.genric(_):
          XCTAssert(false, "error should badHTTPStatus")
        }
      }
    }
  }

  func testDownload_image_cache() {
    let data = Bundle.stubbedData(filename: "wsymbol_0004_black_low_cloud", withExtension: "png")
    imageManager.mockData.append(data)
    var imageCache:UIImage? = nil
    imageManager.fetechImage(forURL: mockURL()) { (result) in
      switch result {
      case .success(let image):
        print("image \(image)")
        imageCache = image
        XCTAssert(image === self.imageManager.image(forKey: self.mockURL().key),"should not reach here")
      case .failure(_):
        XCTAssert(false,"should not reach here")
      }
    }
    imageManager.fetechImage(forURL: mockURL()) { (result) in
      switch result {
      case .success(let image):
        XCTAssert(image == imageCache,"should not reach here")
      case .failure(_):
        XCTAssert(false,"should not reach here")
      }
    }
    imageManager.cache.removeAll()
    XCTAssert(imageManager[mockURL().key] == nil,"should not reach here")
  }

  deinit {
    print(waitForExpectations)
  }

  func testImageManager_cancel_operation() {
    let manager = ImageManager()
    manager.isSuspended = true
    XCTAssert(manager.isSuspended, "isSuspended should be true")
    let operation1 = manager.fetechImage(forURL: mockURL()){ (result) in} as! HTTPOperation
    let operation2 = manager.fetechImage(forURL: mockURL1()){ (result) in} as! HTTPOperation
    XCTAssert(!operation2.isCancelled, "isCancelled should be false")
    XCTAssert(!operation1.isCancelled, "isCancelled should be false")
    manager.cancelAllDownloads(identifer: mockURL().key)
    XCTAssert(operation1.isCancelled, "isCancelled should be false")
    XCTAssert(!operation2.isCancelled, "isCancelled should be false")
    manager.cancelAllDownloads(identifer: nil)
    XCTAssert(operation2.isCancelled, "isCancelled should be false")
  }

}
