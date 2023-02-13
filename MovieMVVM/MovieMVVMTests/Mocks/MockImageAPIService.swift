// MockImageAPIService.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок сервиса загрузки изображений из интернета
final class MockImageAPIService: ImageApiServiceProtocol {
    // MARK: - Private Properties

    private var photoData = Data()

    // MARK: - Public Methods

    func fetchPhoto(byUrl url: String, completion: ((Data?) -> ())?) {
        completion?(photoData)
    }
}
