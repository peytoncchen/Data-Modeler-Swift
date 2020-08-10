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
    
    func processArray(array: [[String]]) {
        textString.removeAll()
        for i in 0..<array.count {
            textString.append(array[i].joined(separator: " "))
            textString.append("\n")
        }
    }
    
    func implementSAS(array: [[String]], experimentName eName: String) {
        SASString.removeAll()
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
        
        
        SASString = "DATA \(eName); INPUT \(names[0]) Treatment\(blockNames) \(names[names.count - 1]); Lines;\n\n\(data)\n;\nRUN;\n\nPROC MIXED ASYCOV NOBOUND DATA=\(eName) ALPHA=0.05;\nCLASS Treatment\(blockNames);\nMODEL \(names[names.count - 1]) = Treatment\(blockNames)\n/SOLUTION DDFM=KENWARDROGER;\nlsmeans Treatment / adjust=tukey;\nRUN;"
        
    }

    

    func writeToFile(name file: String, SAS choice: Bool) {
        let filename = file
        var outString = ""
        
        let url = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first

        if let fileURL = url?.appendingPathComponent(filename).appendingPathExtension("txt") {
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
            
            var inString = ""
            
            do {
                inString = try String(contentsOf: fileURL)
            } catch {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
            print("Read from file: \(inString)")
            print(fileURL)
        }
    }
}

