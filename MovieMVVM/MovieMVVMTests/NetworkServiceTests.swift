// NetworkServiceTests.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation

import XCTest

@testable import MovieMVVM

/// Тест интернет сервиса
final class NetworkServiceTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let intOneNumber = 1
        static let bazText = "baz"
        static let emptyString = ""
        static let timeOutNumber = 5.0
        static let idNumber = 315_162
    }

    // MARK: - Private Properties

    private var networkService: NetworkServiceProtocol?

    // MARK: - Public Methods

    override func setUp() {
        networkService = NetworkService()
    }

    override func tearDown() {
        networkService = nil
    }

    func testFetchMovies() {
        let expectation = XCTestExpectation(description: Constants.emptyString)
        networkService?.fetchMovies(
            kind: .popular,
            page: Constants.intOneNumber,
            apiKey: Constants.bazText,
            completion: { result in
                switch result {
                case let .success(movies):
                    expectation.fulfill()
                    XCTAssertNotNil(movies)
                case let .failure(error):
                    expectation.fulfill()
                    XCTAssertNotNil(error)
                }
            }
        )
        wait(for: [expectation], timeout: Constants.timeOutNumber)
    }

    func testFetchRecommendationMovies() {
        let expectation = XCTestExpectation(description: Constants.emptyString)
        networkService?.fetchRecommendationsMovies(
            id: Constants.intOneNumber,
            apiKey: Constants.bazText,
            completion: { result in
                switch result {
                case let .success(recommendationMovies):
                    expectation.fulfill()
                    XCTAssertNotNil(recommendationMovies)
                case let .failure(error):
                    expectation.fulfill()
                    XCTAssertNotNil(error)
                }
            }
        )
        wait(for: [expectation], timeout: Constants.timeOutNumber)
    }

    func testFetchDetailsMovie() {
        let id = Constants.idNumber
        let expectation = XCTestExpectation(description: Constants.emptyString)
        networkService?.fetchDetailsMovie(
            id: Constants.intOneNumber,
            apiKey: Constants.bazText,
            completion: { result in
                switch result {
                case let .success(detailsMovie):
                    expectation.fulfill()
                    XCTAssertNotNil(detailsMovie)
                    XCTAssertEqual(detailsMovie.id, id)
                case let .failure(error):
                    expectation.fulfill()
                    XCTAssertNotNil(error)
                }
            }
        )
        wait(for: [expectation], timeout: Constants.timeOutNumber)
    }
}
