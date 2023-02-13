// AssemblyModuleBuilderTests.swift
// Copyright © KarpovaAV. All rights reserved.

@testable import MovieMVVM
import XCTest

/// Тест сборщика модулей
final class AssemblyModuleBuilderTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let idNumber = 315_162
    }

    // MARK: - Private Properties

    private var assemblyModuleBuilder: AssemblyBuilderProtocol?

    // MARK: - Public Methods

    override func setUp() {
        assemblyModuleBuilder = AssemblyModuleBuilder()
    }

    override func tearDown() {
        assemblyModuleBuilder = nil
    }

    func testMakeMoviesModule() {
        let movies = assemblyModuleBuilder?.makeMoviesModule()
        XCTAssertTrue(movies is MoviesViewController)
    }

    func testMakeDetailsMovieModule() {
        let id = Constants.idNumber
        let movieDetails = assemblyModuleBuilder?.makeDetailsMovieModule(id: id)
        XCTAssertTrue(movieDetails is DetailsMovieViewController)
    }

    func testMakeImageProxyService() {
        let imageProxyService = assemblyModuleBuilder?.makeImageProxyService()
        XCTAssertTrue(imageProxyService is ImageProxyService)
    }

    func testMakeDataService() {
        let dataService = assemblyModuleBuilder?.makeDataService()
        XCTAssertTrue(dataService is DataService)
    }

    func testMakeImageService() {
        let imageService = assemblyModuleBuilder?.makeImageService()
        XCTAssertTrue(imageService is ImageService)
    }
}
