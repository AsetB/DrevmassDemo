//
//  TextFieldView.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 08.03.2024.
//


import Foundation
import UIKit
import SnapKit

class TextFieldView: UIView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .addFont(type: .SFProTextMedium, size: 13)
        label.textColor = .Colors._989898
        return label
    }()
    
    var textfield: UITextField = {
        let textField = UITextField()
        textField.textColor = .Colors._181715
        textField.font = .addFont(type: .SFProTextSemiBold, size: 17)
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [.font: UIFont.addFont(type: .SFProTextSemiBold, size: 17), .foregroundColor: UIColor.Colors.A_1_A_1_A_1])
        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(changeColorToRed), for: .editingChanged)
        return textField
    }()
    
    var viewUnderLine: UIView = {
       var view = UIView()
        view.backgroundColor = .Colors.E_0_DEDD
        return view
    }()
    
    var clearButton: UIButton = {
       var button = UIButton()
        button.setImage(.Profile.iconClearProfile, for: .normal)
        button.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextFieldView {
    @objc  func changeColorToRed() {
        if textfield.text == "" {
            titleLabel.textColor = .Colors.FA_5_C_5_C
            viewUnderLine.backgroundColor = .Colors.FA_5_C_5_C
        }
     }

    
    @objc func editingDidBegin() {
        titleLabel.textColor = .Colors.B_5_A_380
        viewUnderLine.backgroundColor = .Colors.B_5_A_380
        clearButton.isHidden = false
    }
    
    @objc func editingDidEnd() {
        titleLabel.textColor = .Colors._989898
        viewUnderLine.backgroundColor = .Colors.E_0_DEDD
        clearButton.isHidden = true
    }
    
    @objc func clearTextField() {
        textfield.text = ""
        changeColorToRed()
    }
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(textfield)
        addSubview(viewUnderLine)
        addSubview(clearButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        textfield.snp.makeConstraints { make in
            make.height.equalTo(37)
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        viewUnderLine.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(textfield.snp.bottom).inset(-3)
            make.height.equalTo(1)
        }
        clearButton.snp.makeConstraints { make in
            make.centerY.equalTo(textfield)
            make.right.equalToSuperview()
            make.width.equalTo(40)
        }
    }
}

