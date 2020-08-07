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
    private var errorBlockArray = [Double]()
    
//    func prepareDVText(inputArray: [InputData], treatmentArray: [InputData], errorArray: [InputData], blockingArray: [InputData]) {
//        let total = Int(inputArray[0].value) ?? 0
//        let numTreatments = Int(inputArray[1].value) ?? 0
//        let subjectName = inputArray[3].value ?? "Subject"
//        let dvName = inputArray[4].value ?? "Dependent Variable"
//
//    }
    
    func prepareBlockErrorText(errorArray: [InputData], blockingArray: [InputData]) {
        if errorArray.count != blockingArray.count + 1 {
            fatalError("Bad Input")
        }
        for i in 1..<errorArray.count {
            let temp = addErrorTextAndArray(errorData: errorArray[i], num: Int(blockingArray[i - 1].value) ?? 0) + "\n"
            blockText += temp
        }
    }
    
    private func errorValsBlocking(count: Int, sd: Float) -> [Double] {
        var array = [Double]()
        for _ in 0..<count {
            let rand = Double.random(in: 0...1)
            if let n = Sigma.normalQuantile(p: rand, μ: 0, σ: Double(sd)) {
                array.append(n)
            }
        }
        return array
    }
    
    private func addErrorTextAndArray(errorData: InputData, num: Int) -> String {
        var str = errorData.label + " generated error:\n"
        let stddev = Float(errorData.value) ?? 0.0
        
        let doubleArray = errorValsBlocking(count: num, sd: stddev)
        
        for i in 0..<doubleArray.count {
            let rounded = String(format: "%.6f", doubleArray[i]) + "\n"
            str += rounded
            errorBlockArray.append(doubleArray[i])
        }
        return str
    }
}

