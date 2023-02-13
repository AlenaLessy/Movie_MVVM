// StorageKeyChainTests.swift
// Copyright © KarpovaAV. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тест кейчейн сервиса
final class StorageKeyChainTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let bazText = "baz"
    }

    // MARK: - Private Properties

    private var storageKeyChain: StorageKeyChainProtocol?

    // MARK: - Public Methods

    override func setUp() {
        super.setUp()
        storageKeyChain = StorageKeyChain()
    }

    override func tearDown() {
        super.tearDown()
        storageKeyChain = nil
    }

    func testStorageKeyChain() {
        storageKeyChain?.safeValueToKeyChain(key: .apiKey, value: Constants.bazText)
        let receivedValue = storageKeyChain?.readValueFromKeyChain(from: .apiKey)
        guard let receivedValue else { return }
        XCTAssertNotNil(receivedValue)
        XCTAssertEqual(Constants.bazText, receivedValue)
    }
}
