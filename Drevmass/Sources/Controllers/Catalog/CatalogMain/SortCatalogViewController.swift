//
//  SortCatalogViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 19.03.2024.
//

import UIKit
import SnapKit
import PanModal

class SortCatalogViewController: UIViewController, PanModalPresentable {
    //- MARK: - Variables
    weak var delegate: SortSelecting?
    var currentSort: SortType? = nil
    //- MARK: - Local outlets
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сортировка"
        label.font = .addFont(type: .SFProDisplaySemibold, size: 20)
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        return label
    }()
    
    private lazy var famousButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.text = "По популярности"
        label.font = .addFont(type: .SFProTextRegular, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(22)
        }
        button.addTarget(self, action: #selector(selectFamous), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var famousButtonRadiobox: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var priceupButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.text = "По возрастанию цены"
        label.font = .addFont(type: .SFProTextRegular, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(22)
        }
        button.addTarget(self, action: #selector(selectPriceup), for: .touchUpInside)
        return button
    }()
    
    private lazy var priceupButtonRadiobox: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    private lazy var pricedownButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        label.text = "По убыванию цены"
        label.font = .addFont(type: .SFProTextRegular, size: 17)
        label.textColor = UIColor(resource: ColorResource.Colors._181715)
        
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(22)
        }
        button.addTarget(self, action: #selector(selectPricedown), for: .touchUpInside)
        return button
    }()
    
    private lazy var pricedownButtonRadiobox: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    //- MARK: - Pan Modal setup
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(232)
    }
    var panModalBackgroundColor: UIColor {
        return UIColor(resource: ColorResource.Colors._302C28A65)
    }
    var cornerRadius: CGFloat {
        return 24
    }
    var dragIndicatorBackgroundColor: UIColor {
        return UIColor(resource: ColorResource.Colors.E_0_DEDD)
    }
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        addViews()
        setConstraints()
        setViews()
    }
    
    //- MARK: - Add & set Views
    private func addViews() {
        view.addSubview(titleLabel)
        view.addSubview(famousButton)
        famousButton.addSubview(famousButtonRadiobox)
        view.addSubview(priceupButton)
        priceupButton.addSubview(priceupButtonRadiobox)
        view.addSubview(pricedownButton)
        pricedownButton.addSubview(pricedownButtonRadiobox)
    }
    private func setViews() {
        if currentSort == .famous {
            famousButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radioboxSelected)
            priceupButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radiobox)
            pricedownButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radiobox)
            return
        }
        if currentSort == .priceup {
            famousButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radiobox)
            priceupButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radioboxSelected)
            pricedownButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radiobox)
        }
        if currentSort == .pricedown {
            famousButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radiobox)
            priceupButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radiobox)
            pricedownButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radioboxSelected)
            return
        }
        
    }
    //- MARK: - Set Constraints
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(24)
        }
        famousButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        famousButtonRadiobox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }
        priceupButton.snp.makeConstraints { make in
            make.top.equalTo(famousButton.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        priceupButtonRadiobox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }
        pricedownButton.snp.makeConstraints { make in
            make.top.equalTo(priceupButton.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        pricedownButtonRadiobox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    //- MARK: - Button actions
    @objc func selectFamous() {
        famousButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radioboxSelected)
        delegate?.sortDidSelected(.famous)
        dismiss(animated: true)
    }
    @objc func selectPricedown() {
        pricedownButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radioboxSelected)
        delegate?.sortDidSelected(.pricedown)
        dismiss(animated: true)
    }
    @objc func selectPriceup() {
        priceupButtonRadiobox.image = UIImage(resource: ImageResource.Catalog.radioboxSelected)
        delegate?.sortDidSelected(.priceup)
        dismiss(animated: true)
    }
}
