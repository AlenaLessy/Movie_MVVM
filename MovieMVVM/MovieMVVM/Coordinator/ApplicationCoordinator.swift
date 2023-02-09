// ApplicationCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Координатор приложения
final class ApplicationCoordinator: BaseCoordinator {
    // MARK: - Public Methods

    override func start() {
        toMovies()
    }

    // MARK: - Private Methods

    private func toMovies() {
        let coordinator = MoviesCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            guard let self else { return }
            self.removeDependency(coordinator)
            self.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
