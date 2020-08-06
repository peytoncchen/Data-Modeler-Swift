//
//  ContentView.swift
//  Data Modeler for Power Calculations
//
//  Created by Peyton Chen on 8/5/20.
//  Copyright © 2020 Peyton Chen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var inputViewModel = InputViewModel()
    @ObservedObject var treatmentViewModel = TreatmentViewModel()
    @ObservedObject var blockingViewModel = BlockingViewModel()
    @ObservedObject var errorViewModel = ErrorViewModel()
    @ObservedObject var modelingViewModel = ModelingViewModel()
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    Text("Step 1: Enter inputs:")
                    ForEach(self.inputViewModel.items.indices, id: \.self) { index in
                        InputView(item: self.inputViewModel.items[index], itemValue: self.inputViewModel.binding(for: index))
                    }
                    Button(action: {
                        self.treatmentViewModel.items.removeAll()
                        self.blockingViewModel.items.removeAll()
                        self.treatmentViewModel.addTreatments(count: Int(self.inputViewModel.items[1].value) ?? 0)
                        self.blockingViewModel.addBlocking(count: Int(self.inputViewModel.items[2].value) ?? 0)
                        
                    }) {
                        Text(/*@START_MENU_TOKEN@*/"Continue"/*@END_MENU_TOKEN@*/)
                    }
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 2: Enter blocking factor labels and values (if applicable):")
                    ForEach(self.blockingViewModel.items.indices, id: \.self) { index in
                        BlockingInputView(itemName: self.blockingViewModel.bindingName(for: index), itemValue: self.blockingViewModel.bindingVal(for: index))
                    }
                    Button(action: {
                        self.errorViewModel.items.removeAll()
                        self.errorViewModel.items.append(InputData(id: 0, label: "Total Error SD:", value: ""))
                        self.errorViewModel.addErrors(array: self.blockingViewModel.items)
                    }) {
                        Text(/*@START_MENU_TOKEN@*/"Continue"/*@END_MENU_TOKEN@*/)
                    }
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 3: Enter errors:")
                    ForEach(self.errorViewModel.items.indices, id: \.self) { index in
                        InputView(item: self.errorViewModel.items[index], itemValue: self.errorViewModel.binding(for: index))
                    }
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 4: Enter treatment means:")
                    ForEach(self.treatmentViewModel.items.indices, id: \.self) { index in
                        InputView(item: self.treatmentViewModel.items[index], itemValue: self.treatmentViewModel.binding(for: index))
                    }
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 5: Choose options:")
                    Button(action: {
                        print(self.inputViewModel.items)
                        print(self.blockingViewModel.items)
                        print(self.errorViewModel.items)
                        print(self.treatmentViewModel.items)
                        self.modelingViewModel.prepareBlockErrorText(errorArray: self.errorViewModel.items, blockingArray: self.blockingViewModel.items)
                        
                    }) {
                        Text("Go!")
                    }
                }
            }
            Divider().background(Color.black)
            Text(modelingViewModel.blockText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
