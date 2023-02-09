// NetworkServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол сервиса изображений
protocol NetworkServiceProtocol {
    func fetchMovies(kind: MovieKind, page: Int, completion: ((Result<MovieResponse, NetworkError>) -> ())?)
    func fetchDetailsMovie(id: Int, completion: ((Result<MovieDetails, NetworkError>) -> ())?)
    func fetchRecommendationsMovies(
        id: Int,
        completion: ((Result<RecommendationMovieResponse, NetworkError>) -> ())?
    )
}
