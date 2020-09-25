//
//  ChooseBeerCell.swift
//  MyBeer
//
//  Created by Алексей Смицкий on 24.09.2020.
//

import UIKit

// MARK: - ChooseBeerCell

final class ChooseBeerCell: UITableViewCell {
    
    // MARK: - Public properties
    
    public var cellData: ChooseBeerModel? {
        didSet {
            guard let mainData = cellData,
                  let beerImageURL = URL(string: "\(mainData.image_url ?? Constants.emptyString)"),
                  let beerName = mainData.name else { return }
            beerNameLabel.text = beerName
            beerImage.parseImage(url: beerImageURL)
        }
    }
    
    // MARK: - Private properties
    
    private lazy var beerImage = UIImageView()
    private lazy var beerNameLabel = UILabel()
    
    // MARK: - Initalization
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setupViews()
        addViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.errorText)
    }
}

// MARK: - Setups

extension ChooseBeerCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        darkModeSettings()
    }
}

private extension ChooseBeerCell {
    
    func setupViews() {
        setBeerLabel()
        setBeerImage()
        darkModeSettings()
    }
    
    func setBeerLabel() {
        beerNameLabel.font = Constants.fontSize
        beerNameLabel.textAlignment = .center
    }
    
    func setBeerImage() {
        beerImage.contentMode = .scaleAspectFit
        beerImage.layer.cornerRadius = Constants.imageRadius
    }
    
    func darkModeSettings() {
        if traitCollection.userInterfaceStyle == .dark {
            contentView.backgroundColor = .black
            beerNameLabel.textColor = .white
            beerImage.backgroundColor = .systemGray3
        } else {
            contentView.backgroundColor = .white
            beerNameLabel.textColor = .black
            beerImage.backgroundColor = .systemGray6
        }
    }
}

// MARK: - Setup Elements

private extension ChooseBeerCell {
    
    func addViews() {
        addSubview(beerNameLabel)
        addSubview(beerImage)
    }
}

// MARK: - Layout

private extension ChooseBeerCell {
    
    func layout() {
        
        beerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        beerNameLabel.centerXAnchor.constraint(
                                            equalTo: centerXAnchor),
                                        beerNameLabel.leadingAnchor.constraint(
                                            equalTo: leadingAnchor),
                                        beerNameLabel.trailingAnchor.constraint(
                                            equalTo: trailingAnchor),
                                        beerNameLabel.heightAnchor.constraint(
                                            equalToConstant: Constants.beerNameLabelHeightAncor)])
        
        beerImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        beerImage.topAnchor.constraint(
                                            equalTo: beerNameLabel.bottomAnchor,
                                            constant: Constants.beerImageTopAncor),
                                        beerImage.centerXAnchor.constraint(
                                            equalTo: centerXAnchor),
                                        beerImage.widthAnchor.constraint(
                                            equalToConstant: Constants.beerImageWidthAncor),
                                        beerImage.heightAnchor.constraint(
                                            equalToConstant: Constants.beerImageHeightAncor)])
    }
}

// MARK: - Constants

private enum Constants {
    
    static let emptyString: String = ""
    static let errorText: String = "Error"
    
    static let beerNameLabelHeightAncor: CGFloat = 40
    
    static let beerImageTopAncor: CGFloat = 2
    static let beerImageWidthAncor: CGFloat = 250
    static let beerImageHeightAncor: CGFloat = 250
    
    static let fontSize: UIFont = .boldSystemFont(ofSize: 15)
    static let imageRadius: CGFloat = 15
}
