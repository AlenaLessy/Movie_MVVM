// MovieResponse.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель массива фильмов
struct MovieResponse: Decodable {
    
    /// Фильмы
    let movies: [Movie]
    /// Текущая страница фильмов
    let page: Int
    /// Общее количество страниц
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case page
        case totalPages = "total_pages"
    }
}
