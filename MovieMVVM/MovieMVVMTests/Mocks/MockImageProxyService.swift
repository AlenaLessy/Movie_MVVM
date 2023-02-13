// MockImageProxyService.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок проски сервиса изображений
final class MockImageProxyService: ImageServiceProtocol {
    // MARK: - Private Properties

    private var imagesMap: [String: Data] = [:]
    private var fileManagerService = MockFileManagerService()
    private var imageApiService = MockImageAPIService()

    // MARK: - Public Methods

    func fetchPhoto(byUrl url: String, completion: ((Data?) -> ())?) {
        if let photo = imagesMap[url] {
            completion?(photo)
        } else if let photo = fileManagerService.getImageFromCache(url: url) {
            DispatchQueue.main.async {
                self.imagesMap[url] = photo
            }
            completion?(photo)
        } else {
            imageApiService.fetchPhoto(byUrl: url) { [weak self] data in
                guard let data,
                      let self
                else { return }
                DispatchQueue.main.async {
                    self.imagesMap[url] = data
                }
                self.fileManagerService.saveImageToCache(url: url, data: data)
                completion?(data)
            }
        }
    }
}
