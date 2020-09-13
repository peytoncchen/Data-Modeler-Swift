//
//  InputView.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/5/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI

struct InputView: View {
    var item: InputData
    @Binding var itemValue: String
    
    var body: some View {
        HStack {
            Text(item.label)
            TextField("Enter value", text: $itemValue)
                .frame(width: 100.0)
        }
    }
}
