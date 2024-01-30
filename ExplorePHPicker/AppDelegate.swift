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
    var title: String { get }
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
            config.text = (scenario.base as! any Scenario).title
            return config
        }()
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.apply({
            var snapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
            snapshot.appendSections([0])
            snapshot.appendItems([ModalPresentationScenario()])
            if #available(iOS 15, *) {
                snapshot.appendItems([SheetPresentationScenario()])
            }
            if #available(iOS 17, *) {
                snapshot.appendItems([CustomSheetPresentationScenario()])
            }
            if #available(iOS 17, *) {
                snapshot.appendItems([CustomSheetInteractionScenario()])
            }
            return snapshot
        }(), animatingDifferences: false)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (dataSource.itemIdentifier(for: indexPath)!.base as! any Scenario).start(from: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
