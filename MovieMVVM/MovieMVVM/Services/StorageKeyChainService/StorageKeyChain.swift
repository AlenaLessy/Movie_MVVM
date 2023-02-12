// StorageKeyChain.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation
import KeychainSwift

/// Хранилище ключей
final class StorageKeyChain: StorageKeyChainProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
        static let errorText = "Не удалось записать данные в KeyChain"
    }

    // MARK: - Private Properties

    private let keyChain = KeychainSwift()

    // MARK: - Public Methods

    func safeValueToKeyChain(key: KeyFromKeyChainKind, value: String) {
        guard keyChain.set(value, forKey: key.description)
        else {
            print(Constants.errorText)
            return
        }
    }

    func readValueFromKeyChain(from key: KeyFromKeyChainKind) -> String {
        guard let value = keyChain.get(key.description) else {
            return Constants.emptyString
        }
        return value
    }
}
