// StorageKeyChainProtocol.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation

/// Протокол хранилища ключей
protocol StorageKeyChainProtocol {
    func safeValueToKeyChain(key: KeyFromKeyChainKind, value: String)
    func readValueFromKeyChain(from key: KeyFromKeyChainKind) -> String
}
