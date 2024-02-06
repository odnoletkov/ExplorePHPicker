import UIKit
import PhotosUI
import SheetInteraction

let detents = [
    UISheetPresentationController.Detent.custom { _ in 300 },
    .large(),
]

@available(iOS 17, *)
class CustomSheetInteractionScenario: NSObject, Scenario {
    let title = "Custom Sheet Interaction (iOS 17)"

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
        configuration.edgesWithoutContentMargins = .all

        let pickerController = PHPickerViewController(configuration: configuration)
//        pickerController.delegate = self

        let hostingController = PickerHostingController()
        hostingController.hostedController = pickerController

        if let sheet = hostingController.sheetPresentationController {
            sheet.detents = detents
//            sheet.prefersGrabberVisible = true
        }

        fromController.present(hostingController, animated: true)
    }
}

class PickerHostingController: UIViewController {

    var hostedController: UIViewController!

    private lazy var sheetInteraction: SheetInteraction = .init(sheet: sheetPresentationController!, sheetView: view)

    var topConstraint: NSLayoutConstraint!

    var transitionPercentage: Double = 0 {
        didSet {
            view.setNeedsUpdateConstraints()
        }
    }
    var applyInsetForNavigationBar = false {
        didSet {
            view.setNeedsUpdateConstraints()
        }
    }

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground

        addChild(hostedController)
        hostedController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostedController.view)

        topConstraint = hostedController.view.topAnchor.constraint(equalTo: view.topAnchor)

        NSLayoutConstraint.activate([
            hostedController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostedController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topConstraint,
            hostedController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        hostedController.didMove(toParent: self)

        sheetInteraction.delegate = self
        sheetInteraction.sheetInteractionGesture.delegate = self
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        let insetForNavigationBar = 54 as Double
        topConstraint.constant = 20 + (applyInsetForNavigationBar ? 0 : insetForNavigationBar * transitionPercentage)
    }
}

extension PickerHostingController: SheetStackInteractionForwardingBehavior {
    func shouldHandleSheetInteraction() -> Bool {
        return true
    }
}

extension PickerHostingController: SheetInteractionDelegate {
    func sheetInteractionBegan(sheetInteraction: SheetInteraction, at detent: DetentIdentifier) {
//        print("\(#function): \(detent)")
    }
    
    func sheetInteractionChanged(sheetInteraction: SheetInteraction, interactionChange: SheetInteraction.Change) {
//        print("\(#function): \(interactionChange)")
        transitionPercentage = interactionChange.percentageTotal
    }
    
    func sheetInteractionWillEnd(sheetInteraction: SheetInteraction, targetDetentInfo: SheetInteraction.Change.Info, targetPercentageTotal: CGFloat, onTouchUpPercentageTotal: CGFloat) {
//        print("\(#function): \(targetDetentInfo), \(targetPercentageTotal), \(onTouchUpPercentageTotal)")
//        transitionPercentage = targetPercentageTotal


    }
    
    func sheetInteractionDidEnd(sheetInteraction: SheetInteraction, selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier) {
//        print("\(#function): \(selectedDetentIdentifier)")

        let isExpanded = selectedDetentIdentifier == detents.last!.identifier
        let pickerController = hostedController as! PHPickerViewController
        pickerController.navigationBarVisible = isExpanded
        applyInsetForNavigationBar = isExpanded
    }
    
    func sheetInteractionShouldDismiss(sheetInteraction: SheetInteraction) -> Bool {
        true
    }
}

extension PickerHostingController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer == sheetInteraction.sheetInteractionGesture
    }
}

extension PHPickerViewController {
    var navigationBarVisible: Bool {
        get {
            !configuration.edgesWithoutContentMargins.contains(.top)
        }
        set {
            updatePicker(using: {
                var update = PHPickerConfiguration.Update()
                update.edgesWithoutContentMargins = configuration.edgesWithoutContentMargins
                if newValue {
                    update.edgesWithoutContentMargins?.subtract(.top)
                } else {
                    update.edgesWithoutContentMargins?.formUnion(.top)
                }
                return update
            }())
        }
    }
}
