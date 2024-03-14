import Foundation
import PhotosUI

class FullscreenWithPresentedBarScenario: NSObject, Scenario {
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

extension FullscreenWithPresentedBarScenario: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let controller = UIViewController()
        controller.view.backgroundColor = .systemGray
        controller.sheetPresentationController?.detents = [.custom(resolver: { context in
            100
        }), .medium()]
        controller.sheetPresentationController?.largestUndimmedDetentIdentifier = .medium
        picker.present(controller, animated: true)
    }
}
