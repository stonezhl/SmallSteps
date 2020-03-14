//
//  CreateGoalViewController.swift
//  SmallSteps
//
//  Created by Stone Zhang on 2/23/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class CreateGoalViewController: UIViewController {
    private let inputCellIdentifier = "CreateGoalInputCell"
    private let cellIdentifier = "CreateGoalFrequencyCell"

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CreateGoalInputCell.self, forCellReuseIdentifier: inputCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = 44
        return tableView
    }()

    var titleTextField: UITextField {
        return (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CreateGoalInputCell).textField
    }

    let viewModel: CreateGoalViewModel

    init(viewModel: CreateGoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("`init(coder:)` has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Goal"
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton(sender:)))
        navigationItem.leftBarButtonItem = cancelButton
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSaveButton(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        enableKeyboardHideOnTap()
        setupConstraints()
    }

    @objc func didTapSaveButton(sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(title: "Empty Title", message: "Title can't be empty")
            return
        }
        guard let indexPaths = tableView.indexPathsForSelectedRows else {
            showAlert(title: "Invalid Frequency", message: "Please select at least one frequency")
            return
        }
        viewModel.saveGoal(title: title, selectedIndexPaths: indexPaths)
        dismiss()
    }

    @objc func didTapCancelButton(sender: UIBarButtonItem) {
        dismiss()
    }

    private func dismiss() {
        dismiss(animated: true) {
            self.viewModel.didExitScene?()
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
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

extension CreateGoalViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel.frequencyTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellIdentifier, for: indexPath) as! CreateGoalInputCell
            cell.textField.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.frequencyTitles[indexPath.row]
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let isSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.accessoryType = isSelected ? .checkmark : .none
        cell.tintColor = .systemOrange
        return cell
    }
}

extension CreateGoalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .checkmark
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
    }
}

extension CreateGoalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return false
    }

    private func enableKeyboardHideOnTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(sender:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func hideKeyboard(sender: UIView) {
        titleTextField.resignFirstResponder()
    }
}
