// ImageService.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation
/// Сервис для получения фото
final class ImageService: ImageServiceProtocol {
    // MARK: - Private Properties

    private var imageProxyService: ImageServiceProtocol

    // MARK: - Initializers

    init(imageProxyService: ImageServiceProtocol) {
        self.imageProxyService = imageProxyService
    }

    func fetchPhoto(byUrl url: String, completion: ((Data?) -> ())?) {
        imageProxyService.fetchPhoto(byUrl: url, completion: completion)
    }
}
