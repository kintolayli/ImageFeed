//
//  ProfileViewTests.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 29.07.2024.
//

@testable import ImageFeed
import XCTest


final class ProfileViewTests: XCTestCase {
    
    func testProfileViewControllerCallsGetProfileImage() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.getProfileImageCalled)
    }
    
    func testProfileViewControllerCallsGetProfileDetails() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.getProfileDetailsCalled)
    }
}
