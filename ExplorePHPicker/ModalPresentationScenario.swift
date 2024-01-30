import UIKit
import PhotosUI

@available(iOS 14, *)
class ModalPresentationScenario: NSObject, Scenario {
    let title = "Use Modal Presentation (iOS 14)"

    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selectionLimit = 0

        let pickerController = PHPickerViewController(configuration: configuration)
        fromController.present(pickerController, animated: true)
    }
}
