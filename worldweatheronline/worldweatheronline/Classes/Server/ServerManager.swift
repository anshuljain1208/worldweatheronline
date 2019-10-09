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

    func appending(query key: String, value: String) -> URL {
      appending(query: [key: value])

    }

  func appending(query items:[String: String]) -> URL {
      guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
      var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
      for (key, value) in items {
        let queryItem = URLQueryItem(name: key, value: value)
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
    static let searchPath = "v1/weather.ashx"

    static var searchURL: URL {
      let finalURLString = ServerEndPoint.endPoint.appendingPathComponent(searchPath)
      return finalURLString
    }

  static var dynamicSearchURL: URL {
    let endPoint = URL(string: "https://www.worldweatheronline.com/v2/search.ashx")!
    return endPoint
  }

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

public typealias ServerResponseHandler = (Data?, Error?) -> Void
public typealias FetchResponseHandler = (Bool, Error?) -> Void

class ServerManager {
    static let shared = ServerManager()
    private let httpOperationQueue = OperationQueue()

    init(){
    }


    // MARK: - Server Request
    func dynamicSearch(city query:String, completionHandler:@escaping FetchResponseHandler) {
        let searchURL = ServerEndPoint.dynamicSearchURL
        let allowed = CharacterSet.urlQueryAllowed
        guard let searchQuery = query.addingPercentEncoding(withAllowedCharacters: allowed) else {
          return
        }
        let searchURLWithParam = searchURL.appending(query: "qry", value:searchQuery)
        fetechJsonDataFromURL(url: searchURLWithParam) { (data, error) in
            if let jsonData = data {
                let decoder = JSONDecoder()
    //                _  = try decoder.decode([Comment].self, from: jsonData)
                completionHandler(true,nil)

            } else {
                completionHandler(false,error)
            }
        }
      }


    func fetechJsonDataFromURL(url:URL, completeionHandler:@escaping ServerResponseHandler)  {
        let operation = HTTPOperation(url: url, session: URLSession.shared, completionHandler: {
            (data, error) in
            if let jsonData = data {
               completeionHandler(jsonData,nil)
            }
            else if error != nil {
                completeionHandler(nil,error)
            }
            else {
                fatalError("This should never be reached issues with HTTPOperation")
            }
        })
        self.httpOperationQueue.addOperation(operation);
    }

}

