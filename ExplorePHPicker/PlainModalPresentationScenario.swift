import UIKit
import PhotosUI

class PlainModalPresentationScenario: NSObject, Scenario {
    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selectionLimit = 0

        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        fromController.present(pickerController, animated: true)
    }
}

extension PlainModalPresentationScenario: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let result = PHAsset.fetchAssets(
            withLocalIdentifiers: results.compactMap(\.assetIdentifier),
            options: nil
        )
        let phAssets = (0 ..< result.count).map(result.object(at:))
        print(phAssets)
    }
}
