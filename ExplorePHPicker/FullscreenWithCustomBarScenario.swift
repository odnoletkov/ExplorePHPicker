import UIKit
import PhotosUI

@available(iOS 14, *)
class FullscreenWithCustomBarScenario: NSObject, Scenario {
    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.mode = .default
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .continuousAndOrdered
        configuration.selectionLimit = 0
        configuration.edgesWithoutContentMargins = .all.subtracting(.top)
        configuration.disabledCapabilities = [
            .selectionActions,
        ]

        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        pickerController.view.tintColor = .label

        let hostingController = FullscreenContainerController()
        hostingController.pickerController = pickerController
        fromController.present(hostingController, animated: true)
    }
}

extension FullscreenWithCustomBarScenario: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(results)
        if results.isEmpty {
            picker.dismiss(animated: true)
        }
    }
}

class FullscreenContainerController: UIViewController {

    var pickerController: PHPickerViewController!

    var topConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground

        addChild(pickerController)
        pickerController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerController.view)
        NSLayoutConstraint.activate([
            pickerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pickerController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -114),
        ])
        pickerController.didMove(toParent: self)

        let barController = PickerBarController()
        addChild(barController)
        barController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barController.view)
        NSLayoutConstraint.activate([
            barController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barController.view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -114),
            barController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        barController.didMove(toParent: self)
    }
}

class PickerBarController: UIViewController {

//    override func loadView() {
//        view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
//        view.isUserInteractionEnabled = true
//    }

    override func loadView() {
        view = UIToolbar()
    }

    var toolbar: UIToolbar { view as! UIToolbar }

    override func viewDidLoad() {
        toolbar.items = [
            .init(systemItem: .cancel, primaryAction: .init { [unowned self] _ in
                dismiss(animated: true)
            }),
            .flexibleSpace(),
            .init(customView: {
                let label = UILabel()
                label.textAlignment = .center
                label.font = .preferredFont(forTextStyle: .headline)
                label.text = "Custom Bar"
                return label
            }()),
            .flexibleSpace(),
            .init(image: .init(systemName: "paperplane.circle.fill"), primaryAction: .init { [unowned self] _ in
                dismiss(animated: true)
            }),
        ]
    }
}
