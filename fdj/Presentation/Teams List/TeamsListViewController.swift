import UIKit

typealias TeamsListView = TeamsListViewInputs & TeamsListViewOutputs

protocol TeamsListViewInputs: ViewInputs {
    func showActivityIndicator(shouldShow: Bool)

    func endEditingSearch()

    func showTableView(shouldShow: Bool)
    func updateTableViewItems(items: [String?])

    func showCollectionView(shouldShow: Bool)
    func updateCollectionViewItems(items: [URL?])
}

protocol TeamsListViewOutputs: ViewOutputs {
    var didBeginSearching: (() -> Void)? { get set }
    var searchTextDidChange: ((String?) -> Void)? { get set }
    var didEndSearching: (() -> Void)? { get set }

    var tableViewRowSelected: ((Int) -> Void)? { get set }

    var collectionViewItemSelected: ((Int) -> Void)? { get set }
}

final class TeamsListViewController: ViewController, TeamsListView {
    // MARK: Constants
    private let tableViewCellIdentifier = "tableViewCellIdentifier"

    private let collectionViewCellNibName = "TeamCollectionViewCell"
    private let collectionViewCellIdentifier = "collectionViewCellIdentifier"

    private let collectionViewSpacing: CGFloat = 10
    private lazy var cellSize = {
        let size = floor((collectionView.frame.size.width - 3 * collectionViewSpacing) / 2)

        return CGSize(width: size, height: size)
    }()

    // MARK: Outlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: Outputs
    var didBeginSearching: (() -> Void)?
    var searchTextDidChange: ((String?) -> Void)?
    var didEndSearching: (() -> Void)?

    var tableViewRowSelected: ((Int) -> Void)?

    var collectionViewItemSelected: ((Int) -> Void)?

    // MARK: Private properties
    private var tableViewItems: [String?] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private var collectionViewItems: [URL?] = [] {   /// We could argue here to have a [SomeCellViewModel] here instead but since it would only contain an URL I'm opting for simplicity
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }

    // MARK: Inputs
    /// ActivityIndicator
    func showActivityIndicator(shouldShow: Bool) {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = !shouldShow
        }
    }

    /// SearchBar
    func endEditingSearch() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }

    /// TableView
    func showTableView(shouldShow: Bool) {
        DispatchQueue.main.async {
            self.tableView.isHidden = !shouldShow
        }
    }

    func updateTableViewItems(items: [String?]) {
        tableViewItems = items
    }

    /// CollectionView
    func showCollectionView(shouldShow: Bool) {
        DispatchQueue.main.async {
            self.collectionView.isHidden = !shouldShow
        }
    }

    func updateCollectionViewItems(items: [URL?]) {
        collectionViewItems = items
    }

    // MARK: View setup
    private func setUpView() {
        setUpTableView()
        setUpCollectionView()
    }

    /// TableView
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
    }

    /// CollectionView
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib(nibName: collectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
    }
}

extension TeamsListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        didBeginSearching?()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextDidChange?(searchText)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        didEndSearching?()
    }
}

extension TeamsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier)!
        cell.textLabel?.text = tableViewItems[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewRowSelected?(indexPath.row)
    }
}

extension TeamsListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath)
        (cell as? TeamCollectionViewCell)?.imageURL = collectionViewItems[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionViewItemSelected?(indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewSpacing - 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewSpacing, left: collectionViewSpacing, bottom: -collectionViewSpacing, right: collectionViewSpacing)
    }
}
