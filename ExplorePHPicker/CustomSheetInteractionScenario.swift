import UIKit
import PhotosUI
import SheetInteraction

@available(iOS 17, *)
class CustomSheetInteractionScenario: NSObject, Scenario {
    let title = "Custom Sheet Interaction (iOS 17)"

    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.disabledCapabilities = [
            .stagingArea,
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

        if let sheet = hostingController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        fromController.present(hostingController, animated: true)
    }
}

class PickerHostingController: UIViewController {

    var hostedController: UIViewController!

    private lazy var sheetInteraction: SheetInteraction = .init(sheet: sheetPresentationController!, sheetView: view)

    override func viewDidLoad() {
        view.backgroundColor = .gray

        addChild(hostedController)
        hostedController.view.translatesAutoresizingMaskIntoConstraints = true
        hostedController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostedController.view.frame = view.bounds
        view.addSubview(hostedController.view)
        hostedController.didMove(toParent: self)

//        sheetInteraction.sheetInteractionGesture.delegate = self
        sheetInteraction.delegate = self
    }
}

extension PickerHostingController: SheetInteractionDelegate {
    func sheetInteractionBegan(sheetInteraction: SheetInteraction, at detent: DetentIdentifier) {

    }
    
    func sheetInteractionChanged(sheetInteraction: SheetInteraction, interactionChange: SheetInteraction.Change) {

    }
    
    func sheetInteractionWillEnd(sheetInteraction: SheetInteraction, targetDetentInfo: SheetInteraction.Change.Info, targetPercentageTotal: CGFloat, onTouchUpPercentageTotal: CGFloat) {

    }
    
    func sheetInteractionDidEnd(sheetInteraction: SheetInteraction, selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier) {

    }
    
    func sheetInteractionShouldDismiss(sheetInteraction: SheetInteraction) -> Bool {
        true
    }
}
