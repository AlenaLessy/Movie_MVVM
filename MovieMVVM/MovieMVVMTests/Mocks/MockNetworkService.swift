// MockNetworkService.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation
@testable import MovieMVVM

/// Мок нетворк  сервиса
final class MockNetworkService: NetworkServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let intNumberOne = 1
        static let bazText = "baz"
        static let fooText = "foo"
        static let barText = "bar"
        static let doubleNumberOne = 1.0
    }

    // MARK: - Private Properties

    private var movieResponse = MovieResponse(
        movies: [Movie(
            id: Constants.intNumberOne,
            posterPath: Constants.fooText,
            overview: Constants.fooText,
            releaseDate: Constants.fooText,
            title: Constants.fooText,
            rating: Constants.doubleNumberOne
        )],
        page: Constants.intNumberOne,
        totalPages: Constants.intNumberOne
    )
    private var detailsMovie = MovieDetails(
        posterPath: Constants.bazText,
        overview: Constants.bazText,
        title: Constants.bazText,
        rating: Constants.doubleNumberOne,
        tagline: Constants.bazText,
        releaseDate: Constants.bazText,
        runtime: Constants.intNumberOne,
        productionCountries: [ProductionCountries(name: Constants.bazText)],
        id: Constants.intNumberOne
    )
    private var recommendationMovieResponse =
        RecommendationMovieResponse(movies: [RecommendationMovie(posterPath: Constants.barText)])

    // MARK: - Initializers

    init() {}

    convenience init(movieResponse: MovieResponse) {
        self.init()
        self.movieResponse = movieResponse
    }

    convenience init(detailsMovie: MovieDetails) {
        self.init()
        self.detailsMovie = detailsMovie
    }

    convenience init(recommendationMovieResponse: RecommendationMovieResponse) {
        self.init()
        self.recommendationMovieResponse = recommendationMovieResponse
    }

    // MARK: - Public Methods

    func fetchMovies(
        kind: MovieKind,
        page: Int,
        apiKey: String,
        completion: ((Result<MovieResponse, NetworkError>) -> ())?
    ) {
        completion?(.success(movieResponse))
    }

    func fetchDetailsMovie(id: Int, apiKey: String, completion: ((Result<MovieDetails, NetworkError>) -> ())?) {
        completion?(.success(detailsMovie))
    }

    func fetchRecommendationsMovies(
        id: Int, apiKey: String,
        completion: ((Result<RecommendationMovieResponse, NetworkError>) -> ())?
    ) {
        completion?(.success(recommendationMovieResponse))
    }
}
