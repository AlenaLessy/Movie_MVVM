// UIViewController+Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Универсальный алерт
extension UIViewController {
    func showAlert(title: String?, message: String?, actionTitle: String?, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertControllerAction = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        alertController.addAction(alertControllerAction)
        present(alertController, animated: true)
    }
}

/// Универсальный алерт c текстфилдом
extension UIViewController {
    func showAlertWidthTextfield(title: String?, message: String?, actionTitle: String?, handler: ((String) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertControllerAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            guard let apiKey = alertController.textFields?.first?.text else { return }
            handler?(apiKey)
        }
        alertController.addAction(alertControllerAction)
        alertController.addTextField()
        present(alertController, animated: true)
    }
}
