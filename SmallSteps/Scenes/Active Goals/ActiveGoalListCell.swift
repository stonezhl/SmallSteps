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

    lazy var disableTouchEventView: UIView = {
        let disableView = UIView()
        disableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(disableView)
        disableView.addGestureRecognizer(UITapGestureRecognizer())
        return disableView
    }()

    lazy var stepButton: StepButton = {
        let button = StepButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        disableTouchEventView.addSubview(button)
        button.addTarget(self, action: #selector(didTapStepButton(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var stepButtonTrailingConstraint: NSLayoutConstraint = stepButton.trailingAnchor.constraint(equalTo: disableTouchEventView.trailingAnchor, constant: -5)

    var viewModel: ActiveGoalListCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            frequencyLabel.text = viewModel.frequency
            if let isLeftFoot = viewModel.isLeftFoot {
                stepButton.isLeftFoot = isLeftFoot
                stepButton.isSelected = viewModel.isSelected
                stepButton.isHidden = false
                stepButtonTrailingConstraint.constant = isLeftFoot ? -45 : -5
            } else {
                stepButton.isHidden = true
            }
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

    @objc func didTapStepButton(sender: StepButton) {
        if sender.isSelected {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        sender.isSelected = !sender.isSelected
        viewModel?.takeStep?(sender.isSelected)
    }

    private func setupConstraints() {
        let constraints = [
            // title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: disableTouchEventView.leadingAnchor),
            // frequency
            frequencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            frequencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            frequencyLabel.trailingAnchor.constraint(lessThanOrEqualTo: disableTouchEventView.leadingAnchor),
            // disable
            disableTouchEventView.topAnchor.constraint(equalTo: contentView.topAnchor),
            disableTouchEventView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            disableTouchEventView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            disableTouchEventView.widthAnchor.constraint(equalToConstant: 110),
            // button
            stepButtonTrailingConstraint,
            stepButton.centerYAnchor.constraint(equalTo: disableTouchEventView.centerYAnchor),
            stepButton.widthAnchor.constraint(equalToConstant: 60),
            stepButton.heightAnchor.constraint(equalToConstant: 60),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
