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

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArchivedGoalListCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 64
        tableView.tableFooterView = UIView()
        return tableView
    }()

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
        title = "Archived"
        navigationItem.leftBarButtonItem = editButtonItem
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(didTapCloseButton(sender:)))
        navigationItem.rightBarButtonItem = closeButton
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchArchivedGoals()
        tableView.reloadData()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            if tableView.isEditing {
                tableView.setEditing(false, animated: true)
            }
        }
        tableView.setEditing(editing, animated: true)
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditing
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteGoal(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetail(at: indexPath)
    }
}

