// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Сцена
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: ApplicationCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.makeKeyAndVisible()
        coordinator = ApplicationCoordinator()
        coordinator?.start()
    }
}
