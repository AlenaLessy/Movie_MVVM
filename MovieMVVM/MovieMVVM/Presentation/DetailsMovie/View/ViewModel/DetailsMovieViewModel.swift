// DetailsMovieViewModel.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation

/// Вью модель экрана деталей о фильме
final class DetailsMovieViewModel: DetailsMovieViewModelProtocol {
    // MARK: - Public Properties

    var movieDetails: MovieDetails?
    var recommendationMovies: [RecommendationMovie] = []
    var failureHandler: VoidHandler?
    var reloadMovieHandler: VoidHandler?
    var reloadRecommendationMoviesHandler: VoidHandler?

    // MARK: - Private Properties

    private let dataService: DataServiceProtocol
    private let imageService: ImageServiceProtocol
    private let storageKeyChain: StorageKeyChainProtocol = StorageKeyChain()
    private var id: Int

    // MARK: - Initializers

    init(
        id: Int,
        dataService: DataServiceProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.id = id
        self.dataService = dataService
        self.imageService = imageService
        fetchRecommendationMovies()
        fetchDetailsMovie()
    }

    // MARK: - Public Methods

    func fetchPhoto(to movie: MovieDetails, completion: DataHandler?) {
        let urlString = movie.posterPath
        imageService.fetchPhoto(byUrl: urlString) { data in
            guard let data else { return }
            completion?(data)
        }
    }

    func fetchRecommendationMoviePhoto(to movie: RecommendationMovie, completion: DataHandler?) {
        guard let urlString = movie.posterPath else { return }
        imageService.fetchPhoto(byUrl: urlString) { data in
            guard let data else { return }
            completion?(data)
        }
    }

    func fetchDetailsMovie() {
        dataService
            .fetchDetailsMovie(
                id: id,
                apiKey: storageKeyChain.readValueFromKeyChain(from: .apiKey)
            ) { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .failure:
                        self.failureHandler?()
                    case let .success(movieDetails):
                        self.movieDetails = movieDetails
                        self.reloadMovieHandler?()
                    }
                }
            }
    }

    func fetchRecommendationMovies() {
        dataService
            .fetchRecommendationsMovies(
                id: id,
                apiKey: storageKeyChain.readValueFromKeyChain(from: .apiKey)
            ) { [weak self] result in
                guard let self else { return }

                DispatchQueue.main.async {
                    switch result {
                    case let .success(response):
                        self.recommendationMovies = response.movies
                        self.reloadRecommendationMoviesHandler?()
                        self.reloadMovieHandler?()

                    case .failure:
                        self.failureHandler?()
                    }
                }
            }
    }
}
