// MoviesViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Вью модель экрана выбора фильмов
final class MoviesViewModel: MoviesViewModelProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let one = 1
    }

    // MARK: - Public Properties

    let networkService: NetworkServiceProtocol
    let imageService: ImageServiceProtocol

    var currentKind: MovieKind = .topRated
    var movies: [Movie] = []
    var page = Constants.one
    var totalPages = Constants.one
    var isLoading = false
    var movieKindHandler: ((MovieKind) -> ())?
    var moviesViewData: ((MoviesViewData) -> Void)?

    // MARK: - Initializers

    required init(
        networkService: NetworkServiceProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.networkService = networkService
        self.imageService = imageService
        fetchMovies(currentKind)
    }

    // MARK: - Public Methods

    func fetchMovies(_ kind: MovieKind, pagination: Bool = false) {
        isLoading = true
        moviesViewData?(.loading)
        page = pagination ? page + Constants.one : page
        networkService.fetchMovies(kind: kind, page: page) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case let .success(response):
                    self.page = response.page
                    self.totalPages = response.totalPages
                    self.movies = pagination ? self.movies + response.movies : response.movies
                    self.moviesViewData?(.success)
                case .failure:
                    self.moviesViewData?(.failure)
                }
            }
        }
    }

    func handleChangedKind(to identifier: String?) {
        guard let identifier,
              let kind = MovieKind(rawValue: identifier)
        else { return }
        guard currentKind != kind else { return }
        movies = []
        moviesViewData?(.success)
        page = Constants.one
        currentKind = kind
        fetchMovies(currentKind)
        movieKindHandler?(currentKind)
    }

    func newFetchMovies(to indexPathRow: Int) {
        let isLastCell = indexPathRow == movies.count - Constants.one
        guard isLastCell, !isLoading, !movies.isEmpty else { return }
        fetchMovies(currentKind, pagination: true)
    }

    func refreshControlAction() {
        moviesViewData?(.loading)
        page = Constants.one
        fetchMovies(currentKind)
    }
}
