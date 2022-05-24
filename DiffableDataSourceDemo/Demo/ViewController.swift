import UIKit

final class ViewController: UIViewController {
    private enum Section {
        case main
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, CityModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, CityModel>

    private let searchBar = UISearchBar()

    private let allCities = MockService.allCityModels
    private var filteredCitites = MockService.allCityModels

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private lazy var dataSource = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        configureLayout()
        configureAppearance()
        bindViews()
    }

    func addViews() {
        navigationItem.titleView = searchBar

        view.addSubview(collectionView)
    }

    func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureAppearance() {
        view.backgroundColor = .white
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
    }

    func bindViews() {
        searchBar.searchTextField.addTarget(self, action: #selector(searchAction), for: .editingChanged)

        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseIdentifier)

        applySnapshot()
    }

    @objc private func searchAction() {
        let text = searchBar.text ?? ""
        filteredCitites = allCities.filter { $0.name.starts(with: text) }
        applySnapshot()
    }

    private func applySnapshot() {
        var snapshot = Snapshot()

        snapshot.appendSections([.main])
        snapshot.appendItems(filteredCitites, toSection: .main)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func createDataSource() -> DataSource {
        let cellProvider: DataSource.CellProvider = { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseIdentifier,
                                                          for: indexPath) as? CollectionCell

            cell?.configure(with: itemIdentifier.name)

            return cell
        }

        return DataSource(collectionView: collectionView, cellProvider: cellProvider)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .fractionalHeight(1.0)))

        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                         heightDimension: .absolute(44)),
                                                       subitem: item,
                                                       count: 2)

        let section = NSCollectionLayoutSection(group: group)

        return .init(section: section)
    }
}
