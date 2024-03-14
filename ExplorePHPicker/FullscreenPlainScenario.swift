import UIKit
import PhotosUI

@available(iOS 14, *)
class FullscreenPlainScenario: NSObject, Scenario {
    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.mode = .default
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .ordered
        configuration.selectionLimit = 0
        configuration.edgesWithoutContentMargins = .all.subtracting(.top)
        configuration.disabledCapabilities = [
//            .selectionActions,
        ]

        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        pickerController.view.tintColor = .label
        fromController.present(pickerController, animated: true)
    }
}

extension FullscreenPlainScenario: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(results)
        if results.isEmpty {
            picker.dismiss(animated: true)
        }
    }
}
