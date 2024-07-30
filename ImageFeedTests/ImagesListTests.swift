//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Ilya Lotnik on 29.07.2024.
//

@testable import ImageFeed
import XCTest


final class ImagesListTests: XCTestCase {
    func testViewControllerCallsConfigCell() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        let cell = ImagesListCell()
        let tableView = viewController.tableView
        guard let indexPath = viewController.tableView.indexPath(for: cell) else { return }
        
        //when
        _ = viewController.tableView(tableView, cellForRowAt: indexPath)
        
        //then
        XCTAssertTrue(presenter.configCellCalled)
    }
}

