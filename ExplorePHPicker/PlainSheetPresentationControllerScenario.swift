import UIKit
import PhotosUI

class PlainSheetPresentationControllerScenario: NSObject, Scenario {
    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selection = .ordered
        configuration.selectionLimit = 0
//        configuration.edgesWithoutContentMargins = .bottom

        let pickerController = PHPickerViewController(configuration: configuration)

        let sheet = pickerController.sheetPresentationController!
        sheet.detents = [.medium(), .large()]
        sheet.largestUndimmedDetentIdentifier = .medium
        sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        sheet.prefersGrabberVisible = true

        fromController.present(pickerController, animated: true)
    }
}
