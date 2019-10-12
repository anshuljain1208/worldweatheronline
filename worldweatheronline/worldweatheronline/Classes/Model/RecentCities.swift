//
//  RecentCities.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 12/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation

struct LocalStorage {

  static var documentsURL:URL {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[0]
  }

}

extension Notification.Name {
    static let didUpdateRecentCities = Notification.Name("didUpdateRecentCities")
}

class RecentCities {

  static let storageURL = LocalStorage.documentsURL.appendingPathComponent("recentCities")
  var storageURL: URL {
    return RecentCities.storageURL
  }

  static let sharedInstance = RecentCities()
  private(set) var list = [City]()
  init() {
    guard let data = try? Data(contentsOf: storageURL) else {
      return
    }
    let decoder = JSONDecoder()
    guard let cities = try? decoder.decode([City].self, from: data) else {
      return
    }
    list.append(contentsOf: cities)
  }

  private func save() {
    let encode = JSONEncoder()
    guard let data = try? encode.encode(list) else {
      return
    }
    try? data.write(to: storageURL)
  }

  func add(city: City) {
    let index = list.firstIndex { $0 == city}
    if let foundIndex = index {
      list.remove(at: foundIndex)
    }
    list.insert(city, at: 0)
    if list.count > 10 {
      list = Array(list.prefix(10))
    }
    save()
    NotificationCenter.default.post(name: .didUpdateRecentCities, object: nil)
  }

}
