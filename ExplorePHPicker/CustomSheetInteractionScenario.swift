import UIKit
import PhotosUI
import SheetInteraction

@available(iOS 17, *)
class CustomSheetInteractionScenario: NSObject, Scenario {
    let title = "Custom Sheet Interaction (iOS 17)"

    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.disabledCapabilities = [
//            .search,
            .stagingArea,
//            .collectionNavigation,
//            .selectionActions,
//            .sensitivityAnalysisIntervention,
        ]
        configuration.filter = .images
        configuration.mode = .default
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .ordered
        configuration.selectionLimit = 0
        configuration.edgesWithoutContentMargins = .all

        let pickerController = PHPickerViewController(configuration: configuration)
//        pickerController.delegate = self

        let hostingController = PickerHostingController()
        hostingController.hostedController = pickerController

        fromController.present(hostingController, animated: true)
    }
}

class PickerHostingController: UIViewController {

    var hostedController: UIViewController!

    override func viewDidLoad() {
        view.backgroundColor = .gray

        addChild(hostedController)
        hostedController.view.translatesAutoresizingMaskIntoConstraints = true
        hostedController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostedController.view.frame = view.bounds
        view.addSubview(hostedController.view)
        hostedController.didMove(toParent: self)
    }
}
