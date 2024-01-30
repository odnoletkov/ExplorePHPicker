import UIKit
import PhotosUI

class PresentFromSheetScenario: NSObject, Scenario {
    let title = "Present From Sheet"

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
        // how to distinguish tap on Done from selection in `continuous` mode?
        configuration.selection = .ordered
        configuration.selectionLimit = 0
        configuration.edgesWithoutContentMargins = .all

        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self

        let sheet = pickerController.sheetPresentationController!
        sheet.detents = [.medium(), .large()]
        sheet.largestUndimmedDetentIdentifier = .medium
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersGrabberVisible = true
        sheet.delegate = self

        fromController.present(pickerController, animated: true)
    }
}

extension PresentFromSheetScenario: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(results)
    }
}

extension PresentFromSheetScenario: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheet: UISheetPresentationController) {
        print("\(#function)")

        let pickerController = sheet.presentedViewController as! PHPickerViewController
        pickerController.updatePicker(using: {
            var update = PHPickerConfiguration.Update()
            update.edgesWithoutContentMargins = pickerController.configuration.edgesWithoutContentMargins
            if sheet.selectedDetentIdentifier == .large {
                update.edgesWithoutContentMargins?.subtract(.top)
            } else {
                update.edgesWithoutContentMargins?.formUnion(.top)
            }
            return update
        }())
    }
}

extension PresentFromSheetScenario: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        print("\(#function)")
        return .automatic
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("\(#function)")
        return .automatic
    }

    func presentationController(_ presentationController: UIPresentationController, prepare adaptivePresentationController: UIPresentationController) {
        print("\(#function)")
    }

    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        print("\(#function)")
        return nil
    }

    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        print("\(#function)")
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        print("\(#function)")
        return true
    }

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("\(#function)")
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("\(#function)")
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print("\(#function)")
    }
}
