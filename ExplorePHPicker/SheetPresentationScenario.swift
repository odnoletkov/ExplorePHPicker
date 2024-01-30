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

        let pickerController = PHPickerViewController(configuration: configuration)
//        pickerController.delegate = self

        let sheet = pickerController.sheetPresentationController!
        sheet.detents = [.medium(), .large()]
        sheet.largestUndimmedDetentIdentifier = .medium
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersGrabberVisible = true
//        sheet.delegate = self

        fromController.present(pickerController, animated: true)
    }
}
