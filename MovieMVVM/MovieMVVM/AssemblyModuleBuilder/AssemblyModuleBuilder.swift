// AssemblyModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол сборки модулей
protocol AssemblyBuilderProtocol {
    func makeMoviesModule() -> UIViewController
    func makeDetailsMovieModule(id: Int) -> UIViewController
    func makeImageService() -> ImageServiceProtocol
    func makeDataService() -> DataServiceProtocol
}

/// Составление модулей
final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    // MARK: - Public Methods

    func makeMoviesModule() -> UIViewController {
        let view = MoviesViewController()
        let dataService = makeDataService()
        let imageService = makeImageService()
        let storageKeyChain = StorageKeyChain()
        let moviesViewModel = MoviesViewModel(
            dataService: dataService,
            imageService: imageService,
            storageKeyChain: storageKeyChain
        )
        view.moviesViewModel = moviesViewModel
        return view
    }

    func makeDetailsMovieModule(id: Int) -> UIViewController {
        let view = DetailsMovieViewController()
        let dataService = makeDataService()
        let imageService = makeImageService()
        let detailsMovieViewModel = DetailsMovieViewModel(
            id: id,
            dataService: dataService,
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

    func makeDataService() -> DataServiceProtocol {
        let networkService = NetworkService()
        let coreDataService = CoreDataService()
        let dataProvider = DataService(networkService: networkService, coreDataService: coreDataService)
        return dataProvider
    }
}
