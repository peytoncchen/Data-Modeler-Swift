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
    var errorBlockArray = [[Double]]()
    
    func prepareBlockErrorText(errorArray: [InputData], blockingArray: [InputData]) {
        if errorArray.count != blockingArray.count + 1 {
            fatalError("Bad Input")
        }
        
        for _ in 0..<blockingArray.count {
            let empty = [Double]()
            errorBlockArray.append(empty)
        }
        
        for i in 1..<errorArray.count {
            let temp = addErrorTextAndArray(errorData: errorArray[i], num: Int(blockingArray[i - 1].value) ?? 0, errorNum: i - 1) + "\n"
            blockText += temp
        }
    }
    
    private func addDVLine(assignData: AssignData, inputData: InputData, treatmentData: InputData, totalError: Double) -> [String] {
        var array = [String]()
        var dvVal = 0.0
        guard let treatmentNum = Int(assignData.treatmentNum) else {return array}
        array.append(String(assignData.subjectNum))
        array.append(String(treatmentNum))
        guard let treatmentMean = Double(treatmentData.value) else {return array}
        dvVal += treatmentMean
        
        let rand = Double.random(in: 0...1)
        if let n = Sigma.normalQuantile(p: rand, μ: 0, σ: totalError) {
            dvVal += n
        }
        
        for i in 0..<assignData.blockFacs.count {
            guard let blockFacNum = Int(assignData.blockFacs[i]) else {return array}
            array.append(String(blockFacNum))
            dvVal += errorBlockArray[i][blockFacNum]
        }
        return array
        
    }
    
    private func errorVals(count: Int, sd: Float) -> [Double] {
        var array = [Double]()
        for _ in 0..<count {
            let rand = Double.random(in: 0...1)
            if let n = Sigma.normalQuantile(p: rand, μ: 0, σ: Double(sd)) {
                array.append(n)
            }
        }
        return array
    }
    
    private func addErrorTextAndArray(errorData: InputData, num: Int, errorNum: Int) -> String {
        var str = errorData.label + " generated error:\n"
        let stddev = Float(errorData.value) ?? 0.0
        
        let doubleArray = errorVals(count: num, sd: stddev)
        
        for i in 0..<doubleArray.count {
            let rounded = String(format: "%.6f", doubleArray[i]) + "\n"
            str += rounded
            errorBlockArray[errorNum].append(doubleArray[i])
        }
        return str
    }
}

