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
    
    func processArray(array: [[String]]) {
        for i in 0..<array.count {
            textString.append(array[i].joined(separator: " "))
            textString.append("\n")
        }
    }

    

    func writeToFile(name file: String) {
        let filename = file

        let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        if let fileURL = dir?.appendingPathComponent(filename).appendingPathExtension("txt") {
            let outString = textString
            
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

