//
//  GoalPieChartView.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/8/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit
import Charts

class GoalPieChartView: PieChartView {
    var stepsCount: (total: Int, completed: Int)? {
        didSet {
            guard let stepsCount = stepsCount else { return }
            let dataEntries = [
                PieChartDataEntry(value: Double(stepsCount.completed), label: NSLocalizedString("Completed", comment: "Label of completed steps")),
                PieChartDataEntry(value: Double(stepsCount.total - stepsCount.completed), label: NSLocalizedString("Incomplete", comment: "Label of incomplete steps")),
            ]
            let dataSet = PieChartDataSet(entries: dataEntries)
            dataSet.colors = [.systemOrange, .systemFill]
            let data = PieChartData(dataSet: dataSet)
            let formatter = NumberFormatter()
            formatter.numberStyle = .none
            data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            data.setValueFont(.systemFont(ofSize: 15))
            data.setValueTextColor(.secondaryLabel)
            self.data = data
            updateCenterText()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func updateCenterText() {
        guard let stepsCount = stepsCount else { return }
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.percentSymbol = " %"
        let percent = formatter.string(from: NSNumber(value: Double(stepsCount.completed) / Double(stepsCount.total)))
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 34),
            .foregroundColor: UIColor.systemOrange,
        ]
        centerAttributedText = NSAttributedString(string: percent ?? "", attributes: attributes)
    }

    private func setupViews() {
        highlightPerTapEnabled = false
        rotationEnabled = false
        centerTextRadiusPercent = 0.8
        legend.enabled = false
        holeColor = .systemBackground
    }
}
