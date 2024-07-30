//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Ilya Lotnik on 29.07.2024.
//

@testable import ImageFeed
import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    private let email = ""
    private let password = ""
    private let profileName = ""
    private let login = ""
    private let bio = ""

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UITEST"]
        app.launch()
    }
    
    func testAuth() throws {
        
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
        authButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(email)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        
        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        cell.swipeUp()
        
        sleep(3)
        cell.buttons["likeButton"].tap()
        sleep(2)
        cell.buttons["likeButton"].tap()
        sleep(2)
        
        cell.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        sleep(1)
        image.pinch(withScale: 3, velocity: 1)
        sleep(1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backwardButton = app.buttons["backwardButton"]
        backwardButton.tap()
    }
    
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        
        XCTAssertTrue(app.staticTexts[profileName].exists)
        XCTAssertTrue(app.staticTexts[login].exists)
        XCTAssertTrue(app.staticTexts[bio].exists)
        
        let logoutButton = app.buttons["logoutButton"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 5))
        logoutButton.tap()
        
        sleep(2)
        
        app.alerts["Alert"].scrollViews.otherElements.buttons["Да"].tap()
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
        XCTAssertTrue(authButton.exists)
    }
}
