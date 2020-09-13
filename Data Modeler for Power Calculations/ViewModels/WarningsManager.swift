//
//  WarningsManager.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/10/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import Foundation

class WarningsManger: ObservableObject {
    @Published var step1Warnings = ""
    @Published var step2Warnings = ""
    @Published var step3Warnings = ""
    @Published var step4Warnings = ""
    @Published var step5Warnings = ""
    
    func gen1Warnings(inputs: [InputData]) -> Bool {
        step1Warnings.removeAll()
        guard Int(inputs[0].value) != nil else {
            step1Warnings.append("Integer input required for total measurements")
            return true
        }
        guard Int(inputs[1].value) != nil else {
            step1Warnings.append("Integer input required for number of treatments")
            return true
        }
        guard Int(inputs[2].value) != nil else {
            step1Warnings.append("Integer input required for number of blocking factors")
            return true
        }
        guard !inputs[3].value.contains(" ") else {
            step1Warnings.append("Labels must be one word (no spaces) to ensure compatability with SAS")
            return true
        }
        guard !inputs[4].value.contains(" ") else {
            step1Warnings.append("Labels must be one word (no spaces) to ensure compatability with SAS")
            return true
        }
        return false
    }
    
    func gen2Warnings(bInputs: [InputData]) -> Bool {
        step2Warnings.removeAll()
        for input in bInputs {
            guard !input.label.contains(" ") else {
                step2Warnings.append("Labels must be one word (no spaces) to ensure compatability with SAS")
                return true
            }
            guard Int(input.value) != nil else {
                step2Warnings.append("Integer input required for each value of blocking factor")
                return true
            }
        }
        return false
    }
    
    func gen3And4Warnings(eInputs: [InputData], tInputs: [InputData]) -> Bool {
        step3Warnings.removeAll()
        step4Warnings.removeAll()
        for input in eInputs {
            guard Double(input.value) != nil else {
                step3Warnings.append("Decimal or integer input required for each SD")
                return true
            }
        }
        for input in tInputs {
            guard Double(input.value) != nil else {
                step4Warnings.append("Decimal or integer input required for each treatment mean")
                return true
            }
        }
        return false
    }
    
    func gen5Warnings(aInputs: [AssignData], oneInputs: [InputData], bInputs: [InputData]) -> Bool {
        step5Warnings.removeAll()
        let treatmentRange = Int(oneInputs[1].value)!
        for input in aInputs {
            guard Int(input.treatmentNum) != nil else {
                step5Warnings.append("Treatment numbers must be integers")
                return true
            }
            guard 1...treatmentRange ~= Int(input.treatmentNum)! else {
                step5Warnings.append("Please enter valid treatment numbers")
                return true
            }
            for i in 0..<input.blockFacs.count {
                guard Int(input.blockFacs[i]) != nil else {
                    step5Warnings.append("Blocking factor values must be integers")
                    return true
                }
                guard 1...Int(bInputs[i].value)! ~= Int(input.blockFacs[i])! else {
                    step5Warnings.append("Please enter valid blocking factor numbers")
                    return true
                }
            }
        }
        return false
    }
}
