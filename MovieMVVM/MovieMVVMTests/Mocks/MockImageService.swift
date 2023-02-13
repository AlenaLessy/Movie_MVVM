// MockImageService.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок сервиса изображений
final class MockImageService: ImageServiceProtocol {
    // MARK: - Private Properties

    private var photoData = Data()

    // MARK: - Public Methods

    func fetchPhoto(byUrl url: String, completion: ((Data?) -> ())?) {
        completion?(photoData)
    }
}
