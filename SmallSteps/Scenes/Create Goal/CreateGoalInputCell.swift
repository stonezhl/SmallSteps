//
//  CreateGoalInputCell.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/6/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class CreateGoalInputCell: UITableViewCell {
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        textField.placeholder = "Enter a title for your goal"
        textField.font = .systemFont(ofSize: 17)
        textField.tintColor = .systemOrange
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }

    private func setupConstraints() {
        let constraints = [
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
