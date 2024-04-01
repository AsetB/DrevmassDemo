//
//  SuccessOrderViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 01.04.2024.
//

import UIKit
import PanModal
import SnapKit

class SuccessOrderViewController: UIViewController, PanModalPresentable {
    //- MARK: - Local outlets
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: ImageResource.Basket.emptyOrder)
        return image
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш заказ принят"
        label.textColor = UIColor(resource: ColorResource.Colors._302_C_28)
        label.font = .addFont(type: .SFProDisplayBold, size: 22)
        label.textAlignment = .center
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
Сейчас на ваш номер должна прийти смс 
с номера Drevmass. Наши менеджеры
свяжутся с Вами в ближайшее время.
"""
        label.textColor = UIColor(resource: ColorResource.Colors._787878)
        label.font = .addFont(type: .SFProTextRegular, size: 16)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    private lazy var okayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Понятно", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 17)
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.addTarget(self, action: #selector(okayAction), for: .touchUpInside)
        return button
    }()
    //- MARK: - Pan Modal setup
    var panScrollable: UIScrollView? {
        return nil
    }
    var longFormHeight: PanModalHeight {
        return .contentHeight(378)
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
        setViews()
        setConstraints()

    }
    
    private func setViews() {
        view.addSubview(image)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(okayButton)
    }
    
    private func setConstraints() {
        image.snp.makeConstraints { make in
            make.size.equalTo(112)
            make.top.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        okayButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
    }
    
    @objc func okayAction() {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            // Dismiss the OrderViewController as well, as it was presented before the modal
            print("first dismiss")
            self.presentingViewController?.navigationController?.popViewController(animated: true)
        }
    }
}
