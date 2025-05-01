//
//  CardTableViewCell.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 30.04.2025.
//

import UIKit
import Kingfisher

protocol CardTableViewCellDelegate: AnyObject {
  func didSelect(_ cell: CardTableViewCell)
}

final class CardTableViewCell: UITableViewCell {
  private lazy var contentContainer = createContentContainer()
  private lazy var avatarImageView = createAvatarImageView()
  private lazy var avatarImageViewHeight = NSLayoutConstraint(item: avatarImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
  private lazy var titlesVStack = createTitlesVStack()
  
  private lazy var nameLabel = createNameLabel()
  private lazy var statusDot = createStatusDot()
  private lazy var statusLabel = createStatusLabel()
  private lazy var locationLabel = createLocationLabel()
  
  private weak var delegate: CardTableViewCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
    guard selected else { return }
    contentContainer.springAnimation { [weak self] in
      guard let self else { return }
      delegate?.didSelect(self)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentContainer.setNeedsLayout()
    contentContainer.layoutIfNeeded()
    
    avatarImageViewHeight.constant = contentContainer.frame.height
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    avatarImageView.image = nil
  }
  
  private func setupUI() {
    selectionStyle = .none
    
    contentView.addSubview(contentContainer)
    contentContainer.fillToSuperview(verticalIndents: Constants.containerVIndent)
    
    contentContainer.addSubview(avatarImageView)
    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    avatarImageView.widthAnchor.constraint(equalTo: contentContainer.widthAnchor, multiplier: 0.33).isActive = true
    avatarImageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor).isActive = true
    avatarImageViewHeight.isActive = true
    avatarImageView.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor).isActive = true
    
    contentContainer.addSubview(titlesVStack)
    titlesVStack.translatesAutoresizingMaskIntoConstraints = false
    titlesVStack.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: Constants.titlesVStackVIndent).isActive = true
    titlesVStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.titlesVStackHIndent).isActive = true
    titlesVStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -Constants.titlesVStackHIndent).isActive = true
    titlesVStack.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -Constants.titlesVStackVIndent).isActive = true
    
    for type in InfoType.allCases {
      let titleVStack = createVStack(for: type)
      titlesVStack.addArrangedSubview(titleVStack)
    }
  }
  
  func setupCell(with info: ResultDTO, delegate: CardTableViewCellDelegate?) {
    self.delegate = delegate
    
    nameLabel.text = info.name
    
    let statusText: String
    if let species = info.species {
      statusText = info.status.rawValue + " - " + species
    } else {
      statusText = info.status.rawValue
    }
    statusLabel.text = statusText
    
    locationLabel.text = info.location.name
    
    setupColorTheme(according: info)
    setupImages(according: info)
  }
}

//MARK: - UI elements creating
private extension CardTableViewCell {
  func createContentContainer() -> UIView {
    let view = UIView()
    view.backgroundColor = AppColor.cardBg
    view.cornerRadius = Constants.baseSideIndent
    
    return view
  }
  
  func createAvatarImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .center
    imageView.clipsToBounds = true
    
    return imageView
  }
  
  func createTitlesVStack() -> UIStackView {
    let vStack = UIStackView()
    vStack.axis = .vertical
    vStack.spacing = Constants.titlesVStackSpacing
    
    return vStack
  }
  
  func createNameLabel() -> UILabel {
    let label = UILabel()
    label.font = Constants.nameLabelFont
    label.textColor = AppColor.mainText
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    
    return label
  }
  func createStatusDot() -> UIView {
    let dot = UIView()
    dot.translatesAutoresizingMaskIntoConstraints = false
    dot.widthAnchor.constraint(equalToConstant: Constants.subTitlesVStackSpacing).isActive = true
    dot.heightAnchor.constraint(equalToConstant: Constants.subTitlesVStackSpacing).isActive = true
    dot.cornerRadius = Constants.containerVIndent
    
    return dot
  }
  func createStatusLabel() -> UILabel {
    let label = UILabel()
    label.font = Constants.labelFont
    label.textColor = AppColor.mainText
    
    return label
  }
  
  func createLocationTitle() -> UILabel {
    let label = UILabel()
    label.text = MainTitles.locationTitle.localized + ":"
    label.font = Constants.titleFont
    label.textColor = AppColor.additionalText
    
    return label
  }
  func createLocationLabel() -> UILabel {
    let label = UILabel()
    label.font = Constants.labelFont
    label.textColor = AppColor.mainText
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    
    return label
  }
  
  func moreInfoTitle() -> UILabel {
    let label = UILabel()
    label.text = MainTitles.moreInfo.localized
    label.font = Constants.titleFont
    label.textColor = AppColor.additionalText
    
    return label
  }
  
  enum InfoType: Int, CaseIterable {
    case main = 0
    case location
    case firstSeen
  }
  func createVStack(for type: InfoType) -> UIStackView {
    let vStack = UIStackView()
    vStack.axis = .vertical
    vStack.spacing = Constants.subTitlesVStackSpacing
    
    switch type {
      
    case .main:
      vStack.addArrangedSubview(nameLabel)
      
      let additionalHStack = UIStackView()
      additionalHStack.axis = .horizontal
      additionalHStack.spacing = Constants.subTitlesVStackSpacing
      additionalHStack.alignment = .center
      
      additionalHStack.addArrangedSubview(statusDot)
      additionalHStack.addArrangedSubview(statusLabel)
      
      vStack.addArrangedSubview(additionalHStack)
    case .location:
      vStack.addArrangedSubview(createLocationTitle())
      vStack.addArrangedSubview(locationLabel)
    case .firstSeen:
      vStack.alignment = .trailing
      vStack.addArrangedSubview(moreInfoTitle())
    }
    
    return vStack
  }
}

//MARK: - UI Helpers
private extension CardTableViewCell {
  func setupColorTheme(according info: ResultDTO) {
    backgroundColor = .clear
    statusDot.backgroundColor = info.status.color
  }
  func setupImages(according info: ResultDTO) {
    let placeholder = AppImage.placeholder.withRenderingMode(.alwaysTemplate)
    avatarImageView.tintColor = AppColor.mainText
    
    avatarImageView.kf.setImage(with: URL(string: info.image), placeholder: placeholder) { [weak self] result in
      switch result {
      case .success(_):
        self?.avatarImageView.contentMode = .scaleAspectFill
      case .failure(_):
        self?.avatarImageView.contentMode = .center
      }
    }
  }
}

//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static var titlesVStackSpacing: CGFloat {
    sizeProportion(for: 16.0)
  }
  static var subTitlesVStackSpacing: CGFloat { titlesVStackSpacing / 2 }
  
  static var containerVIndent: CGFloat { titlesVStackSpacing / 4 }
  
  static var titlesVStackVIndent: CGFloat { titlesVStackSpacing }
  static var titlesVStackHIndent: CGFloat {
    sizeProportion(for: 10.0)
  }
  
  //Fonts
  static var nameLabelFont: UIFont {
    let fontSize = sizeProportion(for: 24, minSize: 20)
    return AppFont.font(type: .medium, size: fontSize)
  }
  static var labelFont: UIFont {
    let fontSize = sizeProportion(for: 18.0, minSize: 14.0)
    return AppFont.font(type: .regular, size: fontSize)
  }
  static var titleFont: UIFont {
    let fontSize = sizeProportion(for: 16.0, minSize: 12.0)
    return AppFont.font(type: .light, size: fontSize)
  }
}
