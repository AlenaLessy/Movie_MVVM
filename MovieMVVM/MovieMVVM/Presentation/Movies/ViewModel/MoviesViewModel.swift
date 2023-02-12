// MoviesViewModel.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation

/// Вью модель экрана выбора фильмов
final class MoviesViewModel: MoviesViewModelProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let one = 1
    }

    // MARK: - Public Properties

    var currentKind: MovieKind = .topRated
    var movies: [Movie] = []
    var page = Constants.one
    var totalPages = Constants.one
    var isLoading = false
    var movieKindHandler: MovieKindHandler?
    var moviesViewData: MoviesViewDataHandler?
    var reloadApiKeyValue: VoidHandler?

    // MARK: - Private Properties

    private let dataService: DataServiceProtocol
    private let imageService: ImageServiceProtocol
    private let storageKeyChain: StorageKeyChainProtocol

    // MARK: - Initializers

    required init(
        dataService: DataServiceProtocol,
        imageService: ImageServiceProtocol,
        storageKeyChain: StorageKeyChainProtocol
    ) {
        self.dataService = dataService
        self.imageService = imageService
        self.storageKeyChain = storageKeyChain
        fetchMovies(currentKind)
    }

    // MARK: - Public Methods

    func safeApiKey(value: String) {
        var apiKey = storageKeyChain.readValueFromKeyChain(from: .apiKey)
        guard apiKey.isEmpty else { return }
        storageKeyChain.safeValueToKeyChain(key: .apiKey, value: value)
        reloadApiKeyValue?()
    }

    func fetchPhoto(to movie: Movie, completion: DataHandler?) {
        guard let urlString = movie.posterPath else { return }
        imageService.fetchPhoto(byUrl: urlString) { data in
            guard let data else { return }
            completion?(data)
        }
    }

    func fetchMovies(_ kind: MovieKind, pagination: Bool = false) {
        isLoading = true
        moviesViewData?(.loading)
        page = pagination ? page + Constants.one : page
        dataService
            .fetchMovies(
                kind: kind,
                page: page,
                apiKey: storageKeyChain.readValueFromKeyChain(from: .apiKey)
            ) { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                DispatchQueue.main.async {
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
