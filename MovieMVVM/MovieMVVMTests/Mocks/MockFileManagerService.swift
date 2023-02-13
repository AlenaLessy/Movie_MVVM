// MockFileManagerService.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок сервиса сохранения изображений
final class MockFileManagerService: FileManagerServiceProtocol {
    // MARK: - Public Properties

    var isSafeImage = false

    // MARK: - Private Properties

    private var photoData = Data()

    // MARK: - Public Methods

    func saveImageToCache(url: String, data: Data) {
        isSafeImage = true
    }

    func getImageFromCache(url: String) -> Data? {
        photoData
    }
}
