//
//  ChooseBeerController.swift
//  MyBeer
//
//  Created by Алексей Смицкий on 24.09.2020.
//

import UIKit

// MARK: - ChooseBeerController

final class ChooseBeerController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var beerTableView = UITableView()
    private lazy var refreshControll = UIRefreshControl()
    private lazy var loadingActivity = UIActivityIndicatorView()
    private lazy var results = [ChooseBeerModel]()
    private lazy var internetCheck: IReachability = Reachability()
    private var parsingResults: INetworkLayer?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addViews()
        addActions()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkInternet()
    }
    
    // MARK: - Private methods
    
    private func checkInternet() {
        if !internetCheck.isConnectedToNetwork {
            alert(title: Constants.alertTitle,
                  message: Constants.alertMessage)
        }
    }
    
    private func loadData() {
        parsingResults = NetworkLayer()
        parsingResults?.getBeerList(
            api: URLList.beerListURL + URLList.beerPageType + "\(Constants.rowsLimit)", complition:
                { [weak self] item in
                    guard let self = self else { return }
                    
                    self.results = item
                    DispatchQueue.main.async {
                        self.beerTableView.reloadData()
                    }
                })
    }
    
    // MARK: - Selectors
    
    @objc
    private func refresh() {
        loadData()
        beerTableView.reloadData()
        refreshControll.endRefreshing()
    }
}

// MARK: - Setups

extension ChooseBeerController: UITableViewDelegate { }

extension ChooseBeerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
                as? ChooseBeerCell else { return UITableViewCell() }
        cell.cellData = self.results[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (Constants.rowsLimit - Constants.lastRow) {
            loadingActivity.startAnimating()
            loadingActivity.frame = CGRect(x: Constants.activityX,
                                           y: Constants.activityY,
                                           width: tableView.bounds.width,
                                           height: Constants.activityHeight)
            
            if Constants.rowsLimit <= Constants.rowsMax {
                Constants.rowsLimit += Constants.rowsAdd
                loadData()
                beerTableView.tableFooterView = loadingActivity
                beerTableView.tableFooterView?.isHidden = false
            }
        } else if Constants.rowsLimit == Constants.rowsOver {
            loadingActivity.stopAnimating()
            beerTableView.tableFooterView?.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let beerDetailController = BeerDetailController()
        beerDetailController.beerID = results[indexPath.row].id ?? Constants.emptyInt
        navigationController?.pushViewController(beerDetailController, animated: true)
    }
}

private extension ChooseBeerController {
    
    func setupViews() {
        setTableView()
        setJSON()
        setNaviBar()
    }
    
    func setTableView() {
        beerTableView.register(ChooseBeerCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        beerTableView.dataSource = self
        beerTableView.delegate = self
        beerTableView.rowHeight = Constants.rowHeight
    }
    
    func setJSON() {
        loadData()
    }
    
    func setNaviBar() {
        title = Constants.titleText
    }
}

// MARK: - Setup Elements

private extension ChooseBeerController {
    
    func addViews() {
        view.addSubview(beerTableView)
        beerTableView.addSubview(refreshControll)
    }
    
    func addActions() {
        refreshControll.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}

// MARK: - Layout

private extension ChooseBeerController {
    
    func layout() {
        
        beerTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        beerTableView.topAnchor.constraint(
                                            equalTo: view.safeAreaLayoutGuide.topAnchor),
                                        beerTableView.leadingAnchor.constraint(
                                            equalTo: view.leadingAnchor),
                                        beerTableView.trailingAnchor.constraint(
                                            equalTo: view.trailingAnchor),
                                        beerTableView.bottomAnchor.constraint(
                                            equalTo: view.bottomAnchor)])
    }
}

// MARK: - Constants

private enum Constants {
    
    static let cellIdentifier: String = "chooseBeer"
    static let emptyString: String = ""
    static let emptyDouble: Double = 0.0
    static let emptyInt: Int = 0
    static let titleText: String = "Choose beer"
    static let rowHeight: CGFloat = 300
    static let lastRow: Int = 1
    
    static let alertTitle: String = "Warning!"
    static let alertMessage: String =
        "No internet connection, please check your internet connection and restart the app!"
    
    static var rowsLimit: Int = 20
    static let rowsAdd: Int = 30
    static let rowsMax: Int = 70
    static let rowsOver: Int = 80
    
    static let activityX: CGFloat = 0
    static let activityY: CGFloat = 0
    static let activityHeight: CGFloat = 144
}
