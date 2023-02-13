// MoviesViewModelTests.swift
// Copyright © KarpovaAV. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тест вью модели экрана фильмов
final class MoviesViewModelTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let fooText = "foo"
        static let intNumberOne = 1
        static let emptyString = ""
        static let timeOutNumber = 5.0
        static let popularText = "popular"
        static let bazText = "baz"
        static let barText = "bar"
        static let doubleNumberOne = 1.0
    }

    // MARK: - Private Properties

    private var moviesViewModel: MoviesViewModelProtocol?
    private var mockDataService = MockDataService()
    private var imageService = MockImageService()
    private var storageKeyChain = MockStorageKeyChain()
    private var moviesViewData: MoviesViewData?
    private var currentKind: MovieKind = .topRated
    private var page = Constants.intNumberOne
    private var isError = false
    private var isLoading = false
    private var mockMovieResponse = MovieResponse(
        movies: [Movie(
            id: Constants.intNumberOne,
            posterPath: Constants.emptyString,
            overview: Constants.emptyString,
            releaseDate: Constants.emptyString,
            title: Constants.emptyString,
            rating: Constants.doubleNumberOne
        )],
        page: Constants.intNumberOne,
        totalPages: Constants.intNumberOne
    )

    // MARK: - Public Methods

    override func setUp() {
        super.setUp()
        moviesViewModel = MoviesViewModel(
            dataService: mockDataService,
            imageService: imageService,
            storageKeyChain: storageKeyChain
        )
    }

    override func tearDown() {
        super.tearDown()
        moviesViewModel = nil
    }

    func testSafeApiKey() {
        let apiKey = storageKeyChain.readValueFromKeyChain(from: .apiKey)
        XCTAssertNotNil(apiKey)
        guard apiKey.isEmpty else { return }
        storageKeyChain.safeValueToKeyChain(key: .apiKey, value: Constants.fooText)
        let newApiKey = storageKeyChain.readValueFromKeyChain(from: .apiKey)
        XCTAssertEqual(newApiKey, Constants.fooText)
    }

    func testFetchPhoto() {
        imageService.fetchPhoto(byUrl: Constants.fooText, completion: { data in
            XCTAssertNotNil(data)
        })
    }

    func testFetchMovies() {
        moviesViewModel?.moviesViewData = { [weak self] states in
            guard let self else { return }
            switch states {
            case .initial:
                XCTAssertTrue(false)
            case .loading:
                self.isLoading = true
            case .success:
                self.isLoading.toggle()
            case .failure:
                self.isError = true
            }
        }
        moviesViewModel?.fetchMovies(currentKind, pagination: false)
        XCTAssertEqual(isLoading, true)
        XCTAssertEqual(isError, false)
        XCTAssertNotNil(mockDataService.movieResponse)
        guard let movies = mockDataService.movieResponse else { return }
        XCTAssertEqual(mockMovieResponse.movies.first?.id, movies.movies.first?.id)
    }

    func testHandleChangedKind() {
        currentKind = .popular
        page = Constants.intNumberOne
        moviesViewModel?.handleChangedKind(to: Constants.popularText)
        XCTAssertEqual(moviesViewModel?.currentKind, currentKind)
        XCTAssertEqual(moviesViewModel?.page, page)
    }

    func testRefreshControlAction() {
        moviesViewModel?.refreshControlAction()
        XCTAssertEqual(moviesViewModel?.page, Constants.intNumberOne)
        XCTAssertEqual(moviesViewModel?.currentKind, currentKind)
    }

    func testNewFetchMovies() {
        moviesViewModel?.newFetchMovies(to: Constants.intNumberOne)
        XCTAssertEqual(moviesViewModel?.currentKind, currentKind)
        XCTAssertEqual(isLoading, false)
        XCTAssertEqual(isError, false)
    }
}
