import UIKit
import PhotosUI

@main
class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let controller = Controller()
        controller.view.backgroundColor = .secondarySystemBackground
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = UINavigationController(rootViewController: controller)
        window!.makeKeyAndVisible()
        return true
    }
}

class Controller: UIViewController {
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = .init(systemItem: .camera, primaryAction: .init { [unowned self] _ in
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.disabledCapabilities = [
                .search,
                .stagingArea,
                .collectionNavigation,
                .selectionActions,
                .sensitivityAnalysisIntervention,
            ]
            //configuration.edgesWithoutContentMargins = .leading
            configuration.filter = .images
            //configuration.mode = .compact
            //configuration.preferredAssetRepresentationMode = .automatic
            //configuration.preselectedAssetIdentifiers
            // how to distinguish tap on Done from selection in `continuous` mode?
            //configuration.selection = .continuousAndOrdered
            configuration.selectionLimit = 0
            configuration.edgesWithoutContentMargins = .all

            let controller = PHPickerViewController(configuration: configuration)
            controller.delegate = self

            //navigationController?.pushViewController(controller, animated: true)
            //present(controller, animated: true)

            if let sheet = controller.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            }
            present(controller, animated: true, completion: nil)

        })
    }
}

extension Controller: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(results)
    }
}
