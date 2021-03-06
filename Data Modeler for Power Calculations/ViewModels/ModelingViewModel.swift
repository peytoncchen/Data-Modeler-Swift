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
    @Published var treatmentText: String = ""
    var dvArray: [String] = []
    var errorBlockArray = [[Double]]()
    var fullArray = [[String]]()
    var multipleRunArray = [[[String]]]()
    private var tMeanArray = [Double]()
    
    func prepareBlockErrorTextAndArray(errorArray: [InputData], blockingArray: [InputData], numDV: Int) {
        blockText.removeAll()
        errorBlockArray.removeAll()
        
        for _ in 0..<blockingArray.count {
            let empty = [Double]()
            errorBlockArray.append(empty)
        }
        
        for i in 1..<errorArray.count {
            let str = addErrorTextAndArray(errorData: errorArray[i], num: Int(blockingArray[i - 1].value)!, errorNum: i - 1) + "\n"
            blockText += str
        }
    }
    
    func displaytMean(tArray: [InputData]) {
        treatmentText.removeAll()
        treatmentText.append("Treatment Means:\n")
        for i in 0..<tArray.count {
            treatmentText.append("\(String(i + 1)): ")
            treatmentText.append("\(tArray[i].value)\n")
        }
    }
    
    func prepareDVTextAndArray(assignArray: [AssignData], treatmentArray: [InputData], errorArray: [InputData]) {
        guard let totalError = Double(errorArray[0].value) else {return}

        tMeanArray.removeAll()
        dvArray.removeAll()
        
        for i in 0..<treatmentArray.count {
            guard let mean = Double(treatmentArray[i].value) else {return}
            tMeanArray.append(mean)
        }

        for i in 0..<assignArray.count {
            let array = addDVLine(assignData: assignArray[i], meanArray: tMeanArray, totalError: totalError)
            fullArray.append(array)
            let dvStr = array[array.count - 1]
            dvArray.append(dvStr)
        }
        multipleRunArray.append(fullArray)
    }
    
    func prepareTextFile(subName: String, blockArray: [InputData], dvName: String) {
        fullArray.removeAll()
        var adding = [String]()
        adding.append(subName)
        adding.append("Treatment")
        for factor in blockArray {
            adding.append(factor.label)
        }
        adding.append(dvName)
        fullArray.append(adding)
    }
    
    private func addDVLine(assignData: AssignData, meanArray: [Double], totalError: Double) -> [String] {
        var array = [String]()
        var dvVal = 0.0
        guard let treatmentNum = Int(assignData.treatmentNum) else {return array}
        array.append(String(assignData.subjectNum))
        array.append(String(treatmentNum))
        let tMean = meanArray[treatmentNum - 1]
        dvVal += tMean
        
        let rand = Double.random(in: 0...1)
        if let n = Sigma.normalQuantile(p: rand, μ: 0, σ: totalError) {
            dvVal += n
        }
        
        for i in 0..<assignData.blockFacs.count {
            guard let blockFacNum = Int(assignData.blockFacs[i]) else {return array}
            array.append(String(blockFacNum))
            dvVal += errorBlockArray[i][blockFacNum - 1]
        }
        array.append(String(format: "%.4f", dvVal))
        return array
        
    }
    
    private func errorVals(count: Int, sd: Double) -> [Double] {
        var array = [Double]()
        for _ in 0..<count {
            let rand = Double.random(in: 0...1)
            if let n = Sigma.normalQuantile(p: rand, μ: 0, σ: sd) {
                array.append(n)
            }
        }
        return array
    }
    
    private func addErrorTextAndArray(errorData: InputData, num: Int, errorNum: Int) -> String {
        var str = errorData.label
        str.removeLast()
        str += " generated error:\n"
        let stddev = Double(errorData.value)!
        
        let doubleArray = errorVals(count: num, sd: stddev)
        
        for i in 0..<doubleArray.count {
            str += "\(i + 1): "
            let rounded = String(format: "%.4f", doubleArray[i]) + "\n"
            str += rounded
            errorBlockArray[errorNum].append(doubleArray[i])
        }
        return str
    }
}

