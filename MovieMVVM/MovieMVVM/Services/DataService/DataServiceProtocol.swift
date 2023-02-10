// DataServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол сервиса по получению данных
protocol DataServiceProtocol {
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
