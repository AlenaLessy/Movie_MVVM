// Movie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель фильма
struct Movie: Decodable {
    /// Id фильма
    let id: Int
    /// Постер фильма
    let posterPath: String?
    /// Описание
    let overview: String
    /// Дата релиза
    let releaseDate: String
    /// Заголовок
    let title: String
    /// Рейтинг
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
