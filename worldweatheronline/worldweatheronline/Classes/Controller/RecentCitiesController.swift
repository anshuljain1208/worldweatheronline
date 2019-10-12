//
//  ViewController.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

class RecentCitiesController: UITableViewController {

  var recentCities:[City]  {
    return RecentCities.sharedInstance.list
  }

  var searchResult:SearchResult? = nil
  let searchController = UISearchController(searchResultsController: nil)
  override func viewDidLoad() {
    self.title = "World Weather"
    super.viewDidLoad()
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search cities"
    searchController.delegate = self
    navigationItem.searchController = searchController
    definesPresentationContext = true

    tableView.tableFooterView = UIView()
    NotificationCenter.default.addObserver(self, selector: #selector(RecentCitiesController.didUpdateRecentCities), name: .didUpdateRecentCities, object: nil)
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

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.isActive {
      return searchResult?.results.count ?? 0
    } else {
      return recentCities.count
    }
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

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CitySearchCell", for: indexPath)
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

extension RecentCitiesController: UISearchControllerDelegate {
  func didDismissSearchController(_ searchController: UISearchController) {
    self.tableView.reloadData()
  }

  func didPresentSearchController(_ searchController: UISearchController) {
    self.tableView.reloadData()
  }
}

extension RecentCitiesController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text, text.count > 2 else {
      return
    }
    ServerManager.shared.dynamicSearch(city: text) { (result) in
      switch result {
      case .success(let searchResult):
        print("updateSearchResults success \(searchResult)");
        DispatchQueue.main.async {
          self.searchResult = searchResult
          self.tableView.reloadData()
        }
        case .failure(let error):
          print("updateSearchResults error \(error)");
      }
    }
  }
}
