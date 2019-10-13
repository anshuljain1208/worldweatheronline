//
//  ImageManager.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 12/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

extension URL {
   var key: String {
    return absoluteString
  }
}

class Cache: NSObject, NSCacheDelegate {

  private(set) var cache =  NSCache<NSString, UIImage> ()
  private(set) var dictionary =  [String: UIImage] ()
  let cacheQueue = DispatchQueue(label: "com.worldweatheronline.cache")

  override init() {
    super.init()
    cache.delegate = self
  }

  subscript(key: String) -> UIImage? {
      get {
        return object(forKey: key)
      }
      set {
          if let value: UIImage = newValue {
            set(object:value, forKey: key)
          } else {
            removeValue(forKey: key)
          }
      }
  }

    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
      if let image = obj as? UIImage {
        cacheQueue.async {
          for (key,value) in self.dictionary {
            if image === value {
              self.dictionary[key] = nil
              return
            }
          }
        }
      }
    }
    func object(forKey key: String) -> UIImage? {
      cacheQueue.sync {
        return dictionary[key]
      }
    }

    func set(object obj: UIImage, forKey key: String) {
       cacheQueue.sync {
         dictionary[key] = obj
        cache.setObject(obj, forKey: key as NSString)
       }
    }

    func removeValue(forKey key: String) {
      cache.removeObject(forKey: key as NSString)
    }


    func removeAll() {
      cache.removeAllObjects()
    }

  deinit {
    removeAll()
  }
}

class ImageManager {
  static let shared = ImageManager()
  private(set) var cache =  Cache()

  typealias ImageCacheHandler = (Swift.Result<UIImage, HTTPError>) -> Void

  func add(image: UIImage, forKey key: String) {
    cache[key] = image
  }

  func image(forKey key: String) -> UIImage? {
    return cache[key]
  }

  func removeImage(forKey key: String) {
    return cache[key] = nil
  }

  subscript(key: String) -> UIImage? {
      get {
        return image(forKey: key)
      }
      set {
          if let value: UIImage = newValue {
            add(image:value, forKey: key)
          } else {
            removeImage(forKey: key)
          }
      }
  }

  private let downloadQueue = OperationQueue()

  var isSuspended:Bool {
    set {
      downloadQueue.isSuspended = newValue
    }
    get {
      return downloadQueue.isSuspended
    }
  }

  func cancelAllDownloads(identifer:String?) {
    if let identifier = identifer {
      downloadQueue.cancelAll(withIdentifier: identifier)
    } else {
      downloadQueue.cancelAllOperations()
    }
  }

  @discardableResult
  func fetechImageFromURL(url:URL,completeionHandler:@escaping ServerResponseHandler) -> Operation {
    let operation = HTTPOperation(url: url, session: URLSession.shared, identifier:url.key as String, completionHandler: completeionHandler)
      self.downloadQueue.addOperation(operation);
      return operation
  }

  @discardableResult
  func fetechImage(forURL url:URL, completeionHandler:@escaping ImageCacheHandler) -> Operation? {
    let key = url.key
    if let image = image(forKey: key) {
      completeionHandler(.success(image))
      return nil
    }
    return fetechImageFromURL(url: url) { (result) in
      switch result {
      case .success(let data):
        if let image = UIImage(data: data) {
          self.add(image: image, forKey: key)
          completeionHandler(.success(image))
        } else {
          completeionHandler(.failure(HTTPError.server(reason: "Image data corrupted", code: 400)))
        }
       case .failure(let error):
        completeionHandler(.failure(error))
      }
    }
  }
}
