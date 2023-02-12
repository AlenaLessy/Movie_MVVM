// ApplicationCoordinator.swift
// Copyright © KarpovaAV. All rights reserved.

import Foundation

/// Координатор приложения
final class ApplicationCoordinator: BaseCoordinator {
    // MARK: - Private Properties

    private var assemblyBuilder: AssemblyBuilderProtocol!

    // MARK: - Initializers

    init(assemblyBuilder: AssemblyBuilderProtocol) {
        self.assemblyBuilder = assemblyBuilder
    }

    // MARK: - Public Methods

    override func start() {
        toMovies()
    }

    // MARK: - Private Methods

    private func toMovies() {
        let coordinator = MoviesCoordinator(assemblyBuilder: assemblyBuilder)
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            guard let self else { return }
            self.removeDependency(coordinator)
            self.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
