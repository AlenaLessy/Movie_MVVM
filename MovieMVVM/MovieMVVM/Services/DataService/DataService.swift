// DataService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Выбор получения данных
final class DataService: DataServiceProtocol {
    // MARK: Private Properties

    private let networkService: NetworkServiceProtocol
    private let coreDataService: CoreDataServiceProtocol

    // MARK: - Initializers

    init(networkService: NetworkServiceProtocol, coreDataService: CoreDataServiceProtocol) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }

    // MARK: - Public Methods

    func fetchMovies(
        kind: MovieKind,
        page: Int,
        apiKey: String,
        completion: ((Result<MovieResponse, NetworkError>) -> ())?
    ) {
        if let coreDataResults = coreDataService.fetchMovies(movieType: kind),
           !coreDataResults.movies.isEmpty,
           coreDataResults.page == page
        // swiftlint: disable all
        {
            // swiftlint: enable all
            completion?(.success(coreDataResults))
        } else {
            fetchApiMovie(kind: kind, page: page, apiKey: apiKey) { movieResponse in
                completion?(.success(movieResponse))
            }
        }
    }

    func fetchDetailsMovie(id: Int, apiKey: String, completion: ((Result<MovieDetails, NetworkError>) -> ())?) {
        if let coreDataResults = coreDataService.fetchMovieDetails(id: id),
           coreDataResults.id == id
        // swiftlint: disable all
        {
            // swiftlint: enable all
            completion?(.success(coreDataResults))
        } else {
            fetchApiDetailsMovie(id: id, apiKey: apiKey) { movie in
                completion?(.success(movie))
            }
        }
    }

    func fetchRecommendationsMovies(
        id: Int, apiKey: String,
        completion: ((Result<RecommendationMovieResponse, NetworkError>) -> ())?
    ) {
        if let coreDataResults = coreDataService.fetchRecommendationMovies(id: id),
           !coreDataResults.movies.isEmpty
        // swiftlint: disable all
        {
            // swiftlint: enable all
            completion?(.success(coreDataResults))
        } else {
            fetchApiRecommendationMovies(id: id, apiKey: apiKey) { movies in
                completion?(.success(movies))
            }
        }
    }

    // MARK: - Private Methods

    private func fetchApiRecommendationMovies(
        id: Int,
        apiKey: String,
        completion: ((RecommendationMovieResponse) -> ())?
    ) {
        networkService.fetchRecommendationsMovies(id: id, apiKey: apiKey) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                completion?(response)
                self.coreDataService.safeRecommendationMovies(id: id, recommendationMovieResponse: response)
            case .failure(.unknown):
                print(NetworkError.unknown.description)
            case .failure(.decodingFailure):
                print(NetworkError.decodingFailure.description)
            case .failure(.urlFailure):
                print(NetworkError.urlFailure.description)
            }
        }
    }

    private func fetchApiDetailsMovie(id: Int, apiKey: String, completion: ((MovieDetails) -> ())?) {
        networkService.fetchDetailsMovie(id: id, apiKey: apiKey) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                completion?(response)
                self.coreDataService.safeMovieDetails(movie: response)
            case .failure(.unknown):
                print(NetworkError.unknown.description)
            case .failure(.decodingFailure):
                print(NetworkError.decodingFailure.description)
            case .failure(.urlFailure):
                print(NetworkError.urlFailure.description)
            }
        }
    }

    private func fetchApiMovie(kind: MovieKind, page: Int, apiKey: String, completion: ((MovieResponse) -> ())?) {
        networkService.fetchMovies(kind: kind, page: page, apiKey: apiKey) { [weak self] result in
            switch result {
            case let .success(response):
                self?.coreDataService.safeMovies(movieType: kind, movieResponse: response)
                completion?(response)
            case .failure(.unknown):
                print(NetworkError.unknown.description)
            case .failure(.decodingFailure):
                print(NetworkError.decodingFailure.description)
            case .failure(.urlFailure):
                print(NetworkError.urlFailure.description)
            }
        }
    }
}
