//
//  ModelingBrain.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/5/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import Foundation
import SigmaSwiftStatistics

struct ModelingBrain {
    func errorValsBlocking(count: Int, sd: Float) -> [Double] {
        var array = [Double]()
        for _ in 0..<count {
            let rand = Double.random(in: 0...1)
            if let n = Sigma.normalQuantile(p: rand, μ: 0, σ: Double(sd)) {
                array.append(n)
            }
        }
        return array
    }
}
