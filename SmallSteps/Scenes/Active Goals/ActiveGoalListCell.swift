//
//  ActiveGoalListCell.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class ActiveGoalListCell: UITableViewCell {
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

    lazy var markView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }()

    var isEnabled: Bool = true {
        didSet {
            titleLabel.isEnabled = isEnabled
            frequencyLabel.isEnabled = isEnabled
            markView.isHidden = !isEnabled
        }
    }

    var viewModel: ActiveGoalListCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            frequencyLabel.text = viewModel.frequency
            markView.backgroundColor = viewModel.markColor
            isEnabled = viewModel.isEnabled
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
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: markView.leadingAnchor, constant: -20),
            // frequency
            frequencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            frequencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            frequencyLabel.trailingAnchor.constraint(lessThanOrEqualTo: markView.leadingAnchor, constant: -20),
            // mark
            markView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            markView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            markView.widthAnchor.constraint(equalToConstant: 40),
            markView.heightAnchor.constraint(equalToConstant: 40),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
