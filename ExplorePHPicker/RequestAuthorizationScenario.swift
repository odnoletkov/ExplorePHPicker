import UIKit
import PhotosUI

class RequestAuthorizationScenario: NSObject, Scenario {
    func start(from fromController: UIViewController) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            print("\(status)")
        }
    }
}
