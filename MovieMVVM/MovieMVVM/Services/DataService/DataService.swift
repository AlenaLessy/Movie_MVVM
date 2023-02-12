// DataService.swift
// Copyright © KarpovaAV. All rights reserved.

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
            fetchApiMovie(kind: kind, page: page, apiKey: apiKey) { result in
                switch result {
                case let .success(movieResponse):
                    completion?(.success(movieResponse))
                case .failure(.urlFailure):
                    completion?(.failure(.urlFailure))
                case .failure(.decodingFailure):
                    completion?(.failure(.decodingFailure))
                case .failure(.unknown):
                    completion?(.failure(.unknown))
                }
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
            fetchApiDetailsMovie(id: id, apiKey: apiKey) { result in
                switch result {
                case let .success(movie):
                    completion?(.success(movie))
                case .failure(.urlFailure):
                    completion?(.failure(.urlFailure))
                case .failure(.decodingFailure):
                    completion?(.failure(.decodingFailure))
                case .failure(.unknown):
                    completion?(.failure(.unknown))
                }
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
            fetchRecommendationsMovies(id: id, apiKey: apiKey) { result in
                switch result {
                case let .success(movies):
                    completion?(.success(movies))
                case .failure(.urlFailure):
                    completion?(.failure(.urlFailure))
                case .failure(.decodingFailure):
                    completion?(.failure(.decodingFailure))
                case .failure(.unknown):
                    completion?(.failure(.unknown))
                }
            }
        }
    }

    // MARK: - Private Methods

    private func fetchApiRecommendationMovies(
        id: Int,
        apiKey: String,
        completion: ((Result<RecommendationMovieResponse, NetworkError>) -> ())?
    ) {
        networkService.fetchRecommendationsMovies(id: id, apiKey: apiKey) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                completion?(.success(response))
                self.coreDataService.safeRecommendationMovies(id: id, recommendationMovieResponse: response)
            case .failure(.unknown):
                completion?(.failure(.unknown))
            case .failure(.decodingFailure):
                completion?(.failure(.decodingFailure))
            case .failure(.urlFailure):
                completion?(.failure(.urlFailure))
            }
        }
    }

    private func fetchApiDetailsMovie(
        id: Int,
        apiKey: String,
        completion: ((Result<MovieDetails, NetworkError>) -> ())?
    ) {
        networkService.fetchDetailsMovie(id: id, apiKey: apiKey) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                completion?(.success(response))
                self.coreDataService.safeMovieDetails(movie: response)
            case .failure(.unknown):
                completion?(.failure(.unknown))
            case .failure(.decodingFailure):
                completion?(.failure(.decodingFailure))
            case .failure(.urlFailure):
                completion?(.failure(.urlFailure))
            }
        }
    }

    private func fetchApiMovie(
        kind: MovieKind,
        page: Int,
        apiKey: String,
        completion: ((Result<MovieResponse, NetworkError>) -> ())?
    ) {
        networkService.fetchMovies(kind: kind, page: page, apiKey: apiKey) { [weak self] result in
            switch result {
            case let .success(response):
                self?.coreDataService.safeMovies(movieType: kind, movieResponse: response)
                completion?(.success(response))
            case .failure(.unknown):
                completion?(.failure(.unknown))
            case .failure(.decodingFailure):
                completion?(.failure(.decodingFailure))
            case .failure(.urlFailure):
                completion?(.failure(.urlFailure))
            }
        }
    }
}
