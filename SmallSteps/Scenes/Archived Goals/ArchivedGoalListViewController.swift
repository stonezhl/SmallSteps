//
//  ArchivedGoalListViewController.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/9/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit
import HGPlaceholders

class ArchivedGoalListViewController: UIViewController {
    private let cellIdentifier = "ArchivedGoalListCell"

    lazy var tableView: UITableView = {
        let tableView = TableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArchivedGoalListCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 64
        tableView.tableFooterView = UIView()
        tableView.placeholdersProvider = .default
        tableView.placeholdersProvider.add(placeholders: noArchivedGoalsPlaceholder)
        return tableView
    }()

    lazy var noArchivedGoalsPlaceholder: Placeholder = {
        var style = PlaceholderStyle()
        style.backgroundColor = .systemBackground
        style.titleColor = .label
        style.subtitleColor = .secondaryLabel
        style.isAnimated = false
        var data = PlaceholderData()
        data.image = UIImage(named: "empty_archived")
        data.title = NSLocalizedString("No goals found", comment: "Title of empty archived goals scene")
        data.subtitle = NSLocalizedString("You haven't archived any goals yet", comment: "Subtitle of empty archived goals scene")
        data.action = nil
        return Placeholder(data: data, style: style, key: .noResultsKey)
    }()

    override func setEditing(_ editing: Bool, animated: Bool) {
        if viewModel.goalsCount == 0 { return }
        super.setEditing(editing, animated: animated)
        if editing {
            if tableView.isEditing {
                tableView.setEditing(false, animated: true)
            }
        }
        tableView.setEditing(editing, animated: true)
    }

    let viewModel: ArchivedGoalListViewModel

    init(viewModel: ArchivedGoalListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Archived", comment: "Title of archived goals scene")
        navigationItem.leftBarButtonItem = editButtonItem
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(didTapCloseButton(sender:)))
        navigationItem.rightBarButtonItem = closeButton
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @objc func didTapCloseButton(sender: UIBarButtonItem) {
        dismiss()
    }

    private func dismiss() {
        dismiss(animated: true) {
            self.viewModel.didExitScene?()
        }
    }

    private func setupConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ArchivedGoalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.goalsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ArchivedGoalListCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        return cell
    }
}

extension ArchivedGoalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !isEditing { return nil }
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, completion in
            self?.viewModel.deleteGoal(at: indexPath)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetail(at: indexPath)
    }
}

