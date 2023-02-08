// ImageApiServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол для скачивания фото из интернета
protocol ImageApiServiceProtocol {
    func fetchPhoto(byUrl url: String, completion: ((Data?) -> ())?)
}

/// Сервис для скачивания фото
final class ImageApiService: ImageApiServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let baseImageIRLString = "https://image.tmdb.org/t/p/w500"
    }

    // MARK: - Public Methods

    func fetchPhoto(byUrl url: String, completion: ((Data?) -> ())?) {
        let imageUrlString = "\(Constants.baseImageIRLString)\(url)"
        guard let imageUrl = URL(string: imageUrlString) else { return }
        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            guard let data
            else { return }
            DispatchQueue.main.async {
                completion?(data)
            }
        }
        .resume()
    }
}
