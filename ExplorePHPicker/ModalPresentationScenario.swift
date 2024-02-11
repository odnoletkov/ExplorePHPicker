import UIKit
import PhotosUI

@available(iOS 14, *)
class ModalPresentationScenario: NSObject, Scenario {
    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selectionLimit = 0

        let pickerController = PHPickerViewController(configuration: configuration)
        fromController.present(pickerController, animated: true)
    }
}
