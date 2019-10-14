//
//  worldweatheronlineUITests.swift
//  worldweatheronlineUITests
//
//  Created by Anshul Jain on 8/10/19.
//  Copyright © 2019 Anshul Jain. All rights reserved.
//

import XCTest

class worldweatheronlineUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
      let app = XCUIApplication()
      app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func recentCityTableView() -> XCUIElement {
      let app = XCUIApplication()
      return app.tables["recentCities_tableView"].firstMatch
    }

    func recentCityTableViewCell(atIndex: Int) -> XCUIElement {
      let tableView = recentCityTableView()
      return tableView.cells.element(boundBy: atIndex)
    }

    func recentCitySearchField() -> XCUIElement {
      let app = XCUIApplication()
      return app.searchFields["Search cities"]
    }

    func search_recentCity(text: String) {
      let tableView = recentCityTableView()
      tableView.swipeDown()
      let searchField = recentCitySearchField()
      searchField.tap()
      //Wait for keyboard to comeup
      sleep(1)
      if let string = searchField.value as? String, string.count > 0, string != "Search cities"   {
        searchField.buttons["Clear text"].tap()
      }
      searchField.typeText(text)
      sleep(3)
    }

    func cancelSearch() {
      let app = XCUIApplication()
      print("buttons \(app.buttons)")
      app.buttons["Cancel"].tap()
      sleep(1)
    }

    func goBack() {
      let app = XCUIApplication()
      app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func goBackToRecents() {
      let app = XCUIApplication()
      goBack()
//      let resultView = app.tables["recentCities_tableView"]
//      let viewExists = resultView.waitForExistence(timeout: 2)
//      XCTAssert(viewExists)
      sleep(1)
    }

     func waitForWeatherToLoad() {
        sleep(3)
//      let app = XCUIApplication()
//      let resultView = app.tables["weather_tableView"]
//      let viewExists = resultView.waitForExistence(timeout: 2)
//      XCTAssert(viewExists)
//      let cellsCountPredicate = NSPredicate(format: "cells.count > 0")
//      self.expectation(for: cellsCountPredicate, evaluatedWith: resultView, handler: nil)
//      self.waitForExpectations(timeout: 120) { (error) in
//          XCTAssertTrue(error == nil);
//      }
     }

    func testExample() {
      var tableView = recentCityTableView()
      //Initial launch should have no cities
      XCTAssert(tableView.cells.count == 0,"Please uninstall the app from the test device and try again")
      //Wait for Search
      search_recentCity(text: "London")
      XCTAssert(tableView.cells.count != 0)
      //Select First Cell
      var cell = recentCityTableViewCell(atIndex: 0)
      let cityName = cell.staticTexts["recentCities_cell_city_title"].label
      cell.tap()
      //Wait for Weather Report to download
      waitForWeatherToLoad()
      goBackToRecents()
      cancelSearch()
      //Back to recent cities list
      XCTAssert(tableView.cells.count == 1)
      cell = recentCityTableViewCell(atIndex: 0)
      XCTAssert(cell.staticTexts["recentCities_cell_city_title"].label == cityName)
      cell.tap()
      waitForWeatherToLoad()
      goBackToRecents()

      search_recentCity(text: "New York")
      XCTAssert(tableView.cells.count != 0)
      cell = recentCityTableViewCell(atIndex: 0)
      let cityName1 = cell.staticTexts["recentCities_cell_city_title"].label
      cell.tap()
      waitForWeatherToLoad()
      goBackToRecents()
      cancelSearch()
      XCTAssert(tableView.cells.count == 2)
      cell = recentCityTableViewCell(atIndex: 0)
      XCTAssert(cell.staticTexts["recentCities_cell_city_title"].label == cityName1)

      cell = recentCityTableViewCell(atIndex: 1)
      cell.tap()
      waitForWeatherToLoad()
      goBackToRecents()
      cell = recentCityTableViewCell(atIndex: 0)
      XCTAssert(cell.staticTexts["recentCities_cell_city_title"].label == cityName)
      XCTAssert(tableView.cells.count == 2)
      //Search Again

      //Terminate and launch again
      let app = XCUIApplication()
      app.terminate()
      app.launch()
      tableView = recentCityTableView()
      XCTAssert(tableView.cells.count == 2)
      cell = recentCityTableViewCell(atIndex: 0)
      XCTAssert(cell.staticTexts["recentCities_cell_city_title"].label == cityName)
      cell = recentCityTableViewCell(atIndex: 1)
      XCTAssert(cell.staticTexts["recentCities_cell_city_title"].label == cityName1)

      var cityList = [cityName,cityName1]
      let searchList = ["Washington","Agra","Singapore","Hongkong","Paris","Seabrook","Las Vegas","Jakarta","Canberra","Melbourne"]
      for searchText in searchList {
        search_recentCity(text: searchText)
        XCTAssert(tableView.cells.count != 0)
        let cell = recentCityTableViewCell(atIndex: 0)
        let cityName = cell.staticTexts["recentCities_cell_city_title"].label
        cityList.insert(cityName, at: 0)
        print("cityList insert \(cityName)")
        cell.tap()
        waitForWeatherToLoad()
        goBackToRecents()
        cancelSearch()
      }
      print("cityList \(cityList)")
      XCTAssert(tableView.cells.count == 10)
      for index in 0...9 {
        let cell = recentCityTableViewCell(atIndex: index)
        print("cell title:\(cell.staticTexts["recentCities_cell_city_title"].label)")
        print("cell title:\(cell.staticTexts["recentCities_cell_city_title"].label)")
        XCTAssert(cell.staticTexts["recentCities_cell_city_title"].label == cityList[index])
      }
    }


}
