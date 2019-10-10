//
//  ViewController.swift
//  worldweatheronline
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

  override func viewDidLoad() {
    self.title = "World Weather"
    super.viewDidLoad()
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search cities"
    navigationItem.searchController = searchController
    definesPresentationContext = true

    // Do any additional setup after loading the view.
  }


}

extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let text = searchController.searchBar.text, text.count > 2 {
      ServerManager.shared.dynamicSearch(city: text) { (result) in
        switch result {
        case .success(let searchResult):
          print("updateSearchResults success \(searchResult)");
          case .failure(let error):
            print("updateSearchResults error \(error)");
        }
      }
    }
  }
}
