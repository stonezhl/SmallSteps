//
//  StepButton.swift
//  SmallSteps
//
//  Created by Stone Zhang on 3/14/20.
//  Copyright © 2020 Stone Zhang. All rights reserved.
//

import UIKit

class StepButton: UIButton {
    var isLeftFoot: Bool = false {
        didSet {
            let imageName = isLeftFoot ? "left_foot" : "right_foot"
            let image = UIImage(named: imageName)
            let footImage = image?.withRenderingMode(.alwaysTemplate)
            setImage(footImage, for: .normal)
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView?.tintColor = .systemOrange
                startEnlargementAnimation()
            } else {
                imageView?.tintColor = .systemFill
            }
        }
    }

    private func startEnlargementAnimation() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.scale"
        animation.values = [1.2, 1.5, 1.2]
        animation.duration = 0.25
        animation.calculationMode = .cubic
        imageView?.layer.add(animation, forKey: nil)
    }
}
