//
//  BlockingViewModel.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/5/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI

class BlockingViewModel: ObservableObject {
    @Published var items:[InputData] = []
    
    func addBlocking(count: Int) {
        self.items.removeAll()
        for i in 0..<count {
            self.items.append(InputData(id: i, label: "", value: ""))
        }
    }
    
    func bindingName(for index: Int) -> Binding<String> {
        Binding(get: {self.items[index].label},
                set: {self.items[index].label = $0}
        )
    }
    func bindingVal(for index: Int) -> Binding<String> {
        Binding(get: {self.items[index].value},
                set: {self.items[index].value = $0}
        )
    }

}
