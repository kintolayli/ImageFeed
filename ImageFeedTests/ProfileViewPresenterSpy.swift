//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Ilya Lotnik on 29.07.2024.
//

@testable import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var getProfileImageCalled: Bool = false
    var getProfileDetailsCalled = false
    var showAlertCalled = false
    var view: (any ImageFeed.ProfileViewControllerProtocol)?
    
    func getProfileImage() {
        getProfileImageCalled = true
    }
    
    func getProfileDetails() {
        getProfileDetailsCalled = true
    }
    
    func showAlert() {
        showAlertCalled = true
    }
}
