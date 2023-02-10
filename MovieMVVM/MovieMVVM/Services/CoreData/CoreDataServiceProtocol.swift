// CoreDataServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол сервиса работы с кор датой
protocol CoreDataServiceProtocol {
    func safeMovies(movieType: MovieKind, movieResponse: MovieResponse)
    func fetchMovies(movieType: MovieKind) -> MovieResponse?
    func safeMovieDetails(movie: MovieDetails)
    func safeRecommendationMovies(id: Int, recommendationMovieResponse: RecommendationMovieResponse)
    func fetchMovieDetails(id: Int) -> MovieDetails?
    func fetchRecommendationMovies(id: Int) -> RecommendationMovieResponse?
}
