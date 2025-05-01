//
//  DetailsViewController.swift
//  Rick and Morty
//
//  Created by Дмитрий Хероим on 01.05.2025.
//

import UIKit
import Kingfisher

final class DetailsViewController: BaseViewController {
  private let beginInfo: ResultDTO
  init(with info: ResultDTO) {
    self.beginInfo = info
    
    super.init(nibName: nil, bundle: nil)
  }
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var viewModel = DetailsViewModel(info: beginInfo, delegate: self)
  
  private lazy var defaultContentContainer = createCommonContainer()
  private var defaultContentContainerLeading: NSLayoutConstraint!
  
  private lazy var avatarImageView = createAvatarImageView()
  private lazy var avatarImageViewHeight = NSLayoutConstraint(item: avatarImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
  
  private lazy var titlesVStack = createTitlesVStack()
  private lazy var nameLabel = createNameLabel()
  private lazy var statusDot = createStatusDot()
  private lazy var statusLabel = createStatusLabel()
  private lazy var locationLabel = createCommonParameterLabel()
  
  //additionalContentContainer UI elements
  private lazy var additionalContentContainer = createCommonContainer()
  private lazy var scrollView = createScrollView()
  private lazy var scrollViewContainer = createScrollViewContainer()
  
  private lazy var additionalTitlesVStack = createCommonTitlesVStack()
  private lazy var additionalContentTitle = createAdditionalContentTitle()
  
  private lazy var typeHStack = createTypeHStack()
  private lazy var typeLabel = createCommonParameterLabel()
  
  private lazy var genderHStack = createGenderHStack()
  private lazy var genderLabel = createCommonParameterLabel()
  
  private lazy var loremIpsumLabel = createLoremIpsumLabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    viewModel.viewDidLoad()
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    defaultContentContainer.setNeedsLayout()
    defaultContentContainer.layoutIfNeeded()
    
    avatarImageViewHeight.constant = defaultContentContainer.frame.height
  }
  
  //  func addUIComponents() {}
  override func addUIComponents() {
    view.addSubview(defaultContentContainer)
    
    defaultContentContainer.addSubview(avatarImageView)
    defaultContentContainer.addSubview(titlesVStack)
    
    let mainTitlesVStack = createMainTitlesVStack()
    titlesVStack.addArrangedSubview(mainTitlesVStack)
    let locationTitlesVStack = createLocationTitlesVStack()
    titlesVStack.addArrangedSubview(locationTitlesVStack)
    
    //additionalContentContainer
    view.addSubview(additionalContentContainer)
    additionalContentContainer.addSubview(scrollView)
    
    scrollView.addSubview(scrollViewContainer)
    
    additionalTitlesVStack.addArrangedSubview(additionalContentTitle)
    additionalTitlesVStack.addArrangedSubview(typeHStack)
    additionalTitlesVStack.addArrangedSubview(genderHStack)
    additionalTitlesVStack.addArrangedSubview(loremIpsumLabel)
  }
  override func setupLocalizeTitles() {
    title = DetailsTitles.title.localized
  }
  override func setupConstraintsConstants() {
    let margins = view.safeAreaLayoutGuide
    defaultContentContainer.translatesAutoresizingMaskIntoConstraints = false
    defaultContentContainer.topAnchor.constraint(equalTo: margins.topAnchor, constant: Constants.baseSideIndent).isActive = true
    defaultContentContainer.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: Constants.baseSideIndent).isActive = true
    defaultContentContainer.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
    
    additionalContentContainer.translatesAutoresizingMaskIntoConstraints = false
    additionalContentContainer.topAnchor.constraint(equalTo: defaultContentContainer.bottomAnchor, constant: Constants.baseSideIndent).isActive = true
    additionalContentContainer.leadingAnchor.constraint(equalTo: defaultContentContainer.leadingAnchor).isActive = true
    additionalContentContainer.trailingAnchor.constraint(equalTo: defaultContentContainer.trailingAnchor).isActive = true
    additionalContentContainer.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    
    
    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    avatarImageView.widthAnchor.constraint(equalTo: defaultContentContainer.widthAnchor, multiplier: Constants.avatarMultiplier).isActive = true
    avatarImageView.leadingAnchor.constraint(equalTo: defaultContentContainer.leadingAnchor).isActive = true
    avatarImageViewHeight.isActive = true
    avatarImageView.centerYAnchor.constraint(equalTo: defaultContentContainer.centerYAnchor).isActive = true
    titlesVStack.translatesAutoresizingMaskIntoConstraints = false
    titlesVStack.topAnchor.constraint(equalTo: defaultContentContainer.topAnchor, constant: Constants.titlesVStackVIndent).isActive = true
    titlesVStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.titlesVStackHIndent).isActive = true
    titlesVStack.trailingAnchor.constraint(equalTo: defaultContentContainer.trailingAnchor, constant: -Constants.titlesVStackHIndent).isActive = true
    titlesVStack.bottomAnchor.constraint(equalTo: defaultContentContainer.bottomAnchor, constant: -Constants.titlesVStackVIndent).isActive = true
    
    
    
    scrollView.fillToSuperview()
    scrollViewContainer.fillToSuperview()
    scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
  }
}

//MARK: - DetailsViewModelDelegate
extension DetailsViewController: DetailsViewModelDelegate {
  func infoDidChange(to info: ResultDTO) {
    nameLabel.text = info.name
    let statusText: String
    if let species = info.species {
      statusText = info.status.rawValue + " - " + species
    } else {
      statusText = info.status.rawValue
    }
    statusLabel.text = statusText
    
    locationLabel.text = info.location.name
    
    statusDot.backgroundColor = info.status.color
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
    
    typeLabel.text = info.type.isEmpty ? "-" : info.type
    genderLabel.text = info.gender.rawValue
  }
}

//MARK: - UI elements creating (Default content container)
private extension DetailsViewController {
  private func createAvatarImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .center
    imageView.clipsToBounds = true
    
    return imageView
  }
  private func createNameLabel() -> UILabel {
    let label = createCommonParameterLabel()
    label.font = Constants.nameLabelFont
    
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
    let label = createCommonLabel()
    label.font = Constants.labelFont
    label.textColor = AppColor.mainText
    
    return label
  }
  
  private func createLocationTitle() -> UILabel {
    let label = createCommonTitle()
    label.text = MainTitles.locationTitle.localized + ":"
    
    return label
  }
  
  func createMainTitlesVStack() -> UIStackView {
    let vStack = createCommonTitlesVStack()
    
    vStack.addArrangedSubview(nameLabel)
    
    let additionalHStack = UIStackView()
    additionalHStack.axis = .horizontal
    additionalHStack.spacing = Constants.subTitlesVStackSpacing
    additionalHStack.alignment = .center
    
    additionalHStack.addArrangedSubview(statusDot)
    additionalHStack.addArrangedSubview(statusLabel)
    
    vStack.addArrangedSubview(additionalHStack)
    
    return vStack
  }
  func createLocationTitlesVStack() -> UIStackView {
    let vStack = createCommonTitlesVStack()
    
    vStack.addArrangedSubview(createLocationTitle())
    vStack.addArrangedSubview(locationLabel)
    
    return vStack
  }
}

//MARK: - UI elements creating (Additional content container)
private extension DetailsViewController {
  func createScrollView() -> UIScrollView {
    let scrollView = UIScrollView()
    
    return scrollView
  }
  func createScrollViewContainer() -> UIView {
    let view = createCommonContainer()
    
    view.addSubview(additionalTitlesVStack)
    additionalTitlesVStack.fillToSuperview(verticalIndents: Constants.titlesVStackSpacing, horizontalIndents: Constants.titlesVStackSpacing)
    
    return view
  }
  
  func createAdditionalContentTitle() -> UILabel {
    let label = createCommonTitle()
    label.text = DetailsTitles.additionalInfo.localized + ":"
    
    return label
  }
  
  func createGenderHStack() -> UIStackView {
    let additionalHStack = createCommonAdditionalHStack()
    
    let title = createCommonTitle()
    title.text = DetailsTitles.gender.localized + ":"
    additionalHStack.addArrangedSubview(title)
    additionalHStack.addArrangedSubview(genderLabel)
    
    return additionalHStack
  }
  func createTypeHStack() -> UIStackView {
    let additionalHStack = createCommonAdditionalHStack()
    
    let title = createCommonTitle()
    title.text = DetailsTitles.type.localized + ":"
    additionalHStack.addArrangedSubview(title)
    additionalHStack.addArrangedSubview(typeLabel)
    
    return additionalHStack
  }
  
  func createLoremIpsumLabel() -> UILabel {
    let label = createCommonParameterLabel()
    label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    return label
  }
}
//MARK: - Common UI elements creating
private extension DetailsViewController {
  func createCommonAdditionalHStack() -> UIStackView {
    let additionalHStack = UIStackView()
    additionalHStack.axis = .horizontal
    additionalHStack.spacing = Constants.subTitlesVStackSpacing
    additionalHStack.alignment = .center
    
    return additionalHStack
  }
  func createCommonLabel() -> UILabel {
    let label = UILabel()
    label.textAlignment = .left
    
    return label
  }
  func createCommonParameterLabel() -> UILabel {
    let label = createCommonLabel()
    label.font = Constants.labelFont
    label.textColor = AppColor.mainText
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    
    return label
  }
  private func createCommonTitle() -> UILabel {
    let label = createCommonLabel()
    label.font = Constants.titleFont
    label.textColor = AppColor.additionalText
    
    return label
  }
  func createCommonContainer() -> UIView {
    let view = UIView()
    view.backgroundColor = AppColor.cardBg
    view.cornerRadius = Constants.baseSideIndent
    
    return view
  }
  func createCommonTitlesVStack() -> UIStackView {
    let vStack = UIStackView()
    vStack.axis = .vertical
    vStack.spacing = Constants.subTitlesVStackSpacing
    
    return vStack
  }
  
  func createTitlesVStack() -> UIStackView {
    let vStack = UIStackView()
    vStack.axis = .vertical
    vStack.spacing = Constants.titlesVStackSpacing
    
    return vStack
  }
}

//MARK: - Constants
fileprivate struct Constants: CommonSettings {
  static let avatarMultiplier: CGFloat = 0.33
  
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
