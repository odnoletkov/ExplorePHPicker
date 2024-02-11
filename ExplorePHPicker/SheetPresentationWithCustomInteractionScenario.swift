import UIKit
import PhotosUI
import SheetInteraction

@available(iOS 17, *)
class SheetPresentationWithCustomInteractionScenario: NSObject, Scenario {
    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.disabledCapabilities = [
            .stagingArea,
        ]
        configuration.filter = .images
        configuration.mode = .default
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .continuous
        configuration.selectionLimit = 0
        configuration.edgesWithoutContentMargins = .all.subtracting(.top)

        let pickerController = PHPickerViewController(configuration: configuration)
//        pickerController.delegate = self

        let hostingController = pickerController

        if let sheet = hostingController.sheetPresentationController {
            sheet.detents = detents
            sheet.prefersGrabberVisible = true
        }

        sheetInteraction = .init(
            sheet: hostingController.sheetPresentationController!,
            sheetView: pickerController.view
        )

        sheetInteraction.delegate = self
        sheetInteraction.sheetInteractionGesture.delegate = self

        fromController.present(hostingController, animated: true)
    }

    var sheetInteraction: SheetInteraction!
}

extension SheetPresentationWithCustomInteractionScenario: SheetStackInteractionForwardingBehavior {
    func shouldHandleSheetInteraction() -> Bool {
        return true
    }
}

extension SheetPresentationWithCustomInteractionScenario: SheetInteractionDelegate {
    func sheetInteractionBegan(sheetInteraction: SheetInteraction, at detent: DetentIdentifier) {
        print("\(#function): \(detent)")
    }

    func sheetInteractionChanged(sheetInteraction: SheetInteraction, interactionChange: SheetInteraction.Change) {
        print("\(#function): \(interactionChange)")
    }

    func sheetInteractionWillEnd(sheetInteraction: SheetInteraction, targetDetentInfo: SheetInteraction.Change.Info, targetPercentageTotal: CGFloat, onTouchUpPercentageTotal: CGFloat) {
        print("\(#function): \(targetDetentInfo), \(targetPercentageTotal), \(onTouchUpPercentageTotal)")
//        transitionPercentage = targetPercentageTotal


    }

    func sheetInteractionDidEnd(sheetInteraction: SheetInteraction, selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier) {
        print("\(#function): \(selectedDetentIdentifier)")
    }

    func sheetInteractionShouldDismiss(sheetInteraction: SheetInteraction) -> Bool {
        true
    }
}

extension SheetPresentationWithCustomInteractionScenario: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer == sheetInteraction.sheetInteractionGesture
    }
}

// po [UISheetPresentationController _shortMethodDescription]
