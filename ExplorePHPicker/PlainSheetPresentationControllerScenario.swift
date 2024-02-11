import UIKit
import PhotosUI

@available(iOS 15, *)
class PlainSheetPresentationControllerScenario: NSObject, Scenario {
    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.disabledCapabilities = [
            .stagingArea,
//            .selectionActions,
        ]
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .continuousAndOrdered
        configuration.selectionLimit = 0
        configuration.edgesWithoutContentMargins = .all.subtracting(.top)

        let pickerController = PHPickerViewController(configuration: configuration)

        let sheet = pickerController.sheetPresentationController!
        sheet.detents = [.medium(), .large()]
        sheet.largestUndimmedDetentIdentifier = .medium
        sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        sheet.prefersGrabberVisible = true

        fromController.present(pickerController, animated: true)
    }
}
