import UIKit
import PhotosUI

@available(iOS 15, *)
class SheetPresentationScenario: NSObject, Scenario {
    let title = "Use Sheet Presentation (iOS 15)"

    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .ordered
        configuration.selectionLimit = 0
        configuration.edgesWithoutContentMargins = .all.subtracting(.top)

        let pickerController = PHPickerViewController(configuration: configuration)

        let sheet = pickerController.sheetPresentationController!
        sheet.detents = [.medium(), .large()]
        sheet.largestUndimmedDetentIdentifier = .medium
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersGrabberVisible = true

        fromController.present(pickerController, animated: true)
    }
}
