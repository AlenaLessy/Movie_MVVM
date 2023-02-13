// MockCoreDataService.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation

@testable import MovieMVVM

/// Мок кор дата сервиса
final class MockCoreDataService: CoreDataServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let intNumberOne = 1
        static let fooText = "foo"
        static let doubleNumberTwo = 2.0
    }

    // MARK: - Public Properties

    var isSafeMovies = false
    var isSafeMovieDetails = false
    var isSafeRecommendationMovie = false

    // MARK: - Private Properties

    private var mockMovieResponse = MovieResponse(
        movies: [Movie(
            id: Constants.intNumberOne,
            posterPath: Constants.fooText,
            overview: Constants.fooText,
            releaseDate: Constants.fooText,
            title: Constants.fooText,
            rating: Constants.doubleNumberTwo
        )],
        page: Constants.intNumberOne,
        totalPages: Constants.intNumberOne
    )

    private var mockMovieDetails = MovieDetails(
        posterPath: Constants.fooText,
        overview: Constants.fooText,
        title: Constants.fooText,
        rating: Constants.doubleNumberTwo,
        tagline: Constants.fooText,
        releaseDate: Constants.fooText,
        runtime: Constants.intNumberOne,
        productionCountries: [ProductionCountries(name: Constants.fooText)],
        id: Constants.intNumberOne
    )

    private var mockRecommendationMovieResponse =
        RecommendationMovieResponse(movies: [RecommendationMovie(posterPath: Constants.fooText)])

    // MARK: - Public Methods

    func fetchMovies(movieType: MovieMVVM.MovieKind) -> MovieResponse? {
        mockMovieResponse
    }

    func fetchMovieDetails(id: Int) -> MovieDetails? {
        mockMovieDetails
    }

    func fetchRecommendationMovies(id: Int) -> RecommendationMovieResponse? {
        mockRecommendationMovieResponse
    }

    func safeMovies(movieType: MovieKind, movieResponse: MovieMVVM.MovieResponse) {
        isSafeMovies = true
    }

    func safeMovieDetails(movie: MovieDetails) {
        isSafeMovieDetails = true
    }

    func safeRecommendationMovies(id: Int, recommendationMovieResponse: RecommendationMovieResponse) {
        isSafeRecommendationMovie = true
    }
}
