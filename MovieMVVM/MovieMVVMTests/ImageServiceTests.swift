// ImageServiceTests.swift
// Copyright © KarpovaAV. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тест сервиса изображений
final class ImageServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let fooText = "foo"
    }

    // MARK: - Private Properties

    private let imageProxyService = MockImageProxyService()
    private var imageService: ImageServiceProtocol?

    // MARK: - Public Methods

    override func setUp() {
        super.setUp()
        imageService = ImageService(imageProxyService: imageProxyService)
    }

    override func tearDown() {
        super.tearDown()
        imageService = nil
    }

    func testFetchPhoto() {
        imageService?.fetchPhoto(byUrl: Constants.fooText, completion: { data in
            XCTAssertNotNil(data)
        })
    }
}
