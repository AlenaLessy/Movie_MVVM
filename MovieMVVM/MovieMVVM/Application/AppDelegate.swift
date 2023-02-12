// AppDelegate.swift
// Copyright © KarpovaAV. All rights reserved.

import CoreData
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Private Constants

    private enum Constants {
        static let persistentContainerName = "MovieMVVM"
        static let unresolvedErrorText = "Unresolved error"
        static let defaultConfigurationText = "Default Configuration"
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.persistentContainerName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("\(Constants.unresolvedErrorText) \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: Constants.defaultConfigurationText, sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessionsSet: Set<UISceneSession>) {}

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(Constants.unresolvedErrorText) \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
