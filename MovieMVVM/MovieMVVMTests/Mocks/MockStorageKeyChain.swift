// MockStorageKeyChain.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок кейчейн сервиса
final class MockStorageKeyChain: StorageKeyChainProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let bazText = "baz"
    }

    // MARK: - Public Properties

    var safeValue: String?

    // MARK: - Public Methods

    func safeValueToKeyChain(key: KeyFromKeyChainKind, value: String) {
        safeValue = value
    }

    func readValueFromKeyChain(from key: MovieMVVM.KeyFromKeyChainKind) -> String {
        Constants.bazText
    }
}
