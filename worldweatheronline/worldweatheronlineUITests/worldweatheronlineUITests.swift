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

    func search_cancel() {
      let app = XCUIApplication()
      app.navigationBars.buttons["Cancel"].tap()
      sleep(1)
    }

    func goBack() {
      let app = XCUIApplication()
      app.navigationBars.buttons.element(boundBy: 0).tap()
      sleep(1)
    }

    func testExample() {
      var tableView = recentCityTableView()
      //Initial launch should have no cities
      XCTAssert(tableView.cells.count == 0)
      //Wait for Search
      search_recentCity(text: "London")
      XCTAssert(tableView.cells.count != 0)
      //Select First Cell
      let firstCell = recentCityTableViewCell(atIndex: 0)
      let cityName = firstCell.staticTexts["recentCities_cell_city_title"].label
      firstCell.tap()
      //Wait for Weather Report to download
      sleep(3)
      goBack()
      search_cancel()
      //Back to recent cities list
      XCTAssert(tableView.cells.count == 1)
      let firstRecentCityCell = recentCityTableViewCell(atIndex: 0)
      XCTAssert(firstRecentCityCell.staticTexts["recentCities_cell_city_title"].label == cityName)
      firstRecentCityCell.tap()
      goBack()

      search_recentCity(text: "New York")
      XCTAssert(tableView.cells.count != 0)
      let firstCell1 = recentCityTableViewCell(atIndex: 0)
      let cityName1 = firstCell1.staticTexts["recentCities_cell_city_title"].label
      firstCell1.tap()
      sleep(3)
      goBack()
      search_cancel()
      XCTAssert(tableView.cells.count == 2)
      var firstRecentCityCell1 = recentCityTableViewCell(atIndex: 0)
      XCTAssert(firstRecentCityCell1.staticTexts["recentCities_cell_city_title"].label == cityName1)

      var secondCell = recentCityTableViewCell(atIndex: 1)
      secondCell.tap()
      sleep(3)
      goBack()
      firstRecentCityCell1 = recentCityTableViewCell(atIndex: 0)
      XCTAssert(firstRecentCityCell1.staticTexts["recentCities_cell_city_title"].label == cityName)
      XCTAssert(tableView.cells.count == 2)
      //Search Again

      //Terminate and launch again
      let app = XCUIApplication()
      app.terminate()
      app.launch()
      tableView = recentCityTableView()
      XCTAssert(tableView.cells.count == 2)
      firstRecentCityCell1 = recentCityTableViewCell(atIndex: 0)
      XCTAssert(firstRecentCityCell1.staticTexts["recentCities_cell_city_title"].label == cityName)
      secondCell = recentCityTableViewCell(atIndex: 1)
      XCTAssert(secondCell.staticTexts["recentCities_cell_city_title"].label == cityName1)
    }

    func test1() {

      let app = XCUIApplication()
      app/*@START_MENU_TOKEN@*/.tables["recentCities_tableView"]/*[[".tables[\"Empty list\"]",".tables[\"recentCities_tableView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
      app.searchFields["Search cities"].tap()

    }

}
