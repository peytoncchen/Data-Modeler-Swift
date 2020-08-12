//
//  ErrorViewModel.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/5/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI

class ErrorViewModel: ObservableObject {
    @Published var items:[InputData] = [InputData(id: 0, label: "Total Error SD:", value: "")]
    
    func addErrors(array: [InputData]) {
        self.items.removeAll()
        self.items.append(InputData(id: 0, label: "Total Error SD:", value: ""))
        for i in 0..<array.count {
            self.items.append(InputData(id: i + 1, label: array[i].label + " SD:", value: ""))
        }
    }
    
    func binding(for index: Int) -> Binding<String> {
        Binding( get: {self.items[index].value},
                 set: {self.items[index].value = $0}
        )
    }
}

