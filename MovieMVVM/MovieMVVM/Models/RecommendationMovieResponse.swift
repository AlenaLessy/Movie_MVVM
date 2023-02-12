// RecommendationMovieResponse.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation

/// Модель массива рекоммендации
struct RecommendationMovieResponse: Decodable {
    /// Фильмы
    let movies: [RecommendationMovie]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
