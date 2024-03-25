//
//  CalendarView.swift
//  Drevmass
//
//  Created by Madina Olzhabek on 25.03.2024.
//

import Foundation
import UIKit
import SnapKit

class CalendarView: UIView {
    
    // MARK: - UI Elements
    
    var calendarWithSwitch: Button = {
        var button = Button()
        button.setTitle("Календарь занятий", for: .normal)
        button.leftIcon.image = UIImage(resource: ImageResource.Courses.icCalendar)
        button.setTitleColor(UIColor(resource: ColorResource.Colors._302_C_28), for: .normal)
//        button.heightAnchor.constraint(equalToConstant: 63).isActive = true
        button.layer.borderWidth = 0
        return button
    }()
    
    var switchForCalendar: UISwitch = {
       var switchForCalendar = UISwitch()
        switchForCalendar.onTintColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        switchForCalendar.frame.size = CGSize(width: 51, height: 31)
//        switchForCalendar.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return switchForCalendar
    }()
    
    var dayOfClassButton: Button = {
       var button = Button()
        button.setTitle("Дни занятий", for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextRegular, size: 17)
        button.setTitleColor(UIColor(resource: ColorResource.Colors._302_C_28), for: .normal)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)
//        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.isHidden = true
        button.contentEdgeInsets.left = 16
        button.isHidden = true
//        button.addTarget(self, action: #selector(showSelectDayViewController), for: .touchUpInside)
        return button
    }()
    
    var titleForDayLabel: UILabel = {
       var label = UILabel()
        label.text = ""
        label.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        return label
    }()
    
    var timeOfClassButton: Button = {
       var button = Button()
        button.setTitle("Время", for: .normal)
        button.titleLabel?.font = .addFont(type: .SFProTextRegular, size: 17)
        button.setTitleColor(UIColor(resource: ColorResource.Colors._302_C_28), for: .normal)
        button.rightIcon.image = UIImage(resource: ImageResource.Profile.arrowBeigeProfile)
//        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.borderWidth = 0
        button.leftIcon.isHidden = true
        button.contentEdgeInsets.left = 16
        button.isHidden = true
//        button.addTarget(self, action: #selector(showSelectTimeViewController), for: .touchUpInside)
        return button
    }()
    
    var titleForTimeLabel: UILabel = {
       var label = UILabel()
        label.text = "9:00"
        label.textColor = UIColor(resource: ColorResource.Colors.B_5_A_380)
        label.font = .addFont(type: .SFProTextSemiBold, size: 17)
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setups
    
    func setupView() {
        backgroundColor = UIColor(resource: ColorResource.Colors.FFFFFF)
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor(resource: ColorResource.Colors.EFEBE_9).cgColor
        
        
        addSubview(calendarWithSwitch)
        calendarWithSwitch.addSubview(switchForCalendar)
        addSubview(dayOfClassButton)
        dayOfClassButton.addSubview(titleForDayLabel)
        addSubview(timeOfClassButton)
        timeOfClassButton.addSubview(titleForTimeLabel)
    }
    
    func setupConstraints() {
        calendarWithSwitch.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview()
        }
        switchForCalendar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        dayOfClassButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(calendarWithSwitch.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        titleForDayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(40)
        }
        timeOfClassButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(dayOfClassButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        titleForTimeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(40)
        }
    }
    
}
