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
    @ObservedObject var distributeViewModel = DistributeViewModel()
    var textDataManager = TextDataManager()
    @State var labelShown = false
    @State var exportTxtShown = false
    @State var exportSASShown = false
    @State var numGenTimes = 1
    
    var body: some View {
        HStack {
            Spacer()
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
                        Text("Continue")
                    }
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 2: Enter blocking factor labels and values (if applicable):")
                    ScrollView {
                        ForEach(self.blockingViewModel.items.indices, id: \.self) { index in
                            BlockingInputView(itemName: self.blockingViewModel.bindingName(for: index), itemValue: self.blockingViewModel.bindingVal(for: index))
                        }
                    }
                    .frame(height: 50.0)
                    Button(action: {
                        self.errorViewModel.items.removeAll()
                        self.errorViewModel.items.append(InputData(id: 0, label: "Total Error SD:", value: ""))
                        self.errorViewModel.addErrors(array: self.blockingViewModel.items)
                    }) {
                        Text("Continue")
                    }
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 3: Enter errors:")
                    ScrollView {
                        ForEach(self.errorViewModel.items.indices, id: \.self) { index in
                            InputView(item: self.errorViewModel.items[index], itemValue: self.errorViewModel.binding(for: index))
                        }
                    }
                    .frame(height: 50.0)
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 4: Enter treatment means:")
                    ScrollView {
                        ForEach(self.treatmentViewModel.items.indices, id: \.self) { index in
                            InputView(item: self.treatmentViewModel.items[index], itemValue: self.treatmentViewModel.binding(for: index))
                        }
                    }
                    .frame(height: 50.0)
                    Button(action: {
                        self.modelingViewModel.prepareBlockErrorTextAndArray(errorArray: self.errorViewModel.items, blockingArray: self.blockingViewModel.items, numDV: Int(self.inputViewModel.items[0].value) ?? 0)
                        self.distributeViewModel.items.removeAll()
                        self.distributeViewModel.addLines(inputArray: self.inputViewModel.items, blockingArray: self.blockingViewModel.items)
                        self.labelShown = true
                    }) {
                        Text("Continue")
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 5: Distribute groups ->")
                    }
                    
                }
            }
            Spacer()
            Divider().background(Color.black)
            Spacer()
            VStack {
                Spacer()
                HStack {
                    Text(inputViewModel.items[3].value)
                    Text("Treatment")
                        .padding(.trailing)
                    ForEach(self.blockingViewModel.items.indices, id: \.self) { index in
                        Text(self.blockingViewModel.items[index].label).padding(.trailing)
                    }
                    Text(inputViewModel.items[4].value)
                    Spacer()
                        .frame(width: 15.0)
                }.opacity(labelShown ? 1 : 0)
                ScrollView {
                    ForEach(self.distributeViewModel.items.indices, id: \.self) { index in
                        GridView(input: self.distributeViewModel.items[index],  assignTNum: self.distributeViewModel.bindingTN(for: index), assignBArray: self.distributeViewModel.bindingBF(for: index))
                    }
                }.padding(.bottom)
                Button(action: {
                    self.textDataManager.textString.removeAll()
                    self.textDataManager.SASString.removeAll()
                    self.modelingViewModel.prepareTextFile(subName: self.inputViewModel.items[3].value, blockArray: self.blockingViewModel.items, dvName: self.inputViewModel.items[4].value)
                    self.modelingViewModel.prepareDVTextAndArray(assignArray: self.distributeViewModel.items, treatmentArray: self.treatmentViewModel.items, errorArray: self.errorViewModel.items)
                    self.distributeViewModel.addDV(dvArray: self.modelingViewModel.dvArray)
                    self.exportTxtShown = true
                    self.exportSASShown = true
                    self.numGenTimes = 1
                }) {
                    Text("Reset/Generate Dependent Variable Values")
                }
                    .padding(.bottom)
                    .opacity(labelShown ? 1 : 0)
                
                HStack {
                    Button(action: {
                        self.modelingViewModel.prepareTextFile(subName: self.inputViewModel.items[3].value, blockArray: self.blockingViewModel.items, dvName: self.inputViewModel.items[4].value)
                        self.modelingViewModel.prepareDVTextAndArray(assignArray: self.distributeViewModel.items, treatmentArray: self.treatmentViewModel.items, errorArray: self.errorViewModel.items)
                        self.distributeViewModel.addDV(dvArray: self.modelingViewModel.dvArray)
                        self.numGenTimes += 1
                    }) {
                        Text("Add run")
                    }
                    Text("Current run count: \(String(numGenTimes))")
                }
                    .padding(.bottom)
                    .opacity(exportTxtShown ? 1 : 0)
                
                Button(action: {
                    self.textDataManager.processArray(array: self.modelingViewModel.multipleRunArray)
                    self.textDataManager.writeToFile(name: "Coformulation2", SAS: false)
                    self.exportSASShown = true
                }) {
                    Text("Export to text file")
                }
                    .padding(.bottom)
                    .opacity(exportTxtShown ? 1 : 0)
                
                Button(action: {
                    self.textDataManager.multiSAS(array: self.modelingViewModel.multipleRunArray, experimentName: "Coformulation2SAS")
                    self.textDataManager.writeToFile(name: "Coformulation2SAS", SAS: true)
                }) {
                    Text("Export SAS to text file")
                }
                    .padding(.bottom)
                    .opacity(exportSASShown ? 1 : 0)
                
                Text(modelingViewModel.blockText)
                Spacer()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
