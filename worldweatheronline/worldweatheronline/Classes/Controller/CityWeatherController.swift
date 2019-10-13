//
//  CityWeatherController.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 11/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

class CityWeatherController: UITableViewController {

  let city:City
  let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
  var weatherReport: CityWeather? = nil
  init(city: City) {
    self.city = city
    super.init(style: .plain)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    self.title = city.name
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    RecentCities.sharedInstance.add(city: city)
    downloadWeatherUpdate()
    // Do any additional setup after loading the view.
  }

  func downloadWeatherUpdate() {
    tableView.backgroundView = activityIndicatorView
    activityIndicatorView.color = UIColor.gray
    activityIndicatorView.hidesWhenStopped = true
    activityIndicatorView.startAnimating()
    ServerManager.shared.weather(forCity: city) { (result) in
      DispatchQueue.main.async {
        self.activityIndicatorView.stopAnimating()
      }
      switch result {
      case .success(let weatherReport):
          self.weatherReport = weatherReport
         print("searchResult \(weatherReport)")
        case .failure(let error):
          print("downloadWeatherUpdate error \(error)");
      }
    }
  }

  func didDownloadWeatherReport() {

  }
}
