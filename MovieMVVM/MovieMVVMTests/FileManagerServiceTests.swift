// FileManagerServiceTests.swift
// Copyright © KarpovaAV. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тест сервиса сохранения изображений
final class FileManagerServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let barText = "bar"
        static let intOneNumber = 1
    }

    // MARK: - Private Properties

    private let safeData = Data(capacity: Constants.intOneNumber)
    private var fileManagerService: FileManagerServiceProtocol?

    // MARK: - Public Methods

    override func setUp() {
        super.setUp()
        fileManagerService = FileManagerService()
    }

    override func tearDown() {
        super.tearDown()
        fileManagerService = nil
    }

    func testLoadImage() {
        fileManagerService?.saveImageToCache(url: Constants.barText, data: safeData)
        let data = fileManagerService?.getImageFromCache(url: Constants.barText)
        XCTAssertNotNil(data)
        XCTAssertEqual(data, safeData)
    }
}
