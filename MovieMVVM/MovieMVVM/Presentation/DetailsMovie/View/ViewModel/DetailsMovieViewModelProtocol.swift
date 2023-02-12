// DetailsMovieViewModelProtocol.swift
// Copyright © KarpovaAV. All rights reserved.

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
    func fetchPhoto(to movie: MovieDetails, completion: DataHandler?)
    func fetchRecommendationMoviePhoto(to movie: RecommendationMovie, completion: DataHandler?)
}
