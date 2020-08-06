//
//  InputViewModel.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/5/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI

class InputViewModel: ObservableObject {
    @Published var items:[InputData] = []
    
    init() {
        addItems()
    }
    
    func addItems() {
        self.items.append(InputData(id: 0, label: "Total measurements:", value: ""))
        self.items.append(InputData(id: 1, label: "Number of treatments:", value: ""))
        self.items.append(InputData(id: 2, label: "Number of blocking factors:", value: ""))
        self.items.append(InputData(id: 3, label: "Name of animal model:", value: ""))
        self.items.append(InputData(id: 4, label: "Dependent variable name:", value: ""))
    }
    
    func binding(for index: Int) -> Binding<String> {
        Binding(get: {self.items[index].value},
                set: {self.items[index].value = $0}
        )
    }
}
