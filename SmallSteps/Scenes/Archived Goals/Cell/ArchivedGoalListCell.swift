//
//  ArchivedGoalListCell.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/24/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class ArchivedGoalListCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    lazy var frequencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()

    var viewModel: ArchivedGoalListCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            frequencyLabel.text = viewModel.frequency
        }
    }

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
            // title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            // frequency
            frequencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            frequencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            frequencyLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}