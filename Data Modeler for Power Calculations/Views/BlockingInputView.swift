//
//  BlockingInputView.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/5/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI

struct BlockingInputView: View {
    @Binding var itemName: String
    @Binding var itemValue: String
    
    var body: some View {
        HStack {
            TextField("Enter label", text: $itemName)
                .frame(width: 150.0)
            TextField("Enter value", text: $itemValue)
                .frame(width: 75.0)
        }
    }
}
