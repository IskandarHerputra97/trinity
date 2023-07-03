//
//  AppDelegate.swift
//  TrinityWizard
//
//  Created by Iskandar Herputra Wahidiyat on 03/07/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        showMainController()
        return true
    }
    
    // MARK: - Setup
    @objc private func showMainController() {
        if self.window == nil {
            self.window = UIWindow()
        }
        
        let landingPageVC: UIViewController = createNonLoginLandingPage()
        
        self.window?.rootViewController = landingPageVC
        self.window?.makeKeyAndVisible()
    }
    
    private func createNonLoginLandingPage() -> UIViewController {
        let landingPageViewController: HomeViewController = HomeViewController()
        let navController: UINavigationController = UINavigationController(rootViewController: landingPageViewController)
        return navController
    }
}

