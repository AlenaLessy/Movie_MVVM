// MoviesViewModelProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол вью модели экрана выбора фильмов
protocol MoviesViewModelProtocol: AnyObject {
    var movies: [Movie] { get }
    var currentKind: MovieKind { get }
    var page: Int { get }
    var totalPages: Int { get }
    var isLoading: Bool { get }
    var imageService: ImageServiceProtocol { get }
    var movieKindHandler: ((MovieKind) -> ())? { get set }
    var moviesViewData: ((MoviesViewData) -> Void)? { get set }
    func fetchMovies(_ kind: MovieKind, pagination: Bool)
    func handleChangedKind(to identifier: String?)
    func newFetchMovies(to indexPathRow: Int)
    func refreshControlAction()
}
