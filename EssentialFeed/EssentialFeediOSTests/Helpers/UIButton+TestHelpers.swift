//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by John Roque Jorillo on 3/13/21.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
