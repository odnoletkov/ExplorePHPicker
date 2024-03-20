import UIKit
import PhotosUI

class UIImagePickerControllerScenario: NSObject, Scenario {
    func start(from fromController: UIViewController) {
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        pickerController.delegate = self
        fromController.view.window?.tintColor = .systemGreen
        fromController.present(pickerController, animated: true)
    }
}

extension UIImagePickerControllerScenario: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
    }
}
