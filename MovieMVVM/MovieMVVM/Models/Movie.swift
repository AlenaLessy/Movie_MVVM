// Movie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель фильма
struct Movie: Decodable {
    let id: Int
    let posterPath: String?
    let overview: String
    let releaseDate: String
    let title: String
    let rating: Double
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
        case title
        case rating = "vote_average"
    }
}
