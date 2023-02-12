// MovieResponse.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation

/// Модель массива фильмов
struct MovieResponse: Decodable {
    /// Фильмы
    var movies: [Movie]
    /// Текущая страница фильмов
    var page: Int
    /// Общее количество страниц
    var totalPages: Int

    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case page
        case totalPages = "total_pages"
    }
}
