// AssemblyModuleBuilder.swift
// Copyright © KarpovaAV. All rights reserved.

import UIKit

/// Протокол сборки модулей
protocol AssemblyBuilderProtocol {
    func makeMoviesModule() -> UIViewController
    func makeDetailsMovieModule(id: Int) -> UIViewController
    func makeImageProxyService() -> ImageServiceProtocol
    func makeDataService() -> DataServiceProtocol
    func makeImageService() -> ImageServiceProtocol
}

/// Составление модулей
final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    // MARK: - Public Methods

    func makeMoviesModule() -> UIViewController {
        let dataService = makeDataService()
        let imageService = makeImageService()
        let storageKeyChain = StorageKeyChain()
        let moviesViewModel = MoviesViewModel(
            dataService: dataService,
            imageService: imageService,
            storageKeyChain: storageKeyChain
        )
        let view = MoviesViewController(moviesViewModel: moviesViewModel)
        return view
    }

    func makeDetailsMovieModule(id: Int) -> UIViewController {
        let dataService = makeDataService()
        let imageService = makeImageService()
        let detailsMovieViewModel = DetailsMovieViewModel(
            id: id,
            dataService: dataService,
            imageService: imageService
        )
        let view = DetailsMovieViewController(detailsMovieViewModel: detailsMovieViewModel)
        return view
    }

    func makeImageProxyService() -> ImageServiceProtocol {
        let fileManagerService = FileManagerService()
        let imageApiService = ImageApiService()
        let imageProxyService = ImageProxyService(
            fileManagerService: fileManagerService,
            imageApiService: imageApiService
        )
        return imageProxyService
    }

    func makeDataService() -> DataServiceProtocol {
        let networkService = NetworkService()
        let coreDataService = CoreDataService()
        let dataProvider = DataService(networkService: networkService, coreDataService: coreDataService)
        return dataProvider
    }

    func makeImageService() -> ImageServiceProtocol {
        let imageProxyService = makeImageProxyService()
        let imageService = ImageService(imageProxyService: imageProxyService)
        return imageService
    }
}
