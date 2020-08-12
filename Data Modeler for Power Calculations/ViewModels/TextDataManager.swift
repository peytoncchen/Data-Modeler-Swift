//
//  TextDataManager.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/6/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import Foundation

class TextDataManager {
    
    private var textString = ""
    private var SASString = ""
    
    func processArray(array: [[[String]]]) {
        self.textString.removeAll()
        for j in 0..<array.count {
            for i in 0..<array[j].count {
                textString.append(array[j][i].joined(separator: " "))
                textString.append("\n")
            }
            textString.append("\n\n")
        }
    }
    
    func multiSAS(array: [[[String]]], experimentName eName: String) {
        self.SASString.removeAll()
        for sub in array {
            implementSAS(array: sub, experimentName: eName)
        }
    }
    
    private func implementSAS(array: [[String]], experimentName eName: String) {
        var data = ""
        var blockNames = ""
        let names = array[0]
        
        for i in 2..<names.count - 1 {
            let fName = " " + names[i]
            blockNames += fName
        }
        
        for i in 1..<array.count {
            data.append(array[i].joined(separator: " "))
            data.append("\n")
        }
        
        
        SASString.append("DATA \(eName); INPUT \(names[0]) Treatment\(blockNames) \(names[names.count - 1]); Lines;\n\n\(data)\n;\nRUN;\n\nPROC MIXED ASYCOV NOBOUND DATA=\(eName) ALPHA=0.05;\nCLASS Treatment\(blockNames);\nMODEL \(names[names.count - 1]) = Treatment\(blockNames)\n/SOLUTION DDFM=KENWARDROGER;\nlsmeans Treatment / adjust=tukey;\nRUN;\n\n\n")
        
    }

    

    func writeToFile(SAS choice: Bool, url: URL) {
        let fileURL = url
        var outString = ""

        if choice == false {
            outString = textString
        } else {
            outString = SASString
        }
        
        do {
            try outString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }

}


//The following was for testing purposes
//            var inString = ""
//
//            do {
//                inString = try String(contentsOf: fileURL)
//            } catch {
//                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
//            }
//
//            print("Read from file: \(inString)")
//            print(fileURL)
