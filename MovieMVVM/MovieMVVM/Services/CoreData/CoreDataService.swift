// CoreDataService.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import UIKit

/// Сервис работы с кор датой
final class CoreDataService: CoreDataServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let moviesEntityName = "CoreDataMovies"
        static let coreDataMovieDetailsEntityName = "CoreDataMovieDetails"
        static let safeErrorText = "Не удалось сохранить данные"
        static let predicateFormatText = "movieType Contains %@"
        static let emptyString = ""
        static let sortingItemName = "rating"
        static let predicateFormatIdText = "id Contains %@"
        static let coreDataRecommendationMovieEntityName = "CoreDataRecommendationMovie"
    }

    // MARK: - Private Properties

    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    // MARK: - Public Methods

    func safeMovies(movieType: MovieKind, movieResponse: MovieResponse) {
        guard let context else { return }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.moviesEntityName, in: context)
        else { return }
        let movies = movieResponse.movies
        for movie in movies {
            let coreDataMoviesObject = CoreDataMovies(entity: entity, insertInto: context)
            coreDataMoviesObject.id = Int64(movie.id)
            coreDataMoviesObject.posterPath = movie.posterPath
            coreDataMoviesObject.overview = movie.overview
            coreDataMoviesObject.rating = movie.rating
            coreDataMoviesObject.releaseDate = movie.releaseDate
            coreDataMoviesObject.title = movie.title
            coreDataMoviesObject.totalPages = Int64(movieResponse.totalPages)
            coreDataMoviesObject.page = Int64(movieResponse.page)
            switch movieType {
            case .popular:
                coreDataMoviesObject.movieType = MovieKind.popular.rawValue
            case .topRated:
                coreDataMoviesObject.movieType = MovieKind.topRated.rawValue
            case .upcoming:
                coreDataMoviesObject.movieType = MovieKind.upcoming.rawValue
            }
        }
        do {
            try context.save()
        } catch {
            print(Constants.safeErrorText)
        }
    }

    func safeMovieDetails(movie: MovieDetails) {
        guard let context else { return }
        // context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard let entity = NSEntityDescription.entity(
            forEntityName: Constants.coreDataMovieDetailsEntityName,
            in: context
        )
        else { return }
        let coreDataMovieDetailsObject = CoreDataMovieDetails(entity: entity, insertInto: context)
        coreDataMovieDetailsObject.id = Int64(movie.id)
        coreDataMovieDetailsObject.rating = movie.rating
        coreDataMovieDetailsObject.overview = movie.overview
        coreDataMovieDetailsObject.posterPath = movie.posterPath
        coreDataMovieDetailsObject.productionCountries = movie.productionCountries.first?.name
        coreDataMovieDetailsObject.releaseDate = movie.releaseDate
        coreDataMovieDetailsObject.tagline = movie.tagline
        coreDataMovieDetailsObject.title = movie.title
        coreDataMovieDetailsObject.runtime = Int64(movie.runtime)
        do {
            try context.save()
        } catch {
            print(Constants.safeErrorText)
        }
    }

    func safeRecommendationMovies(id: Int, recommendationMovieResponse: RecommendationMovieResponse) {
        guard let context else { return }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard let entity = NSEntityDescription.entity(
            forEntityName: Constants.coreDataRecommendationMovieEntityName,
            in: context
        )
        else { return }
        let movies = recommendationMovieResponse.movies
        for movie in movies {
            let coreDataRecommendationMoviesObject = CoreDataRecommendationMovie(entity: entity, insertInto: context)
            coreDataRecommendationMoviesObject.id = Int64(id)
            coreDataRecommendationMoviesObject.posterPath = movie.posterPath
        }
        do {
            try context.save()
        } catch {
            print(Constants.safeErrorText)
        }
    }

    func fetchMovieDetails(id: Int) -> MovieDetails? {
        guard let context else { return nil }
        let request = CoreDataMovieDetails.fetchRequest() as NSFetchRequest<CoreDataMovieDetails>
        let predicate = NSPredicate(format: Constants.predicateFormatIdText, id.description)
        request.predicate = predicate
        let coreDataMoviesDetails = try? context.fetch(request)
        guard let coreDataMoviesDetails else { return nil }
        var movies: [MovieDetails] = []
        for coreDataMovieDetails in coreDataMoviesDetails {
            movies.append(MovieDetails(
                posterPath: coreDataMovieDetails.posterPath ?? Constants.emptyString,
                overview: coreDataMovieDetails.overview ?? Constants.emptyString,
                title: coreDataMovieDetails.title ?? Constants.emptyString,
                rating: coreDataMovieDetails.rating,
                tagline: coreDataMovieDetails.tagline ?? Constants.emptyString,
                releaseDate: coreDataMovieDetails.releaseDate ?? Constants.emptyString,
                runtime: Int(coreDataMovieDetails.runtime),
                productionCountries: [ProductionCountries(
                    name: coreDataMovieDetails.productionCountries ?? Constants
                        .emptyString
                )],
                id: Int(coreDataMovieDetails.id)
            ))
        }
        return movies.first
    }

    func fetchMovies(movieType: MovieKind) -> MovieResponse? {
        guard let context else { return nil }
        let request = CoreDataMovies.fetchRequest() as NSFetchRequest<CoreDataMovies>
        let predicate = NSPredicate(format: Constants.predicateFormatText, movieType.rawValue)
        let descriptor = NSSortDescriptor(
            key: Constants.sortingItemName,
            ascending: false,
            selector: #selector(NSString.localizedStandardCompare(_:))
        )
        request.sortDescriptors = [descriptor]
        request.predicate = predicate
        let coreDataMovies = try? context.fetch(request)
        guard let coreDataMovies else { return nil }
        var movies: [Movie] = []
        for coreDataMovie in coreDataMovies {
            movies.append(Movie(
                id: Int(coreDataMovie.id),
                posterPath: coreDataMovie.posterPath,
                overview: coreDataMovie.overview ?? Constants.emptyString,
                releaseDate: coreDataMovie.releaseDate ?? Constants.emptyString,
                title: coreDataMovie.title ?? Constants.emptyString,
                rating: coreDataMovie.rating
            ))
        }
        let page = Int(coreDataMovies.first?.page ?? 0)
        let totalPages = Int(coreDataMovies.first?.totalPages ?? 0)
        return MovieResponse(movies: movies, page: page, totalPages: totalPages)
    }

    func fetchRecommendationMovies(id: Int) -> RecommendationMovieResponse? {
        guard let context else { return nil }
        let request = CoreDataRecommendationMovie.fetchRequest() as NSFetchRequest<CoreDataRecommendationMovie>
        let predicate = NSPredicate(format: Constants.predicateFormatIdText, id.description)
        request.predicate = predicate
        let coreDataRecommendationMovies = try? context.fetch(request)
        guard let coreDataRecommendationMovies else { return nil }
        var movies: [RecommendationMovie] = []
        for coreDataRecommendationMovie in coreDataRecommendationMovies {
            movies.append(RecommendationMovie(posterPath: coreDataRecommendationMovie.posterPath))
        }
        return RecommendationMovieResponse(movies: movies)
    }
}
