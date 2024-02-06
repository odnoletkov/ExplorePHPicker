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
            sheet.detents = [
                .custom { _ in 400 },
                .large(),
            ]
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
        hostedController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostedController.view)
        NSLayoutConstraint.activate([
            hostedController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostedController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostedController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            hostedController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        hostedController.didMove(toParent: self)

        sheetInteraction.delegate = self
        sheetInteraction.sheetInteractionGesture.delegate = self
    }
}

extension PickerHostingController: SheetStackInteractionForwardingBehavior {
    func shouldHandleSheetInteraction() -> Bool {
        return true
    }
}

extension PickerHostingController: SheetInteractionDelegate {
    func sheetInteractionBegan(sheetInteraction: SheetInteraction, at detent: DetentIdentifier) {
        print("\(#function): \(detent)")
    }
    
    func sheetInteractionChanged(sheetInteraction: SheetInteraction, interactionChange: SheetInteraction.Change) {
        print("\(#function): \(interactionChange)")
    }
    
    func sheetInteractionWillEnd(sheetInteraction: SheetInteraction, targetDetentInfo: SheetInteraction.Change.Info, targetPercentageTotal: CGFloat, onTouchUpPercentageTotal: CGFloat) {
        print("\(#function): \(targetDetentInfo), \(targetPercentageTotal), \(onTouchUpPercentageTotal)")
    }
    
    func sheetInteractionDidEnd(sheetInteraction: SheetInteraction, selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier) {
        print("\(#function): \(selectedDetentIdentifier)")
    }
    
    func sheetInteractionShouldDismiss(sheetInteraction: SheetInteraction) -> Bool {
        true
    }
}

extension PickerHostingController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer == sheetInteraction.sheetInteractionGesture
    }
}
