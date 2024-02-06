import UIKit
import PhotosUI

@available(iOS 17, *)
class ToggleNavigationBarScenario: NSObject, Scenario {
    let title = "Toggle Navigation Bar (iOS 17)"

    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.disabledCapabilities = [
            .stagingArea,
        ]
        configuration.filter = .images
        configuration.mode = .default
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .ordered
        configuration.selectionLimit = 0
        configuration.edgesWithoutContentMargins = .all.subtracting(.top)

        let pickerController = PHPickerViewController(configuration: configuration)
//        pickerController.delegate = self

        let hostingController = PickerNavigationBarHostingController()
        hostingController.pickerController = pickerController

        let navigationController = UINavigationController(rootViewController: hostingController)
        fromController.present(navigationController, animated: true)
    }
}

class PickerNavigationBarHostingController: UIViewController {

    var pickerController: PHPickerViewController!

    var topConstraint: NSLayoutConstraint!

    var pickerNavigationBarVisible = true {
        didSet {
            pickerController.navigationBarVisible = pickerNavigationBarVisible
            view.setNeedsUpdateConstraints()
        }
    }

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground

        addChild(pickerController)
        pickerController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerController.view)

        topConstraint = pickerController.view.topAnchor.constraint(equalTo: view.topAnchor)

        NSLayoutConstraint.activate([
            pickerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topConstraint,
            pickerController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        pickerController.didMove(toParent: self)

        navigationItem.titleView = {
            let s = UISwitch()
            s.isOn = true
            s.addTarget(self, action: #selector(Self.toggle), for: .valueChanged)
            return s
        }()
    }

    @objc func toggle(sender: UISwitch) {
        pickerNavigationBarVisible = sender.isOn
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        let expectedPickerNavigationBarHeight = 56 as Double
        topConstraint.constant = 100 + (pickerNavigationBarVisible ? 0 : expectedPickerNavigationBarHeight)
    }
}
