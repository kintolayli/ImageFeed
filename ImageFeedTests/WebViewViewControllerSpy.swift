//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Ilya Lotnik on 29.07.2024.
//
@testable import ImageFeed
import Foundation


final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadCalled: Bool = false
    var presenter: ImageFeed.WebViewPresenterProtocol?

    func load(request: URLRequest) {
        loadCalled = true
    }

    func setProgressValue(_ newValue: Float) {}

    func setProgressHidden(_ isHidden: Bool) {}
}
