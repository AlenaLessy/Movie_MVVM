// RecommendationMovieResponse.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель массива рекоммендации
struct RecommendationMovieResponse: Decodable {
    let movies: [RecommendationMovie]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
