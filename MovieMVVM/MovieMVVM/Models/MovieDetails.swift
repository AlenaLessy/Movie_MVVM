// MovieDetails.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель деталей фильма
struct MovieDetails: Decodable {
    
/// Постер фильма
    let posterPath: String
    /// Описание
    let overview: String
   /// Заголовок
    let title: String
    /// Рейтинг
    let rating: Double
    /// Слоган
    let tagline: String
    /// Дата релиза
    let releaseDate: String
    /// Продолжительность
    let runtime: Int
    /// Страна производитель
    let productionCountries: [ProductionCountries]
    /// Id фильма
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "backdrop_path"
        case overview
        case title
        case rating = "vote_average"
        case tagline
        case releaseDate = "release_date"
        case runtime
        case productionCountries = "production_countries"
        case id
    }
}
