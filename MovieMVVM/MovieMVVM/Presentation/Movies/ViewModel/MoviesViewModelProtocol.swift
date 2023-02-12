// MoviesViewModelProtocol.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation

/// Протокол вью модели экрана выбора фильмов
protocol MoviesViewModelProtocol: AnyObject {
    var movies: [Movie] { get }
    var currentKind: MovieKind { get }
    var page: Int { get }
    var totalPages: Int { get }
    var isLoading: Bool { get }
    var movieKindHandler: MovieKindHandler? { get set }
    var moviesViewData: MoviesViewDataHandler? { get set }
    var reloadApiKeyValue: VoidHandler? { get set }
    func fetchMovies(_ kind: MovieKind, pagination: Bool)
    func handleChangedKind(to identifier: String?)
    func newFetchMovies(to indexPathRow: Int)
    func refreshControlAction()
    func fetchPhoto(to movie: Movie, completion: DataHandler?)
    func safeApiKey(value: String)
}
