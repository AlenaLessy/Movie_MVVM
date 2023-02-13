// MockNavigationController.swift
// Copyright © KarpovaAV. All rights reserved.

@testable import MovieMVVM
import UIKit

/// Мок навигационного контроллера
final class MockNavigationController: UINavigationController {
    // MARK: - Public Properties

    var presentedVC: UIViewController?

    // MARK: - Public Methods

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}
