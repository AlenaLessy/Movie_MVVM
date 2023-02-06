// RecommendationMovie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель рекомендованного фильма
struct RecommendationMovie: Decodable {
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
    }
}
