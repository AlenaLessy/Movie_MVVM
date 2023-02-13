// DetailsMovieViewModelTests.swift
// Copyright © KarpovaAV. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тест вью модели экрана деталей фильмов
final class DetailsMovieViewModelTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let idNumber = 315_162
        static let fooText = "foo"
        static let intNumberOne = 1
        static let bazText = "baz"
        static let barText = "bar"
        static let doubleNumberOne = 1.0
    }

    // MARK: - Private Properties

    private var detailsMovieViewModel: DetailsMovieViewModelProtocol?
    private var mockDataService = MockDataService()
    private var mockImageService = MockImageService()
    private var mockDetailsMovie = MovieDetails(
        posterPath: Constants.bazText,
        overview: Constants.bazText,
        title: Constants.bazText,
        rating: Constants.doubleNumberOne,
        tagline: Constants.bazText,
        releaseDate: Constants.bazText,
        runtime: Constants.intNumberOne,
        productionCountries: [ProductionCountries(name: Constants.bazText)],
        id: Constants.idNumber
    )
    private var mockRecommendationMovieResponse =
        RecommendationMovieResponse(movies: [RecommendationMovie(posterPath: Constants.fooText)])

    // MARK: - Public Methods

    override func setUp() {
        super.setUp()
        detailsMovieViewModel = DetailsMovieViewModel(
            id: Constants.idNumber,
            dataService: mockDataService,
            imageService: mockImageService
        )
    }

    override func tearDown() {
        super.tearDown()
        detailsMovieViewModel = nil
    }

    func testFetchPhoto() {
        detailsMovieViewModel?.fetchPhoto(to: mockDetailsMovie, completion: { data in
            XCTAssertNotNil(data)
        })
    }

    func testFetchRecommendationMoviePhoto() {
        guard let movie = mockRecommendationMovieResponse.movies.first else { return }
        detailsMovieViewModel?.fetchRecommendationMoviePhoto(to: movie, completion: { data in
            XCTAssertNotNil(data)
        })
    }

    func testFetchDetailsMovie() {
        detailsMovieViewModel?.fetchDetailsMovie()
        XCTAssertNotNil(mockDataService.detailsMovie)
        guard let detailsMovie = mockDataService.detailsMovie else { return }
        XCTAssertEqual(mockDetailsMovie.tagline, detailsMovie.tagline)
    }

    func testFetchRecommendationMovies() {
        detailsMovieViewModel?.fetchRecommendationMovies()
        XCTAssertNotNil(mockDataService.recommendationMovies)
        guard let recommendationMovies = mockDataService.recommendationMovies else { return }
        XCTAssertEqual(
            mockRecommendationMovieResponse.movies.first?.posterPath,
            recommendationMovies.movies.first?.posterPath
        )
    }
}
