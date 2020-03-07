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
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    lazy var frequencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    lazy var markImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var markImageViewTrailingConstraint: NSLayoutConstraint = markImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)

    var viewModel: ActiveGoalListCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            frequencyLabel.text = viewModel.frequency
            markImageView.image = viewModel.footImage
            markImageView.tintColor = viewModel.markColor
            markImageViewTrailingConstraint.constant = viewModel.isLeftFoot ? -55 : -15
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
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -110),
            // frequency
            frequencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            frequencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            frequencyLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -110),
            // mark
            markImageViewTrailingConstraint,
            markImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            markImageView.widthAnchor.constraint(equalToConstant: 40),
            markImageView.heightAnchor.constraint(equalToConstant: 40),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
