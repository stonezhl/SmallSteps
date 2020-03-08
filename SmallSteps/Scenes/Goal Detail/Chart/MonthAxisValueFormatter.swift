//
//  MonthAxisValueFormatter.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/8/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import Foundation
import Charts

class MonthAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chartView: GoalBarChartView?

    init(chartView: GoalBarChartView) {
        self.chartView = chartView
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        guard let monthStepsCount = chartView?.monthStepsCounts?[index] else { return "" }
        let monthText = Calendar.current.shortMonthSymbols[monthStepsCount.month-1]
        return "\(monthText)\n\(monthStepsCount.year)"
    }
}
