// AssemblyModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол сборки модулей
protocol AssemblyBuilderProtocol {
    func makeMoviesModule() -> UIViewController
    func makeDetailsMovieModule(id: Int) -> UIViewController
    func makeImageService() -> ImageServiceProtocol
}

/// Составление модулей
final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    // MARK: - Public Methods

    func makeMoviesModule() -> UIViewController {
        let view = MoviesViewController()
        let networkService = NetworkService()
        let imageService = makeImageService()
        let moviesViewModel = MoviesViewModel(
            networkService: networkService,
            imageService: imageService
        )
        view.moviesViewModel = moviesViewModel
        return view
    }

    func makeDetailsMovieModule(id: Int) -> UIViewController {
        let view = DetailsMovieViewController()
        let networkService = NetworkService()
        let imageService = makeImageService()
        let detailsMovieViewModel = DetailsMovieViewModel(
            id: id,
            networkService: networkService,
            imageService: imageService
        )
        view.detailsMovieViewModel = detailsMovieViewModel
        return view
    }

    func makeImageService() -> ImageServiceProtocol {
        let fileManagerService = FileManagerService()
        let imageApiService = ImageApiService()
        let imageService = ImageService(fileManagerService: fileManagerService, imageApiService: imageApiService)
        return imageService
    }
}
