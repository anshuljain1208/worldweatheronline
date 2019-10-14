//
//  ViewController.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

struct RecentCitiesControllerStrings {
   static let title = "World Weather"
   static let searchBarPlaceholder = "Search cities"
   static let  messageForEmptySearch = "To search please type atleast 3 characters and press Search."
   static let  messageForEmptyRecents = "You don't have any recents visited cities. Please try searching cities."
   static let  messageForEmptySearchResults = "Unable to found any results for \"%@\". Please try searching something else."
   static let  alertOKActionButtonTitle = "OK"
   static let  alertSearchErrorTitle = "Unable to search"
   static let  alertSearchErrorGenricMessage = "We’re having some unexpected trouble getting this info for you right now."
}

struct RecentCitiesControllerIdentifiers {
  static let searchBarAccessibilityIdentifier = "recentCities_searchBar"
  static let citySearchCell = "CitySearchCell"
}

class RecentCitiesController: UITableViewController {

  var recentCities:[City]  {
    return RecentCities.sharedInstance.list
  }

  let messageLabel = UILabel()
  let tableBackgroundView = UIView()
  var searchResult:SearchResult? = nil
  let searchController = UISearchController(searchResultsController: nil)
  let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
  var searchTerms = ""
  var searchWasCancelled = false

  override func viewDidLoad() {
    self.title = RecentCitiesControllerStrings.title
    super.viewDidLoad()
    activityIndicatorView.color = UIColor.gray
    activityIndicatorView.hidesWhenStopped = true

    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = RecentCitiesControllerStrings.searchBarPlaceholder
    searchController.delegate = self
    searchController.searchBar.delegate = self
    searchController.searchBar.accessibilityIdentifier = RecentCitiesControllerIdentifiers.searchBarAccessibilityIdentifier
    navigationItem.searchController = searchController
    definesPresentationContext = true

    tableView.tableFooterView = UIView()
    NotificationCenter.default.addObserver(self, selector: #selector(RecentCitiesController.didUpdateRecentCities), name: .didUpdateRecentCities, object: nil)
    self.tableView.backgroundView = tableBackgroundView
    tableBackgroundView.addSubview(messageLabel)
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    let views: [String: UIView] = ["view": self.messageLabel]
    let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[view]-16-|", metrics: nil,views: views)
    let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[view]-16-|", metrics: nil, views: views)
    tableBackgroundView.addConstraints(vertical)
    tableBackgroundView.addConstraints(horizontal)
    messageLabel.font = .systemFont(ofSize: UIFont.systemFontSize)
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 0
    messageLabel.textColor = .gray
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func didUpdateRecentCities() {
    DispatchQueue.main.async {
      if self.searchController.isActive == false{
        self.tableView.reloadData()
      }
    }
  }

  //MARK: TableView Data Source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var rows = 0
    if searchController.isActive {
      rows = searchResult?.results.count ?? 0
    } else {
      rows = recentCities.count
    }
    if rows == 0 {
      messageLabel.isHidden = false
      if searchController.isActive {
        if (searchController.searchBar.text?.count ?? 0 < 3) {
          messageLabel.text = RecentCitiesControllerStrings.messageForEmptySearch
        }
      } else {
        messageLabel.text = RecentCitiesControllerStrings.messageForEmptyRecents
      }
    } else {
      messageLabel.isHidden = true
    }
    return rows
  }

  override func numberOfSections(in tableView: UITableView) -> Int  {
    return 1
  }

  func cityAtIndex(_ index: Int) -> City {
    if searchController.isActive {
      return searchResult!.results[index]
    } else {
      return recentCities[index]
    }
  }

  //MARK: TableView Data Delegate
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RecentCitiesControllerIdentifiers.citySearchCell, for: indexPath)
    let city = cityAtIndex(indexPath.row)
    cell.textLabel?.text = city.name
    cell.detailTextLabel?.text = city.country
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let city = cityAtIndex(indexPath.row)
    let controller = CityWeatherController(city: city)
    self.navigationController?.pushViewController(controller, animated: true)
  }

}

extension RecentCitiesController: UISearchControllerDelegate,UISearchBarDelegate {
  func didDismissSearchController(_ searchController: UISearchController) {
    self.tableView.reloadData()
  }

  func didPresentSearchController(_ searchController: UISearchController) {
    self.tableView.reloadData()
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    search()
  }

  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool  {
    return !activityIndicatorView.isAnimating
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    if searchWasCancelled {
      searchWasCancelled = false
      searchBar.text = self.searchTerms
    }
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchWasCancelled = true
    self.searchTerms = searchBar.text ?? ""
  }

  func search(_ animate:Bool = true) {
    guard let text = searchController.searchBar.text, text.count > 2 else {
      return
    }
    if animate {
      startAnimatingActivityViewer()
    }
    ServerManager.shared.dynamicSearch(city: text) { (result) in
      switch result {
      case .success(let searchResult):
        DispatchQueue.main.async {
          if text != searchResult.query {
            return
          }
          self.searchResult = searchResult
          if animate {
            self.stopAnimatingActivityViewer()
            if searchResult.results.count == 0 {
              self.messageLabel.text = String(format:RecentCitiesControllerStrings.messageForEmptySearchResults,searchResult.query)
            }
          }
          self.tableView.reloadData()
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.messageLabel.text = String(format:RecentCitiesControllerStrings.messageForEmptySearchResults,text)
          var message = RecentCitiesControllerStrings.alertSearchErrorGenricMessage
          if let httpError = error as? HTTPError, let errorDescription = httpError.errorDescription   {
            message = errorDescription
            self.messageLabel.text = message
          }
          if animate {
            self.stopAnimatingActivityViewer()
            self.showAlert(message: message, title: RecentCitiesControllerStrings.alertSearchErrorTitle)
          }
        }
      }
    }
  }

  func showAlert(message: String, title: String) {
    let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
    let action = UIAlertAction(title: RecentCitiesControllerStrings.alertOKActionButtonTitle, style: .default) { _ in
    }
    alertController.addAction(action)
    self.present(alertController, animated: true, completion: nil)
  }

  func startAnimatingActivityViewer() {
    tableView.backgroundView = activityIndicatorView
    activityIndicatorView.startAnimating()
  }

  func stopAnimatingActivityViewer() {
    tableView.backgroundView = tableBackgroundView
    activityIndicatorView.stopAnimating()
  }

}


extension RecentCitiesController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    search(false)
  }

  func showAlert() {

  }
}
