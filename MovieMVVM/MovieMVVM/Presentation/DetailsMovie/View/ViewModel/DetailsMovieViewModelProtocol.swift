// DetailsMovieViewModelProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол вью-модели экрана деталей фильма
protocol DetailsMovieViewModelProtocol: AnyObject {
    var movieDetails: MovieDetails? { get }
    var recommendationMovies: [RecommendationMovie] { get }
    var failureHandler: VoidHandler? { get set }
    var reloadMovieHandler: VoidHandler? { get set }
    var reloadRecommendationMoviesHandler: VoidHandler? { get set }
    func fetchRecommendationMovies()
    func fetchDetailsMovie()
    func fetchPhoto(to movie: MovieDetails, completion: ((Data) -> Void)?)
    func fetchRecommendationMoviePhoto(to movie: RecommendationMovie, completion: ((Data) -> Void)?)
}
