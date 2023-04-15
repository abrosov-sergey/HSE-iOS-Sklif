import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = UINavigationController(rootViewController: DicomFilesModuleConfigurator().configure().view)
        window?.rootViewController = UINavigationController(rootViewController: AuthorizationModuleConfigurator().configure().view)
        window?.makeKeyAndVisible()

        return true
    }
}
