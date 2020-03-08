//
//  GoalBarChartView.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/8/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit
import Charts

class GoalBarChartView: BarChartView {
    var monthStepsCounts: [MonthStepsCount]? {
        didSet {
            guard let monthStepsCounts = monthStepsCounts else { return }
            let totalDataEntries = monthStepsCounts.enumerated().map {
                return BarChartDataEntry(x: Double($0.offset), y: Double($0.element.total))
            }
            let totalDataSet = BarChartDataSet(entries: totalDataEntries)
            totalDataSet.colors = [.systemFill]
            totalDataSet.drawValuesEnabled = false
            let completedDataEntries = monthStepsCounts.enumerated().map {
                return BarChartDataEntry(x: Double($0.offset), y: Double($0.element.completed))
            }
            let completedDataSet = BarChartDataSet(entries: completedDataEntries)
            completedDataSet.colors = [.systemOrange]
            completedDataSet.drawValuesEnabled = false
            let data = BarChartData(dataSets: [totalDataSet, completedDataSet])
            self.data = data
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

    private func setupViews() {
        scaleYEnabled = false
        legend.enabled = false
        highlightPerTapEnabled = false
        highlightPerDragEnabled = false
        // x
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .secondaryLabel
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = true
        xAxis.valueFormatter = MonthAxisValueFormatter(chartView: self)
        // left
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.labelFont = .systemFont(ofSize: 11)
        leftAxis.labelTextColor = .secondaryLabel
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.gridColor = .tertiaryLabel
        leftAxis.axisMinimum = 0
        leftAxis.granularityEnabled = true
        // right
        rightAxis.enabled = false
    }
}
