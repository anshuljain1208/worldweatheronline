//
//  CityWeatherController.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 11/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

struct CityWeatherControllerIdentifiers {
  static let cityWeatherCell = "cityWeatherCell"
  static let cityWeatherHeaderCell = "cityWeatherHeaderCell"
  static let cityWeatherTemperatureCell = "cityWeatherTemperatureCell"
}

struct CityWeatherControllerStrings {
  static let humidityValue = "Humidity: %@%%"
  static let currentTemperatureValue = "Current: %@"
  static let feelTemperatureValue = "Feels like: %@"
  static let windSpeedValue = "Speed: %@"
  static let windDirectionValue = "Direction: %@"
  static let cloudCoverValue = "Cloud cover: %@%%"
  static let visibility = "Visibility: %@"

  static let weatherHeader = "Weather"
  static let temperatureHeader = "Temperature"
  static let windHeader = "Wind"
  static let visibilityHeader = "Visibility"
}


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
    tableView.register(UINib(nibName: "CityWeatherTableCellTableViewCell", bundle: nil), forCellReuseIdentifier: CityWeatherControllerIdentifiers.cityWeatherCell)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: CityWeatherControllerIdentifiers.cityWeatherTemperatureCell)
    tableView.register(CityWeatherTableHeaderView.self, forHeaderFooterViewReuseIdentifier: CityWeatherControllerIdentifiers.cityWeatherHeaderCell)
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
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
        DispatchQueue.main.async {
          self.weatherReport = weatherReport
          self.didDownloadWeatherReport()
        }
         print("searchResult \(weatherReport)")
        case .failure(let error):
          print("downloadWeatherUpdate error \(error)");
      }
    }
  }

  func didDownloadWeatherReport() {
    guard let currentCondition =  self.weatherReport?.currentConditionList.first else {
      return
    }
    tableView.reloadData()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var rows = 0
    if let _ =  self.weatherReport?.currentConditionList.first {
      switch section {
      case 0:
        rows = 1
      case 1...3:
        rows = 2
      default:
        rows = 0
      }
    }
    return rows
  }

  override func numberOfSections(in tableView: UITableView) -> Int  {
    if let _ =  self.weatherReport?.currentConditionList.first {
      return 4
    }
    return 0
  }

  //MARK: TableView Data Delegate
  func weatherCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherControllerIdentifiers.cityWeatherCell, for: indexPath) as? CityWeatherTableCellTableViewCell else {
      return UITableViewCell()
    }
    if let currentCondition =  self.weatherReport?.currentConditionList.first {
      cell.titleLabel?.text = currentCondition.weatherDescription
      if let humidity = currentCondition.humidity {
        cell.subtitleLabel.text = String(format: CityWeatherControllerStrings.humidityValue,String(humidity))
      } else {
        cell.subtitleLabel?.text = ""
      }
      cell.iconView.placeholderImage = UIImage(named: "noImage")
      if let weatherIconUrl = currentCondition.weatherIconUrl {
        cell.iconView.setImage(imageURL: weatherIconUrl.updateSchemeToHttps())
      }
    }
    return cell
  }

  func temperatureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherControllerIdentifiers.cityWeatherTemperatureCell, for: indexPath)
    switch indexPath.row {
    case 0:
      cell.textLabel?.text = String(format: CityWeatherControllerStrings.currentTemperatureValue,self.weatherReport?.currentConditionList.first?.temperature ?? "")
    case 1:
      cell.textLabel?.text = String(format: CityWeatherControllerStrings.feelTemperatureValue,self.weatherReport?.currentConditionList.first?.temperatureFeeling ?? "")
    default:
      cell.textLabel?.text = ""
    }
    return cell
  }

  func windCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherControllerIdentifiers.cityWeatherTemperatureCell, for: indexPath)
    switch indexPath.row {
    case 0:
      cell.textLabel?.text = String(format: CityWeatherControllerStrings.windSpeedValue,self.weatherReport?.currentConditionList.first?.windSpeed ?? "")
    case 1:
      cell.textLabel?.text = String(format: CityWeatherControllerStrings.windDirectionValue,self.weatherReport?.currentConditionList.first?.windDirection16Point ?? "")
    default:
      cell.textLabel?.text = ""
    }
    return cell
  }

  func visiblityCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherControllerIdentifiers.cityWeatherTemperatureCell, for: indexPath)
    switch indexPath.row {
    case 0:
      cell.textLabel?.text = String(format: CityWeatherControllerStrings.visibility,self.weatherReport?.currentConditionList.first?.visibility ?? "")
    case 1:
      cell.textLabel?.text = String(format: CityWeatherControllerStrings.cloudCoverValue,String(self.weatherReport?.currentConditionList.first?.cloudCover ?? 0) )
    default:
      cell.textLabel?.text = ""
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      return weatherCell(tableView, cellForRowAt: indexPath)
    case 1:
      return windCell(tableView, cellForRowAt: indexPath)
    case 2:
      return temperatureCell(tableView, cellForRowAt: indexPath)
    case 3:
      return visiblityCell(tableView, cellForRowAt: indexPath)

    default:
      return UITableViewCell()
    }
  }


  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CityWeatherControllerIdentifiers.cityWeatherHeaderCell)  else {
      return nil
    }
    switch section {
    case 0:
      cell.textLabel?.text = CityWeatherControllerStrings.weatherHeader
    case 1:
      cell.textLabel?.text = CityWeatherControllerStrings.windHeader
    case 2:
      cell.textLabel?.text = CityWeatherControllerStrings.temperatureHeader
    case 3:
      cell.textLabel?.text = CityWeatherControllerStrings.visibilityHeader

    default:
      cell.textLabel?.text = ""
    }

    return cell
  }
}
