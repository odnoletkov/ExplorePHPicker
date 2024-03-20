import UIKit
import PhotosUI
import Combine

class PrivateAPIOpenToSearchScenario: NSObject, Scenario {

    var cancellables: Set<AnyCancellable> = []

    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.mode = .default
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .ordered
        configuration.selectionLimit = 0
        configuration.edgesWithoutContentMargins = .all.subtracting(.top)
        configuration.disabledCapabilities = [
            .collectionNavigation,
        ]

        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        fromController.view.window?.tintColor = .label
        fromController.present(pickerController, animated: true)

        Timer
            .publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .compactMap { _ in pickerController.value(forKeyPath: "_extensionContext._auxiliaryConnection.remoteObjectProxy") as? AnyObject }
            .filter { !($0 is NSNull) }
            .first()
            .sink { _ = $0.perform(NSSelectorFromString("_searchWithString:"), with: "Dog") }
            .store(in: &cancellables)
    }
}

extension PrivateAPIOpenToSearchScenario: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(results)
        if results.isEmpty {
            picker.dismiss(animated: true)
        }
    }
}
