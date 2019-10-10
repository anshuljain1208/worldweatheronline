//
//  HTTPOperation.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//


import Foundation


public enum HTTPError: Error {
    case badHTTPStatus(reason: String, code: Int)
    case url(error:URLError)
    case server(reason: String, code: Int)
    case genric(error:Error)

    var code:Int {
        switch (self)  {
        case .badHTTPStatus(_, let httpCode):
            return httpCode
        case .url(let error):
            return error.code.rawValue
        case .server(_, let httpCode):
            return httpCode
        case .genric:
            return 0;
        }
    }
}

extension HTTPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badHTTPStatus(let string, _):
            return string
        case .url(let error):
            return error.localizedDescription
        case .server(let string, _):
            return string
        case .genric(let error):
            return error.localizedDescription
       }
    }
}

class HTTPOperation: Operation {

    fileprivate var _executing = false
    fileprivate var _finished = false
    fileprivate var _cancelled = false;

    var task: URLSessionDataTask?;
    var session: URLSession;
    var data =  Data();
    var identifier = "";

    convenience init(url:URL, completionHandler:@escaping ServerResponseHandler) {
        self.init(request: URLRequest(url: url), session: URLSession.shared, completionHandler:completionHandler)
    }

    convenience init(url:URL, session:URLSession, completionHandler:@escaping ServerResponseHandler) {
        self.init(request: URLRequest(url: url), session: session, completionHandler:completionHandler)
    }

    init(request:URLRequest, session:URLSession, completionHandler:@escaping ServerResponseHandler) {
        self.session = session;
        super.init()
        task = session.dataTask(with:request, completionHandler: { [weak self] (data, response, error) -> Void in
            defer {
                self?.finish()
           }
            if let urlError = error as? URLError {
              completionHandler(.failure( HTTPError.url(error: urlError)))
                return
            }
            else if error != nil{
                completionHandler(.failure( HTTPError.genric(error: error!)))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print(httpResponse)
                let reason = "" //UserMessages.genricServerError
                completionHandler(.failure( HTTPError.badHTTPStatus(reason: reason, code: httpResponse.statusCode)))
                return
            }
            if let responseData = data {
                self?.data = responseData;
              completionHandler(.success(responseData))
            }
        })
    }

    override var isAsynchronous: Bool {
        return true
    }

    override var isExecuting: Bool {
        return _executing
    }

    override var isFinished: Bool {
        return _finished && !_cancelled
    }

    func finish() {
        NetworkIndicator.hide()
        self.willChangeValue(forKey: "isExecuting")
        self.willChangeValue(forKey: "isFinished")
        _executing = false
        _finished = true
        self.didChangeValue(forKey: "isExecuting")
        self.didChangeValue(forKey: "isFinished")
        task = nil
    }

    override func start() {
        if isCancelled {
            self.willChangeValue(forKey: "isFinished")
            _finished = true
            self.didChangeValue(forKey: "isFinished")
            return
        }

        self.willChangeValue(forKey: "isExecuting")
        self.willChangeValue(forKey: "isFinished")

        _executing = true
        _finished = false
        sleep(2)
        self.didChangeValue(forKey: "isExecuting")
        self.didChangeValue(forKey: "isFinished")
        NetworkIndicator.show()
        task?.resume()
    }

    override  func cancel() {
        task?.cancel()
        _cancelled = true
        finish()
    }
}
