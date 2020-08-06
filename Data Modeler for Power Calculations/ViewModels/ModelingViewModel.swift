//
//  ModelingViewModel.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/5/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI
import SigmaSwiftStatistics

class ModelingViewModel: ObservableObject{
    @Published var blockText: String = ""
    
    func prepareBlockErrorText(errorArray: [InputData], blockingArray: [InputData]) {
        if errorArray.count != blockingArray.count + 1 {
            fatalError("Bad Input")
        }
        for i in 1..<errorArray.count {
            let temp = addText(errorData: errorArray[i], num: Int(blockingArray[i - 1].value) ?? 0)
            blockText += temp
        }
    }
    
    private func errorValsBlocking(count: Int, sd: Float) -> [String] {
        var array = [String]()
        for _ in 0..<count {
            let rand = Double.random(in: 0...1)
            if let n = Sigma.normalQuantile(p: rand, μ: 0, σ: Double(sd)) {
                let rounded = String(format: "%.6f", n) + "\n"
                array.append(rounded)
            }
        }
        return array
    }
    
    private func addText(errorData: InputData, num: Int) -> String {
        var str = errorData.label + ":\n"
        let stddev = Float(errorData.value) ?? 0.0
        
        let strArray = errorValsBlocking(count: num, sd: stddev)
        
        for i in 0..<strArray.count {
            str += strArray[i]
        }
        
        return str
    }
}

