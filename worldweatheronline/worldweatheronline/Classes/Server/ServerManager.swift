//
//  ServerManager.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation
import CoreData

extension URL {

  func appending(params items:[ServerQueryKey: String]) -> URL {
      guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
      var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
      for (key, value) in items {
        let queryItem = URLQueryItem(name: key.rawValue, value: value)
        queryItems.append(queryItem)
      }
      urlComponents.queryItems = queryItems
      // Returns the url from new url components
      return urlComponents.url!
  }

  func updateSchemeToHttps() -> URL {
    guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
    if urlComponents.scheme == "http" {
      urlComponents.scheme = "https" 
    }
    // Returns the url from new url components
    return urlComponents.url!
  }

}

struct ServerEndPoint {
  //?qry=united%20states&key=3c38a95745f843559ac41436190810&num_of_results=4
    static let endPoint = URL(string: "https://api.worldweatheronline.com/premium/")!
    static let searchPath = "v1/search.ashx"
    static let weatherPath = "v1/weather.ashx"
    static var searchURL: URL {
      let finalURLString = ServerEndPoint.endPoint.appendingPathComponent(searchPath)
      return finalURLString
    }
    static var weatherURL: URL {
      let finalURLString = ServerEndPoint.endPoint.appendingPathComponent(weatherPath)
      return finalURLString
    }
}

struct ServerQueryValue {
  static let numOfDays = "1"
  static let forcast = "yes"
  static let currentCondition = "yes"
  static let monthlyCondition = "no"
  static let location = "no"
  static let comments = "no"
  static let dateFormat = "unix"
  static let tp = "6"

}
enum ServerQueryKey: String {
  case apiKey = "key"
  case searchString = "q"
  case format = "format"

  //Search Query
  case maxResultCount = "num_of_results"

  //Weather Query
  case numOfDays = "num_of_days"
  case forcast = "fx"
  case currentCondition = "cc"
  case monthlyCondition = "mca"
  case location = "includelocation"
  case comments = "show_comments"
  case dateFormat = "date_format"
  case tp = "tp"
}

struct ServerQuery {
  //?qry=united%20states&key=3c38a95745f843559ac41436190810&num_of_results=4
//  static let worldweatheronlineAPIKey = "3c38a95745f843559ac41436190810" //gmail
  static let worldweatheronlineAPIKey = "946fd7ee02794555ad774010191410" //icloud
  static let jsonValue = "json"
  static let sharedQuery:[ServerQueryKey: String] = [.apiKey: ServerQuery.worldweatheronlineAPIKey, .format: jsonValue]
  static let weatherParams:[ServerQueryKey: String] = [.dateFormat: ServerQueryValue.dateFormat,
                                                      .comments: ServerQueryValue.comments,
                                                      .numOfDays: ServerQueryValue.numOfDays,
                                                      .forcast: ServerQueryValue.forcast,
                                                      .currentCondition: ServerQueryValue.currentCondition,
                                                      .monthlyCondition: ServerQueryValue.monthlyCondition,
                                                      .location: ServerQueryValue.location,
                                                      .tp: ServerQueryValue.tp]
}


typealias ServerResponseHandler = (Swift.Result<Data, HTTPError>) -> Void

class ServerManager {
    static let shared = ServerManager()
    private let httpOperationQueue = OperationQueue()

  var isSuspended:Bool {
    set {
      httpOperationQueue.isSuspended = newValue
    }
    get {
      return httpOperationQueue.isSuspended
    }
  }

  func cancelAllDownloads(identifer:String?) {
    if let identifier = identifer {
      httpOperationQueue.cancelAll(withIdentifier: identifier)
    } else {
      httpOperationQueue.cancelAllOperations()
    }
  }

    init(){
    }

    // MARK: - Server Request
  func weather(forCity city:City, completionHandler:@escaping (Swift.Result<CityWeather, Error>) -> Void) {
      let searchURL = ServerEndPoint.weatherURL
      let allowed = CharacterSet.urlQueryAllowed
      guard let searchQuery = city.name.addingPercentEncoding(withAllowedCharacters: allowed) else {
        return
      }
//      q=New&
      var params:[ServerQueryKey: String] = ServerQuery.weatherParams
      params[.searchString] = searchQuery
      let searchURLWithParam = searchURL.appending(params: params)
      fetechDataFromURL(url: searchURLWithParam, requestIdentifier:"dynamicSearch") { (result) in
        switch result {
        case .success(let jsonData):
          do {
            let city = try JSONDecoder().decode(CityWeatherWrapper.self, from: jsonData)
            print("city \(city)")
            completionHandler(.success(city.data))
          } catch {
            completionHandler(.failure(error))
          }
        case .failure(let error):
          completionHandler(.failure(error))
      }
    }
  }

    func dynamicSearch(city query:String, completionHandler:@escaping (Swift.Result<SearchResult, Error>) -> Void) {
        let searchURL = ServerEndPoint.searchURL
        let allowed = CharacterSet.urlQueryAllowed
        guard let searchQuery = query.addingPercentEncoding(withAllowedCharacters: allowed) else {
          return
        }
        let params:[ServerQueryKey: String] = [.searchString: searchQuery,
                                               .maxResultCount: "200"]
        let searchURLWithParam = searchURL.appending(params: params)
      fetechDataFromURL(url: searchURLWithParam, requestIdentifier:"dynamicSearch") { (result) in
          switch result {
          case .success(let jsonData):
            do {
              let searchResult = try SearchResult(query: query, jsonData: jsonData)
              print("searchResult \(searchResult)")
              completionHandler(.success(searchResult))
            } catch {
              completionHandler(.failure(error))
            }
          case .failure(let error):
            completionHandler(.failure(error))
        }
      }
    }

    @discardableResult
    func fetechDataFromURL(url:URL, requestIdentifier:String = UUID().uuidString, completeionHandler:@escaping ServerResponseHandler) -> Operation {
        self.httpOperationQueue.cancelAll(withIdentifier: requestIdentifier)
        let url = url.appending(params: ServerQuery.sharedQuery)
        let operation = HTTPOperation(url: url, session: URLSession.shared, identifier:requestIdentifier, completionHandler: completeionHandler)
        self.httpOperationQueue.addOperation(operation);
        return operation
    }
}

extension OperationQueue {
  func operations(withIdentifier identifier: String) -> [HTTPOperation]{
    var result = [HTTPOperation]()
    for operation in self.operations {
      if let httpOperation = operation as? HTTPOperation, httpOperation.identifier == identifier {
        result.append(httpOperation)
      }
    }
    return result;
  }

  func cancelAll(withIdentifier identifier: String) {
    let httOperations = operations(withIdentifier: identifier)
    for operation in httOperations {
      operation.cancel()
    }
  }
}
