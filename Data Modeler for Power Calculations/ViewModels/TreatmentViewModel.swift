//
//  TreatmentViewModel.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/5/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI

class TreatmentViewModel: ObservableObject {
    @Published var items:[InputData] = []
    
    init() {
        self.items.append(InputData(id: 0, label: "1", value: ""))
        self.items.append(InputData(id: 1, label: "2", value: ""))
    }
    
    func addTreatments(count: Int) {
        self.items.removeAll()
        for i in 0..<count {
            self.items.append(InputData(id: i, label: String(i + 1), value: ""))
        }
    }
    
    func binding(for index: Int) -> Binding<String> {
        Binding( get: {self.items[index].value},
                 set: {self.items[index].value = $0}
        )
    }
}

