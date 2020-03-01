//
//  ArchivedGoalListViewController.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/9/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class ArchivedGoalListViewController: UIViewController {
    private let cellIdentifier = "ArchivedGoalListCell"
    let viewModel: ArchivedGoalListViewModel

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 64
        tableView.register(ArchivedGoalListCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()

    init(viewModel: ArchivedGoalListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Archived"
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(didTapCloseButton(sender:)))
        navigationItem.rightBarButtonItem = closeButton
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchArchivedGoals()
        tableView.reloadData()
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
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
            self?.viewModel.deleteGoal(at: indexPath)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let restoreAction = UIContextualAction(style: .normal, title: "Restore") { [weak self] action, view, completion in
            self?.viewModel.restoreGoal(at: indexPath)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [restoreAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetail(at: indexPath)
    }
}

