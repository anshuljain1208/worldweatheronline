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

    func testExample() {
      let app = XCUIApplication()
      let tableView = app.tables["recentCities_tableView"].firstMatch
      XCTAssert(tableView.cells.count == 0)
      tableView.firstMatch.swipeDown()
      let searchField = app.searchFields["Search cities"]
      searchField.tap()
      searchField.typeText("London")
      sleep(5)
      XCTAssert(tableView.cells.count != 0)
      let firstCell = tableView.cells.element(boundBy: 0)
      firstCell.tap()
      sleep(1)
      app.navigationBars.buttons.element(boundBy: 0).tap()
      sleep(1)

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

  func test1() {

    let app = XCUIApplication()
    app/*@START_MENU_TOKEN@*/.tables["recentCities_tableView"]/*[[".tables[\"Empty list\"]",".tables[\"recentCities_tableView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
    app.searchFields["Search cities"].tap()

  }

}
