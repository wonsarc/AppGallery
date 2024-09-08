import UIKit

// MARK: - DisplayMode

enum DisplayMode: Int {
    case listNonInteractive = 0
    case listInteractive
    case fullScreen
}

// MARK: - MainViewController

final class MainViewController: UIViewController {

    // MARK: - Private Properties

    private var miniAppManager = MiniAppManager()
    private var currentMode: DisplayMode = .listNonInteractive
    private let tableView = UITableView()

    // MARK: - Overrides Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        miniAppManager.setupMiniApps(in: self)
        setupSegmentedControl()
        setupTableView()
        displayMiniApps()
    }

    // MARK: - Private Methods

    private func setupSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: ["List", "Interact", "Full"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        navigationItem.titleView = segmentedControl
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func displayMiniApps() {
        tableView.reloadData()
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        currentMode = DisplayMode(rawValue: sender.selectedSegmentIndex) ?? .listNonInteractive
        tableView.allowsSelection = currentMode != .listNonInteractive
        displayMiniApps()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return miniAppManager.miniApps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let miniAppView = miniAppManager.miniApps[indexPath.row].view
        setupMiniAppView(miniAppView, in: cell.contentView)

        return cell
    }

    private func setupMiniAppView(_ miniAppView: UIView, in contentView: UIView) {
        contentView.addSubview(miniAppView)
        miniAppView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            miniAppView.topAnchor.constraint(equalTo: contentView.topAnchor),
            miniAppView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            miniAppView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            miniAppView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        miniAppView.isUserInteractionEnabled = currentMode != .listNonInteractive
        contentView.clipsToBounds = true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = view.bounds.height - view.safeAreaInsets.top

        switch currentMode {
        case .listNonInteractive:
            return screenHeight / 8
        case .listInteractive:
            return screenHeight / 2
        case .fullScreen:
            return screenHeight
        }
    }
}
