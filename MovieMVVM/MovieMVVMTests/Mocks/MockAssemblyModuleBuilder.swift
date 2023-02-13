// MockAssemblyModuleBuilder.swift
// Copyright © KarpovaAV. All rights reserved.

@testable import MovieMVVM
import UIKit

/// Мок сборщика модулей
final class MockAssemblyModuleBuilder: AssemblyBuilderProtocol {
    // MARK: - Public Methods

    func makeMoviesModule() -> UIViewController {
        let dataService = makeDataService()
        let imageService = makeImageService()
        let storageKeyChain = MockStorageKeyChain()
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
        ImageProxyService(fileManagerService: MockFileManagerService(), imageApiService: MockImageAPIService())
    }

    func makeDataService() -> DataServiceProtocol {
        DataService(networkService: MockNetworkService(), coreDataService: MockCoreDataService())
    }

    func makeImageService() -> ImageServiceProtocol {
        ImageService(imageProxyService: ImageProxyService(
            fileManagerService: MockFileManagerService(),
            imageApiService: MockImageAPIService()
        ))
    }
}
