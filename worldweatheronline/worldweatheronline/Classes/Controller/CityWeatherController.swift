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
  static let cityWeatherGenricCell = "cityWeatherGenricCell"
}

struct CityWeatherControllerStrings {
  static let humidityValue = " %@%%"
  static let humidityTitle = "Humidity:"
  static let currentTemperatureValue = " %@"
  static let feelTemperatureValue = " %@"
  static let currentTemperatureTitle = "Current:"
  static let feelTemperatureTitle = "Feels like:"

  static let windSpeedValue = " %@"
  static let windDirectionValue = " %@"
  static let windSpeedTitle = "Speed:"
  static let windDirectionTitle = "Direction:"

  static let cloudCoverValue = " %@%%"
  static let visibilityValue = " %@"
  static let cloudCoverTitle = "Cloud cover:"
  static let visibilityTitle = "Visibility:"

  static let pressureValue = " %@"
  static let precipitationValue = " %@ mm"
  static let precipitationTitle = "Precipitation:"
  static let pressureTitle = "Pressure:"

  static let weatherHeader = "Weather"
  static let temperatureHeader = "Temperature"
  static let windHeader = "Wind"
  static let visibilityHeader = "Visibility"


  static let  alertCancelActionButtonTitle = "Cancel"
  static let  alertTryAgainActionButtonTitle = "Try Again"
  static let  alertGenricMessage = "We’re having some unexpected trouble getting this info for you right now."
  static let  alertSearchErrorTitle = "Unable to get weather report for %@"
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
    tableView.register(UINib(nibName: "CityWeatherTableCell", bundle: nil), forCellReuseIdentifier: CityWeatherControllerIdentifiers.cityWeatherCell)
    tableView.register(UINib(nibName: "CityWeatherGenricTableCell", bundle: nil), forCellReuseIdentifier: CityWeatherControllerIdentifiers.cityWeatherGenricCell)
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
        case .failure(let error):
          print("downloadWeatherUpdate error \(error)");
        DispatchQueue.main.async {
          var message = CityWeatherControllerStrings.alertGenricMessage
          if let httpError = error as? HTTPError, let errorDescription = httpError.errorDescription   {
            message = errorDescription
          }
          self.showAlert(message: message, title: String(format: CityWeatherControllerStrings.alertSearchErrorTitle,self.city.name))
        }
      }
    }
  }

  func showAlert(message: String, title: String) {
    let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
    let action = UIAlertAction(title: CityWeatherControllerStrings.alertCancelActionButtonTitle, style: .default) { _ in
      self.navigationController?.popViewController(animated: true)
    }
    let tryAgain = UIAlertAction(title: CityWeatherControllerStrings.alertTryAgainActionButtonTitle, style: .default) { _ in
      self.downloadWeatherUpdate()
    }

    alertController.addAction(action)
    alertController.addAction(tryAgain)

    self.present(alertController, animated: true, completion: nil)
  }

  func didDownloadWeatherReport() {
    guard let _ =  self.weatherReport?.currentConditionList.first else {
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
      case 1...2:
        rows = 1
      case 3:
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherControllerIdentifiers.cityWeatherCell, for: indexPath) as? CityWeatherTableCell else {
      return UITableViewCell()
    }
    if let currentCondition =  self.weatherReport?.currentConditionList.first {
      cell.titleLabel?.text = currentCondition.weatherDescription
      if let humidity = currentCondition.humidity {
        cell.subtitleLabel.subtitle = String(format: CityWeatherControllerStrings.humidityValue,String(humidity))
        cell.subtitleLabel.title = String(format: CityWeatherControllerStrings.humidityTitle)
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherControllerIdentifiers.cityWeatherGenricCell, for: indexPath) as? CityWeatherGenricTableCell else {
      return UITableViewCell()
    }
    cell.titleLabel.title = String(format: CityWeatherControllerStrings.currentTemperatureTitle)
    cell.titleLabel.subtitle = String(format: CityWeatherControllerStrings.currentTemperatureValue,self.weatherReport?.currentConditionList.first?.temperature ?? "")

    cell.subtitleLabel.title = String(format: CityWeatherControllerStrings.feelTemperatureTitle)
    cell.subtitleLabel.subtitle = String(format: CityWeatherControllerStrings.feelTemperatureValue,self.weatherReport?.currentConditionList.first?.temperatureFeeling ?? "")

    return cell
  }

  func windCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherControllerIdentifiers.cityWeatherGenricCell, for: indexPath) as? CityWeatherGenricTableCell else {
      return UITableViewCell()
    }

    cell.titleLabel.subtitle = String(format: CityWeatherControllerStrings.windSpeedValue,self.weatherReport?.currentConditionList.first?.windSpeed ?? "")
    cell.titleLabel.title = String(format: CityWeatherControllerStrings.windSpeedTitle)

    cell.subtitleLabel.subtitle = String(format: CityWeatherControllerStrings.windDirectionValue,self.weatherReport?.currentConditionList.first?.windDirection16Point ?? "")
    cell.subtitleLabel.title = String(format: CityWeatherControllerStrings.windDirectionTitle)
    return cell
  }

  func visiblityCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherControllerIdentifiers.cityWeatherGenricCell, for: indexPath) as? CityWeatherGenricTableCell else {
      return UITableViewCell()
    }
    switch indexPath.row {
    case 0:
      cell.titleLabel.subtitle = String(format: CityWeatherControllerStrings.visibilityValue,self.weatherReport?.currentConditionList.first?.visibility ?? "")
      cell.titleLabel.title = String(format: CityWeatherControllerStrings.visibilityTitle)

      cell.subtitleLabel.subtitle = String(format: CityWeatherControllerStrings.cloudCoverValue,String(self.weatherReport?.currentConditionList.first?.cloudCover ?? 0) )
      cell.subtitleLabel.title = String(format: CityWeatherControllerStrings.cloudCoverTitle)
      return cell
    case 1:
      cell.titleLabel.subtitle = String(format: CityWeatherControllerStrings.pressureValue,self.weatherReport?.currentConditionList.first?.pressure ?? "")
      cell.titleLabel.title = String(format: CityWeatherControllerStrings.pressureTitle)

      cell.subtitleLabel.subtitle = String(format: CityWeatherControllerStrings.precipitationValue,String(self.weatherReport?.currentConditionList.first?.precipitationInMM ?? 0) )
      cell.subtitleLabel.title = String(format: CityWeatherControllerStrings.precipitationTitle)
      return cell
    default:
        return cell
    }

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
