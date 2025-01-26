//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Ilya Lotnik on 29.07.2024.
//
@testable import ImageFeed
import Foundation


final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImageFeed.WebViewViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {}

    func code(from url: URL?) -> String? { return nil }
}
