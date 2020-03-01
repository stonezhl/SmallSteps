//
//  ActiveGoalListViewController.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/9/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class ActiveGoalListViewController: UIViewController {
    private let cellIdentifier = "ActiveGoalListCell"
    let viewModel: ActiveGoalListViewModel

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Today", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "All", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = viewModel.isTodayOnly ? 0 : 1
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(sender:)), for: .valueChanged)
        return segmentedControl
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 64
        tableView.register(ActiveGoalListCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()

    init(viewModel: ActiveGoalListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationItem.titleView = segmentedControl
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton(sender:)))
        let archiveButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(didTapArchiveButton(sender:)))
        navigationItem.rightBarButtonItems = [addButton, archiveButton]
        setupConstraints()
        viewModel.isDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTableView()
    }

    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        refreshTableView()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(isEditing, animated: true)
        if isEditing == false {
            tableView.visibleCells.forEach { cell in
                guard let indexPath = tableView.indexPath(for: cell) else { return }
                let cell = cell as! ActiveGoalListCell
                cell.viewModel = self.viewModel.cellViewModel(at: indexPath)
            }
        }
    }

    @objc func didTapAddButton(sender: UIBarButtonItem) {
        viewModel.addGoal()
    }

    @objc func didTapArchiveButton(sender: UIBarButtonItem) {
        viewModel.showArchived()
    }

    private func refreshTableView() {
        try? viewModel.fetchActiveGoals(isTodayOnly: segmentedControl.selectedSegmentIndex == 0)
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

extension ActiveGoalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.goalsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ActiveGoalListCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        return cell
    }
}

extension ActiveGoalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return isEditing ? .delete : .none
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Archived"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.archiveGoal(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !isEditing, viewModel.canTakeStep(at: indexPath) else { return nil }
        let stepAction = UIContextualAction(style: .normal, title: "Take a step") { [weak self] action, view, completion in
            self?.viewModel.takeStep(at: indexPath)
            let cell = tableView.cellForRow(at: indexPath) as! ActiveGoalListCell
            cell.viewModel = self?.viewModel.cellViewModel(at: indexPath)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [stepAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetail(at: indexPath)
    }
}
