import UIKit
import PhotosUI

@main
class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let controller = ScenarioSelectionController(nibName: nil, bundle: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = UINavigationController(rootViewController: controller)
        window!.makeKeyAndVisible()
        return true
    }
}

protocol Scenario: NSObjectProtocol {
    func start(from fromController: UIViewController)
}

class ScenarioSelectionController: UITableViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .insetGrouped)
    }

    typealias DataSource = UITableViewDiffableDataSource<Int, AnyHashable>

    required init?(coder: NSCoder) { fatalError() }

    lazy var dataSource: DataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, scenario in
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentConfiguration = {
            var config = UIListContentConfiguration.cell()
            config.text = .init(NSStringFromClass(type(of: scenario.base as! any Scenario)).trimmingPrefix(/ExplorePHPicker\./))
            return config
        }()
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.apply({
            var snapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
            snapshot.appendSections([0])
            snapshot.appendItems([PlainModalPresentationScenario()])
            snapshot.appendItems([PlainSheetPresentationControllerScenario()])
            snapshot.appendItems([SheetPresentationControllingPickerNavigationScenario()])
            snapshot.appendItems([CustomContainerPresentationScenario()])
            snapshot.appendItems([ToggleNavigationBarScenario()])
            snapshot.appendItems([ButtonsOverlayScenario()])
            snapshot.appendItems([SheetPresentationWithCustomInteractionScenario()])
            snapshot.appendItems([FullscreenWithCustomBarScenario()])
            snapshot.appendItems([FullscreenPlainScenario()])
            return snapshot
        }(), animatingDifferences: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        let index = ProcessInfo.processInfo.environment["START_SCENARIO_INDEX"].map { Int($0)! }
        if let index {
            tableView(tableView, didSelectRowAt: dataSource.indexPath(for: dataSource.snapshot().itemIdentifiers[index])!)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (dataSource.itemIdentifier(for: indexPath)!.base as! any Scenario).start(from: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
