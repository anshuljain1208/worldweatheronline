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

    func appending(query key: ServerQueryKey, value: String) -> URL {
      appending(params: [key: value])
    }

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

enum ServerQueryKey: String {
  case apiKey = "key"
  case searchString = "q"
  case maxResultCount = "num_of_results"
  case format = "format"
}

struct ServerQuery {
  //?qry=united%20states&key=3c38a95745f843559ac41436190810&num_of_results=4
  static let worldweatheronlineAPIKey = "3c38a95745f843559ac41436190810"
  static let jsonValue = "json"
  static let sharedQuery:[ServerQueryKey: String] = [.apiKey: ServerQuery.worldweatheronlineAPIKey, .format: jsonValue]
}

struct LocalStorage {
    static var storagePath:String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0]
        return documentsPath + "/recentCities"
    }
    
  static var storageURL: URL {
      return URL.init(fileURLWithPath: LocalStorage.storagePath)
  }
}

extension NSNotification.Name {

}

typealias ServerResponseHandler = (Swift.Result<Data, HTTPError>) -> Void

class ServerManager {
    static let shared = ServerManager()
    private let httpOperationQueue = OperationQueue()

    init(){
    }

    // MARK: - Server Request
    func dynamicSearch(city query:String, completionHandler:@escaping (Swift.Result<SerachResult, Error>) -> Void) {
        let searchURL = ServerEndPoint.searchURL
        let allowed = CharacterSet.urlQueryAllowed
        guard let searchQuery = query.addingPercentEncoding(withAllowedCharacters: allowed) else {
          return
        }
        let params:[ServerQueryKey: String] = [.searchString: searchQuery,
                                               .maxResultCount: "200"]
        let searchURLWithParam = searchURL.appending(params: params)
        fetechJsonDataFromURL(url: searchURLWithParam) { (result) in
          switch result {
          case .success(let jsonData):
            do {
              let searchResult = try SerachResult(query: "serachResults", jsonData: jsonData)
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


    func fetechJsonDataFromURL(url:URL, completeionHandler:@escaping ServerResponseHandler)  {
        let url = url.appending(params: ServerQuery.sharedQuery)
        let operation = HTTPOperation(url: url, session: URLSession.shared, completionHandler: completeionHandler)
        self.httpOperationQueue.addOperation(operation);
    }
}

