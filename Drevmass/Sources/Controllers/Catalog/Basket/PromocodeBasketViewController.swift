//
//  PromocodeBasketViewController.swift
//  Drevmass
//
//  Created by Aset Bakirov on 27.03.2024.
//

import UIKit
import SnapKit
import PanModal

class PromocodeBasketViewController: UIViewController, PanModalPresentable {
    //- MARK: - Variables

    //- MARK: - Local outlets
    private lazy var promoTextfield: TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        let placeholderText = "Введите промокод"
        textfield.defaultTextAttributes = [NSAttributedString.Key.font : UIFont.addFont(type: .SFProDisplaySemibold, size: 20), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors._181715)]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font : UIFont.addFont(type: .SFProDisplaySemibold, size: 20), NSAttributedString.Key.foregroundColor : UIColor(resource: ColorResource.Colors.A_1_A_1_A_1)])
        textfield.setIcon(UIImage(resource: ImageResource.Basket.promocode))
        textfield.borderStyle = .none
//        textfield.addTarget(self, action: #selector(textfieldEditBegin), for: .editingDidBegin)
//        textfield.addTarget(self, action: #selector(textfieldEditEnd), for: .editingDidEnd)
//        textfield.addTarget(self, action: #selector(textfieldEditingChanged), for: .editingChanged)
//        textfield.addTarget(self, action: #selector(textfieldAllEditing), for: .allEditingEvents)
        return textfield
    }()
    
    private lazy var dashedLineView: DashedLineView = {
        var view = DashedLineView()
        view.dashColor = UIColor(resource: ColorResource.Colors.D_6_D_1_CE)
        view.backgroundColor = .clear
        view.spaceBetweenDash = 6
        view.perDashLength = 5
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите промокод"
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = UIColor(resource: ColorResource.Colors.FA_5_C_5_C)
        return label
    }()
    
    lazy var applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Применить", for: .normal)
        button.setTitleColor(UIColor(resource: ColorResource.Colors.FFFFFF), for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextSemiBold, size: 15)
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        button.addTarget(self, action: #selector(sendPromocode), for: .touchUpInside)
        return button
    }()
    
    //- MARK: - Pan Modal setup
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(180)
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
        errorLabel.isHidden = true
        addViews()
        setConstraints()
    }
    
    //- MARK: - Add & set Views
    private func addViews() {
        view.addSubview(promoTextfield)
        view.addSubview(dashedLineView)
        view.addSubview(applyButton)
    }
    
    //- MARK: - Set Constraints
    private func setConstraints() {
        promoTextfield.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        dashedLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(promoTextfield.snp.bottom)
            make.horizontalEdges.equalTo(promoTextfield.snp.horizontalEdges)
        }
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(dashedLineView.snp.bottom).offset(31.5)
            make.horizontalEdges.equalTo(dashedLineView.snp.horizontalEdges)
            make.height.equalTo(48)
        }
    }
    //- MARK: - Set Errors
    private func showRedError() {
        errorLabel.isHidden = false
        promoTextfield.setIcon(UIImage(resource: ImageResource.Basket.promocodeRed))
        dashedLineView.dashColor = UIColor(resource: ColorResource.Colors.FA_5_C_5_C)
    }
    
    private func hideRedError() {
        errorLabel.isHidden = true
        promoTextfield.setIcon(UIImage(resource: ImageResource.Basket.promocode))
        dashedLineView.dashColor = UIColor(resource: ColorResource.Colors.D_6_D_1_CE)
    }
    //- MARK: - Button actions
    @objc func sendPromocode() {
        print("send promo")
    }
}
