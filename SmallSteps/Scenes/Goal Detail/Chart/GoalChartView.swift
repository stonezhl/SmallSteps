//
//  GoalChartView.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/7/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit
import Charts

struct MonthStepsCount {
    let year: Int
    let month: Int
    let total: Int
    let completed: Int
}

class GoalChartView: UIView {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        return scrollView
    }()

    lazy var pieChartView: GoalPieChartView = {
        let chartView = GoalPieChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(chartView)
        return chartView
    }()

    lazy var barChartView: GoalBarChartView = {
        let chartView = GoalBarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(chartView)
        return chartView
    }()

    var monthStepsCounts: [MonthStepsCount] {
        get {
            return barChartView.monthStepsCounts ?? []
        }
        set {
            var total = 0
            var completed = 0
            newValue.forEach { count in
                total += count.total
                completed += count.completed
            }
            pieChartView.stepsCount = (total: total, completed: completed)
            barChartView.monthStepsCounts = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }

    private func setupConstraints() {
        let constraints = [
            // scroll
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            // pie
            pieChartView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 22),
            pieChartView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            pieChartView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -44),
            pieChartView.heightAnchor.constraint(equalTo: pieChartView.widthAnchor),
            // bar
            barChartView.topAnchor.constraint(equalTo: pieChartView.bottomAnchor, constant: 22),
            barChartView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -22),
            barChartView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            barChartView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            barChartView.heightAnchor.constraint(equalTo: barChartView.widthAnchor, multiplier: 0.85),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
