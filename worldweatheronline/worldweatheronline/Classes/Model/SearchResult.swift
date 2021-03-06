//
//  SerachResult.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 10/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation


struct  SearchResult {
  let query:String
  let results:[City]
  init(query:String, jsonData: Data) throws {
    self.query = query;
    let decoder = JSONDecoder()
    let city = try decoder.decode([String: [String: [City]]].self, from: jsonData)
    if let search = city["search_api"], let cityList = search["result"] {
      results = cityList
    } else {
      results = [City]()
    }
  }
}
