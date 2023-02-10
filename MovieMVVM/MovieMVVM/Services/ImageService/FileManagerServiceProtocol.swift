// FileManagerServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол кеширования фото
protocol FileManagerServiceProtocol {
    func saveImageToCache(url: String, data: Data)
    func getImageFromCache(url: String) -> Data?
}
