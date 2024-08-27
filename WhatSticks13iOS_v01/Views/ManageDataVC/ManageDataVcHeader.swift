//
//  ManageDataVcHeader.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 20/08/2024.
//

import UIKit


class ManageDataVcHeader: UIView {
    
    weak var delegate: DashboardHeaderDelegate?
    let lblManageDataVcTitle = UILabel()

    let stckVwManageData = UIStackView()

    let stckVwRecordCount = UIStackView()
    let lblRecordCountFilled = UILabel()
    let btnRecordCountFilled = UIButton()
    
    let stckVwEarliestDate = UIStackView()
    let lblEarliestDateFilled = UILabel()
    let btnEarliestDateFilled = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // This triggers as soon as the app starts
        setupManageDataVcTitle()
        setupUserVcAccountView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    private func setupManageDataVcTitle(){
        lblManageDataVcTitle.accessibilityIdentifier="lblManageDataVcTitle"
        lblManageDataVcTitle.translatesAutoresizingMaskIntoConstraints = false
        lblManageDataVcTitle.text = "Manage Data"
        lblManageDataVcTitle.font = UIFont(name: "ArialRoundedMTBold", size: 45)
        lblManageDataVcTitle.numberOfLines=0
        self.addSubview(lblManageDataVcTitle)
                
        NSLayoutConstraint.activate([
            lblManageDataVcTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: heightFromPct(percent: 3)),
            lblManageDataVcTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -2)),
            lblManageDataVcTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 2)),

        ])
    }
    
    private func setupUserVcAccountView(){
//        userStore = UserStore.shared

        stckVwManageData.accessibilityIdentifier = "stckVwManageData"
        stckVwManageData.translatesAutoresizingMaskIntoConstraints=false

        stckVwManageData.axis = .vertical
        stckVwManageData.alignment = .fill
        stckVwManageData.distribution = .fillEqually
        stckVwManageData.spacing = 10

        stckVwRecordCount.accessibilityIdentifier = "stckVwRecordCount"
        stckVwRecordCount.translatesAutoresizingMaskIntoConstraints=false
        stckVwRecordCount.axis = .horizontal
        stckVwRecordCount.alignment = .fill
        stckVwRecordCount.distribution = .fill
        stckVwRecordCount.spacing = 10

        stckVwEarliestDate.accessibilityIdentifier = "stckVwEarliestDate"
        stckVwEarliestDate.translatesAutoresizingMaskIntoConstraints=false
        stckVwEarliestDate.axis = .horizontal
        stckVwEarliestDate.alignment = .fill
        stckVwEarliestDate.distribution = .fill
        stckVwEarliestDate.spacing = 10

        lblRecordCountFilled.accessibilityIdentifier="lblRecordCountFilled"
        lblRecordCountFilled.text = "Record count:"
        lblRecordCountFilled.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        lblRecordCountFilled.translatesAutoresizingMaskIntoConstraints=false
        lblRecordCountFilled.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        /* there is also setContentCompressionResistancePriority */

        btnRecordCountFilled.accessibilityIdentifier="btnRecordCountFilled"
        if let font = UIFont(name: "ArialRoundedMTBold", size: 17) {
            btnRecordCountFilled.titleLabel?.font = font
        }
        btnRecordCountFilled.backgroundColor = UIColor(named: "ColorRow3Textfields")
        btnRecordCountFilled.setTitleColor(UIColor(named: "lineColor"), for: .normal)
        btnRecordCountFilled.layer.borderWidth = 1
        btnRecordCountFilled.layer.cornerRadius = 5
        btnRecordCountFilled.translatesAutoresizingMaskIntoConstraints = false
//        btnRecordCountFilled.accessibilityIdentifier="btnRecordCountFilled"

        stckVwRecordCount.addArrangedSubview(lblRecordCountFilled)
        stckVwRecordCount.addArrangedSubview(btnRecordCountFilled)

        stckVwEarliestDate.accessibilityIdentifier = "stckVwEarliestDate"
        stckVwEarliestDate.translatesAutoresizingMaskIntoConstraints=false

        lblEarliestDateFilled.accessibilityIdentifier="lblEarliestDateFilled"
        lblEarliestDateFilled.text = "Earliest date:"
        lblEarliestDateFilled.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        lblEarliestDateFilled.translatesAutoresizingMaskIntoConstraints=false
        lblEarliestDateFilled.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)

        btnEarliestDateFilled.accessibilityIdentifier="btnEarliestDateFilled"
//        btnRecordCountFilled.setTitle("0", for: .normal)
        if let font = UIFont(name: "ArialRoundedMTBold", size: 17) {
            btnEarliestDateFilled.titleLabel?.font = font
        }
        btnEarliestDateFilled.setTitleColor(UIColor(named: "lineColor"), for: .normal)
        btnEarliestDateFilled.backgroundColor = UIColor(named: "ColorRow3Textfields")
        btnEarliestDateFilled.layer.borderWidth = 1
        btnEarliestDateFilled.layer.cornerRadius = 5
        btnEarliestDateFilled.translatesAutoresizingMaskIntoConstraints = false
//        btnEarliestDateFilled.accessibilityIdentifier="btnRecordCountFilled"

        stckVwEarliestDate.addArrangedSubview(lblEarliestDateFilled)
        stckVwEarliestDate.addArrangedSubview(btnEarliestDateFilled)

        stckVwManageData.addArrangedSubview(stckVwRecordCount)
        stckVwManageData.addArrangedSubview(stckVwEarliestDate)

        self.addSubview(stckVwManageData)


        NSLayoutConstraint.activate([


            stckVwManageData.topAnchor.constraint(equalTo: lblManageDataVcTitle.bottomAnchor,constant: heightFromPct(percent: 2)),
            stckVwManageData.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -3)),
            stckVwManageData.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 3)),
            stckVwManageData.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: heightFromPct(percent: -3)),
            btnRecordCountFilled.widthAnchor.constraint(lessThanOrEqualTo: btnEarliestDateFilled.widthAnchor)
            ])
    }
}
