//
//  BeerDetailController.swift
//  MyBeer
//
//  Created by Алексей Смицкий on 24.09.2020.
//

import UIKit

// MARK: - BeerDetailController

final class BeerDetailController: UIViewController {
    
    // MARK: - Public properties
    
    public lazy var beerID = Int()
    
    // MARK: - Private properties
    
    private lazy var beerNameLabel = UILabel()
    private lazy var beerImage = UIImageView()
    private lazy var beerInfo = UITextView()
    private lazy var beerRatingLabel = UILabel()
    private lazy var beerRating = UILabel()
    private lazy var ABVLabel = UILabel()
    private lazy var ABV = UILabel()
    private lazy var IBULabel = UILabel()
    private lazy var IBU = UILabel()
    private lazy var results = [BeerDetailModel]()
    private lazy var internetCheck: IReachability = Reachability()
    private var parsingResults: INetworkLayer?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupViews()
        addViews()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        darkModeSettings()
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
        parsingResults?.getBeerInfo(
            api: URLList.selectedBeer + "\(beerID)", complition:
                { [weak self] item in
                    guard let self = self else { return }
                    
                    self.results = item
                    DispatchQueue.main.async {
                        guard let imageURL = URL(string: item.first?.image_url ?? Constants.emptyString)
                        else { return }
                        self.beerNameLabel.text = item.first?.name
                        self.beerImage.parseImage(url: imageURL)
                        self.beerInfo.text = item.first?.description
                        self.beerRating.text = "\(item.first?.attenuation_level ?? Constants.emptyDouble)"
                        self.ABV.text = "\(item.first?.abv ?? Constants.emptyDouble)"
                        self.IBU.text = "\(item.first?.ibu ?? Constants.emptyInt)"
                    }
                })
    }
    
    // MARK: - Selectors
    
    @objc
    private func shareBeer() {
        let items =
            ["\(Constants.tryBeer)" + "\(results.first?.name ?? Constants.emptyString)" + "\(Constants.itsCool)"]
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
}

// MARK: - Setups

extension BeerDetailController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        darkModeSettings()
    }
}

private extension BeerDetailController {
    
    func setupViews() {
        setBeerName()
        setbeerImage()
        setBeerInfo()
        setBeerRatingLabel()
        setNaviBar()
        setABVLabel()
        setIBULabel()
    }
    
    func setBeerName() {
        beerNameLabel.font = Constants.fontSize
        beerNameLabel.textAlignment = .center
    }
    
    func setbeerImage() {
        beerImage.contentMode = .scaleAspectFit
        beerImage.layer.cornerRadius = Constants.cornerRadius
    }
    
    func setBeerInfo() {
        beerInfo.font = Constants.fontSize
        beerInfo.isEditable = false
        beerInfo.layer.cornerRadius = Constants.cornerRadius
    }
    
    func setBeerRatingLabel() {
        beerRatingLabel.text = Constants.beerRatingText
        beerRatingLabel.font = Constants.fontSize
        beerRating.font = Constants.fontSize
    }
    
    func setNaviBar() {
        title = Constants.titleText
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareBeer))
    }
    
    func setABVLabel() {
        ABVLabel.text = Constants.ABVText
        ABVLabel.font = Constants.fontSize
        ABV.font = Constants.fontSize
    }
    
    func setIBULabel() {
        IBULabel.text = Constants.IBUText
        IBULabel.font = Constants.fontSize
        IBU.font = Constants.fontSize
    }
    
    func darkModeSettings() {
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
            beerNameLabel.textColor = .white
            beerRatingLabel.textColor = .white
            beerRating.textColor = .white
            beerInfo.textColor = .white
            ABVLabel.textColor = .white
            ABV.textColor = .white
            IBULabel.textColor = .white
            IBU.textColor = .white
            beerImage.backgroundColor = .systemGray3
            beerInfo.backgroundColor = .systemGray3
        } else {
            view.backgroundColor = .white
            beerNameLabel.textColor = .darkGray
            beerRatingLabel.textColor = .darkGray
            beerRating.textColor = .darkGray
            beerInfo.textColor = .darkGray
            ABVLabel.textColor = .darkGray
            ABV.textColor = .darkGray
            IBULabel.textColor = .darkGray
            IBU.textColor = .darkGray
            beerImage.backgroundColor = .systemGray6
            beerInfo.backgroundColor = .systemGray6
        }
    }
}

// MARK: - Setup Elements

private extension BeerDetailController {
    
    func addViews() {
        view.addSubview(beerNameLabel)
        view.addSubview(beerImage)
        view.addSubview(beerInfo)
        view.addSubview(beerRatingLabel)
        view.addSubview(beerRating)
        view.addSubview(ABVLabel)
        view.addSubview(ABV)
        view.addSubview(IBULabel)
        view.addSubview(IBU)
    }
}

// MARK: - Layout

private extension BeerDetailController {
    
    func layout() {
        
        beerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        beerNameLabel.centerXAnchor.constraint(
                                            equalTo: view.centerXAnchor),
                                        beerNameLabel.topAnchor.constraint(
                                            equalTo: view.safeAreaLayoutGuide.topAnchor),
                                        beerNameLabel.leadingAnchor.constraint(
                                            equalTo: view.leadingAnchor),
                                        beerNameLabel.trailingAnchor.constraint(
                                            equalTo: view.trailingAnchor),
                                        beerNameLabel.heightAnchor.constraint(
                                            equalToConstant: Constants.beerNameLabelHeightAncor)])
        
        beerImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        beerImage.topAnchor.constraint(
                                            equalTo: beerNameLabel.bottomAnchor,
                                            constant: Constants.beerImageTopAncor),
                                        beerImage.centerXAnchor.constraint(
                                            equalTo: view.centerXAnchor),
                                        beerImage.widthAnchor.constraint(
                                            equalToConstant: Constants.beerImageWidthAncor),
                                        beerImage.heightAnchor.constraint(
                                            equalToConstant: view.bounds.height / Constants.boundHeightThree)])
        
        beerInfo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        beerInfo.topAnchor.constraint(
                                            equalTo: beerImage.bottomAnchor,
                                            constant: Constants.beerInfoTopAncor),
                                        beerInfo.centerXAnchor.constraint(
                                            equalTo: view.centerXAnchor),
                                        beerInfo.leadingAnchor.constraint(
                                            equalTo: view.leadingAnchor),
                                        beerInfo.trailingAnchor.constraint(
                                            equalTo: view.trailingAnchor),
                                        beerInfo.heightAnchor.constraint(
                                            equalToConstant: view.bounds.height / Constants.boundHeightFive)])
        
        beerRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        beerRatingLabel.topAnchor.constraint(
                                            equalTo: beerInfo.bottomAnchor,
                                            constant: Constants.beerRatingLabelTopAncor),
                                        beerRatingLabel.leadingAnchor.constraint(
                                            equalTo: view.leadingAnchor)])
        
        beerRating.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        beerRating.topAnchor.constraint(
                                            equalTo: beerInfo.bottomAnchor,
                                            constant: Constants.parametersSpacing),
                                        beerRating.centerYAnchor.constraint(
                                            equalTo: beerRatingLabel.centerYAnchor),
                                        beerRating.leadingAnchor.constraint(
                                            equalTo: beerRatingLabel.trailingAnchor)])
        
        ABVLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        ABVLabel.topAnchor.constraint(
                                            equalTo: beerRatingLabel.bottomAnchor,
                                            constant: Constants.parametersSpacing),
                                        ABVLabel.leadingAnchor.constraint(
                                            equalTo: view.leadingAnchor)])
        
        ABV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        ABV.topAnchor.constraint(
                                            equalTo: beerRating.bottomAnchor,
                                            constant: Constants.parametersSpacing),
                                        ABV.centerYAnchor.constraint(
                                            equalTo: ABVLabel.centerYAnchor),
                                        ABV.leadingAnchor.constraint(
                                            equalTo: ABVLabel.trailingAnchor)])
        
        IBULabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        IBULabel.topAnchor.constraint(
                                            equalTo: ABVLabel.bottomAnchor,
                                            constant: Constants.parametersSpacing),
                                        IBULabel.leadingAnchor.constraint(
                                            equalTo: view.leadingAnchor)])
        
        IBU.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        IBU.topAnchor.constraint(
                                            equalTo: ABV.bottomAnchor,
                                            constant: Constants.parametersSpacing),
                                        IBU.centerYAnchor.constraint(
                                            equalTo: IBULabel.centerYAnchor),
                                        IBU.leadingAnchor.constraint(
                                            equalTo: IBULabel.trailingAnchor)])
    }
}

// MARK: - Constants

private enum Constants {
    
    static let titleText: String = "Selected beer"
    static let beerRatingText: String = "Beer rating: "
    static let fontSize: UIFont = .boldSystemFont(ofSize: 15)
    
    static let beerNameLabelHeightAncor: CGFloat = 40
    
    static let beerImageTopAncor: CGFloat = 2
    static let beerImageWidthAncor: CGFloat = 200
    static let beerImageHeightAncor: CGFloat = 200
    
    static let beerInfoTopAncor: CGFloat = 10
    static let beerInfoHeightAncor: CGFloat = 150
    
    static let beerRatingLabelTopAncor: CGFloat = 10
    static let beerRatingTopAncor: CGFloat = 10
    
    static let parametersSpacing: CGFloat = 3
    
    static let ABVText: String = "ABV: "
    static let IBUText: String = "IBU: "
    
    static let boundHeightFive: CGFloat = 5
    static let boundHeightThree: CGFloat = 3
    
    static let alertTitle: String = "Warning!"
    static let alertMessage: String =
        "No internet connection, please check your internet connection and restart the app!"
    
    static let emptyString: String = ""
    static let emptyDouble: Double = 0.0
    static let emptyInt: Int = 0
    static let cornerRadius: CGFloat = 15
    
    static let tryBeer: String = "Try this beer: "
    static let itsCool: String = ", i think its cool!"
}
