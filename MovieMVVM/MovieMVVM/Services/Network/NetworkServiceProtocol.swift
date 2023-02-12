// NetworkServiceProtocol.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation

/// Протокол сервиса изображений
protocol NetworkServiceProtocol {
    func fetchMovies(
        kind: MovieKind,
        page: Int,
        apiKey: String,
        completion: ((Result<MovieResponse, NetworkError>) -> ())?
    )
    func fetchDetailsMovie(id: Int, apiKey: String, completion: ((Result<MovieDetails, NetworkError>) -> ())?)
    func fetchRecommendationsMovies(
        id: Int, apiKey: String,
        completion: ((Result<RecommendationMovieResponse, NetworkError>) -> ())?
    )
}
