import UIKit
import PhotosUI

@available(iOS 17, *)
class CustomButtonsScenario: NSObject, Scenario {
    let title = "Custom Buttons (iOS 15)"

    func start(from fromController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.disabledCapabilities = [
            .stagingArea,
//            .selectionActions,
        ]
        configuration.filter = .images
        configuration.mode = .default
        configuration.preferredAssetRepresentationMode = .automatic
        configuration.selection = .continuousAndOrdered
        configuration.selectionLimit = 0
        configuration.edgesWithoutContentMargins = .all.subtracting(.top)
//        configuration.preselectedAssetIdentifiers = ["non"]

        configuration.preselectedAssetIdentifiers = [
            "ED7AC36B-A150-4C38-BB8C-B6D696F4F2ED/L0/001",
            "99D53A1F-FEEF-40E1-8BB3-7DD55A43C8B7/L0/001",
        ]

        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self

//        pickerController.view.tintColor = .clear

        let hostingController = PickerHostingController()
        hostingController.hostedController = pickerController

        if let sheet = hostingController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }

        fromController.present(hostingController, animated: true)
    }
}

@available(iOS 17, *)
extension CustomButtonsScenario: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(results)
//        picker.deselectAssets(withIdentifiers: results.compactMap(\.assetIdentifier))
//        picker.moveAsset(withIdentifier: results[1].assetIdentifier!, afterAssetWithIdentifier: results[0].assetIdentifier!)
    }
}

private class PickerHostingController: UIViewController {

    var hostedController: PHPickerViewController!

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground

        addChild(hostedController)
        hostedController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostedController.view)

        NSLayoutConstraint.activate([
            hostedController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostedController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostedController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostedController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        hostedController.didMove(toParent: self)

        let topView = PointInsideView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = .yellow.withAlphaComponent(0)
        topView.isUserInteractionEnabled = true
        view.addSubview(topView)
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            // below 53 selection works with non-0 alpha
            // 193+ selection breaks even with 0 alpha
            topView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 96),
        ])

        let button = UIButton()
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Button", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(Self.tap), for: .touchUpInside)
//        topView.isUserInteractionEnabled = false
        topView.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -100),
            button.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            button.topAnchor.constraint(equalTo: topView.topAnchor),
            button.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
        ])

        let button2 = UIButton()
        button2.backgroundColor = .green
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setTitle("Button", for: .normal)
        button2.setTitleColor(UIColor.label, for: .normal)
        button2.addTarget(self, action: #selector(Self.tap), for: .touchUpInside)
//        topView.isUserInteractionEnabled = false
        topView.addSubview(button2)
        NSLayoutConstraint.activate([
            button2.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 80),
            button2.trailingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 100 + 80),
            button2.topAnchor.constraint(equalTo: topView.topAnchor),
            button2.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
        ])
    }

    @objc func tap() {
        print("tap")
    }
}

class PointInsideView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print(point)
        return super.point(inside: point, with: event)
    }
}
