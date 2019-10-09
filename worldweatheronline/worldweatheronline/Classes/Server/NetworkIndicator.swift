//
//  NetworkIndicator.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation
import UIKit

class NetworkIndicator {
  static let shared = NetworkIndicator()
  var activityCount:Int = 0 {
    didSet {
      if activityCount > 0 {
        showNetworkIndicator()
      }
      else {
        activityCount = 0
        hideNetworkIndicator()
      }
    }
  }

  private func hideNetworkIndicator() {
    if UIApplication.shared.isNetworkActivityIndicatorVisible {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

  }

  private func showNetworkIndicator() {
    DispatchQueue.main.async {
      if !UIApplication.shared.isNetworkActivityIndicatorVisible {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }
    }
  }

  public class func hide() {
    DispatchQueue.main.async {
      shared.activityCount -= 1
    }
  }

  public class func show() {
    DispatchQueue.main.async {
      shared.activityCount += 1
    }
  }


}
