// StorageKeyChainProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол хранилища ключей
protocol StorageKeyChainProtocol {
    func safeValueToKeyChain(key: KeyFromKeyChainKind, value: String)
    func readValueFromKeyChain(from key: KeyFromKeyChainKind) -> String
}
