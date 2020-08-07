//
//  DistributeView.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/6/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI

struct GridView: View {
    var input: AssignData
    @Binding var assignTNum: String
    @Binding var assignBArray: [String]
    var body: some View {
        HStack {
            Text(String(input.subjectNum))
            TextField("Enter value", text: $assignTNum).frame(width: 75.0)
            ForEach(self.input.blockFacs.indices, id: \.self) { index in
                TextField("Enter value", text: self.$assignBArray[index]).frame(width: 75.0)
            }
        }
    }
}
