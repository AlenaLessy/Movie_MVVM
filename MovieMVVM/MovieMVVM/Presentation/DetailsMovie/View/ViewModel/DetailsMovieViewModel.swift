// DetailsMovieViewModel.swift
// Copyright © RoadMap. All rights reserved.

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

    private let networkService: NetworkServiceProtocol
    private let imageService: ImageServiceProtocol
    private var id: Int

    // MARK: - Initializers

    init(
        id: Int,
        networkService: NetworkServiceProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.id = id
        self.networkService = networkService
        self.imageService = imageService
        fetchRecommendationMovies()
        fetchDetailsMovie()
    }

    // MARK: - Public Methods

    func fetchPhoto(to movie: MovieDetails, completion: ((Data) -> Void)?) {
        let urlString = movie.posterPath
        imageService.fetchPhoto(byUrl: urlString) { data in
            guard let data else { return }
            completion?(data)
        }
    }

    func fetchRecommendationMoviePhoto(to movie: RecommendationMovie, completion: ((Data) -> Void)?) {
        guard let urlString = movie.posterPath else { return }
        imageService.fetchPhoto(byUrl: urlString) { data in
            guard let data else { return }
            completion?(data)
        }
    }

    func fetchDetailsMovie() {
        networkService.fetchDetailsMovie(id: id) { [weak self] result in
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
        networkService.fetchRecommendationsMovies(id: id) { [weak self] result in
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
