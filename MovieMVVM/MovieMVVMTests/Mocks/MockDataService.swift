// MockDataService.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок сервиса по получению данных
final class MockDataService: DataServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let idNumber = 315_162
    }

    // MARK: - Public Properties

    var movieResponse: MovieResponse?
    var detailsMovie: MovieDetails?
    var recommendationMovies: RecommendationMovieResponse?

    // MARK: - Private Properties

    private let mockNetworkService = MockNetworkService()
    private let mockCoreDataService = MockCoreDataService()

    // MARK: - Public Methods

    func fetchMovies(
        kind: MovieMVVM.MovieKind,
        page: Int,
        apiKey: String,
        completion: ((Result<MovieMVVM.MovieResponse, MovieMVVM.NetworkError>) -> ())?
    ) {
        if let coreDataResults = mockCoreDataService.fetchMovies(movieType: kind),
           !coreDataResults.movies.isEmpty,
           coreDataResults.page == page
        //  swiftlint: disable all
        {
            // swiftlint: enable all
            completion?(.success(coreDataResults))
            movieResponse = coreDataResults
        } else {
            mockNetworkService.fetchMovies(kind: kind, page: page, apiKey: apiKey) { result in
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

    func fetchDetailsMovie(
        id: Int,
        apiKey: String,
        completion: ((Result<MovieMVVM.MovieDetails, MovieMVVM.NetworkError>) -> ())?
    ) {
        if let coreDataResults = mockCoreDataService.fetchMovieDetails(id: id),
           coreDataResults.id == id
        // swiftlint: disable all
        {
            // swiftlint: enable all
            completion?(.success(coreDataResults))
            detailsMovie = coreDataResults
        } else {
            mockNetworkService.fetchDetailsMovie(id: id, apiKey: apiKey) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(movie):
                    completion?(.success(movie))
                    self.mockCoreDataService.safeMovieDetails(movie: movie)
                    self.detailsMovie = movie
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
        id: Int,
        apiKey: String,
        completion: ((Result<MovieMVVM.RecommendationMovieResponse, MovieMVVM.NetworkError>) -> ())?
    ) {
        if let coreDataResults = mockCoreDataService.fetchRecommendationMovies(id: id),
           !coreDataResults.movies.isEmpty
        // swiftlint: disable all
        {
            // swiftlint: enable all
            completion?(.success(coreDataResults))
            recommendationMovies = coreDataResults
        } else {
            mockNetworkService.fetchRecommendationsMovies(id: id, apiKey: apiKey) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(recommendationMovies):
                    completion?(.success(recommendationMovies))
                    self.mockCoreDataService.safeRecommendationMovies(
                        id: Constants.idNumber,
                        recommendationMovieResponse: recommendationMovies
                    )
                    self.recommendationMovies = recommendationMovies
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
}
