import UIKit
import PhotosUI

@available(iOS 27.0, *)
class SearchTextScenario: NSObject, Scenario {
    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.searchText = PHPickerSearchText(" ")

        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        fromController.present(pickerController, animated: true)
    }
}

@available(iOS 27.0, *)
extension SearchTextScenario: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(results)
        if results.isEmpty {
            picker.dismiss(animated: true)
        }
    }
}
