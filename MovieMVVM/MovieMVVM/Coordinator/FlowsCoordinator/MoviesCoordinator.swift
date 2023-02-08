// MoviesCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Координатор фильмов
final class MoviesCoordinator: BaseCoordinator {
    // MARK: - Public Properties

    var rootController: UINavigationController?
    var onFinishFlow: VoidHandler?

    // MARK: - Public Methods

    override func start() {
        showMoviesModule()
    }

    // MARK: - Private Methods

    private func showMoviesModule() {
        guard let moviesViewController = AssemblyModuleBuilder().makeMoviesModule() as? MoviesViewController
        else { return }

        moviesViewController.showDetailsMovieHandler = { [weak self] id in
            guard let self else { return }
            self.showDetailsMovie(id: id)
        }

        let rootController = UINavigationController(rootViewController: moviesViewController)
        setAsRoot(rootController)
        self.rootController = rootController
    }

    private func showDetailsMovie(id: Int) {
        guard let detailsMovieViewController = AssemblyModuleBuilder()
            .makeDetailsMovieModule(id: id) as? DetailsMovieViewController
        else { return }
        rootController?.pushViewController(detailsMovieViewController, animated: true)
    }
}
