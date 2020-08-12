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
    @ObservedObject var warningsManager = WarningsManger()
    var textDataManager = TextDataManager()
    @State var labelShown = false
    @State var exportShown = false
    @State var numGenTimes = 1
    @State var textFileName = "DataExport"
    @State var SASFileName = "SASExport"
    @State var SASExperimentName = "ExperimentName"
    
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
                        if self.warningsManager.gen1Warnings(inputs: self.inputViewModel.items) {
                            return
                        } else {
                            self.treatmentViewModel.addTreatments(count: Int(self.inputViewModel.items[1].value)!)
                            self.blockingViewModel.addBlocking(count: Int(self.inputViewModel.items[2].value)!)
                        }
                        if self.inputViewModel.items[3].value == "" {
                            self.inputViewModel.items[3].value = "Measurement"
                        }
                        if self.inputViewModel.items[4].value == "" {
                            self.inputViewModel.items[4].value = "DependentVar"
                        }
                        
                    }) {
                        Text("Continue/Update")
                    }
                    Text(self.warningsManager.step1Warnings)
                        .foregroundColor(Color.red)
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 2: Enter blocking factor labels and values (if applicable):")
                    ScrollView {
                        ForEach(self.blockingViewModel.items.indices, id: \.self) { index in
                            BlockingInputView(itemName: self.blockingViewModel.bindingName(for: index), itemValue: self.blockingViewModel.bindingVal(for: index))
                        }
                    }
                        .frame(height: 40.0)
                    Button(action: {
                        if self.warningsManager.gen2Warnings(bInputs: self.blockingViewModel.items) {
                            return
                        } else {
                            self.errorViewModel.addErrors(array: self.blockingViewModel.items)
                        }
                    }) {
                        Text("Continue/Update")
                    }
                    Text(self.warningsManager.step2Warnings)
                        .foregroundColor(Color.red)
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 3: Enter errors:")
                    ScrollView {
                        ForEach(self.errorViewModel.items.indices, id: \.self) { index in
                            InputView(item: self.errorViewModel.items[index], itemValue: self.errorViewModel.binding(for: index))
                        }
                    }
                        .frame(height: 70.0)
                }
                Divider().frame(width: 350.0).background(Color.black)
                VStack {
                    Text("Step 4: Enter treatment means:")
                    ScrollView {
                        ForEach(self.treatmentViewModel.items.indices, id: \.self) { index in
                            InputView(item: self.treatmentViewModel.items[index], itemValue: self.treatmentViewModel.binding(for: index))
                        }
                    }
                        .frame(height: 70.0)
                    HStack {
                        Button(action: {
                            if self.warningsManager.gen3And4Warnings(eInputs: self.errorViewModel.items, tInputs: self.treatmentViewModel.items) {
                                return
                            } else {
                                self.modelingViewModel.prepareBlockErrorTextAndArray(errorArray: self.errorViewModel.items, blockingArray: self.blockingViewModel.items, numDV: Int(self.inputViewModel.items[0].value)!)
                                self.distributeViewModel.addLines(inputArray: self.inputViewModel.items, blockingArray: self.blockingViewModel.items)
                                self.modelingViewModel.displaytMean(tArray: self.treatmentViewModel.items)
                                self.labelShown = true
                            }
                        }) {
                            Text("Continue")
                        }
                        if labelShown {
                            Button(action: {
                                if self.warningsManager.gen3And4Warnings(eInputs: self.errorViewModel.items, tInputs: self.treatmentViewModel.items) {
                                    return
                                } else {
                                    self.modelingViewModel.prepareBlockErrorTextAndArray(errorArray: self.errorViewModel.items, blockingArray: self.blockingViewModel.items, numDV: Int(self.inputViewModel.items[0].value)!)
                                    self.modelingViewModel.displaytMean(tArray: self.treatmentViewModel.items)
                                    self.exportShown = false
                                }
                            }) {
                                Text("Update Error/Treatment Means")
                            }
                        }
                    }
                    Text(self.warningsManager.step3Warnings)
                        .foregroundColor(Color.red)
                    Text(self.warningsManager.step4Warnings)
                        .foregroundColor(Color.red)
                }
                Divider().frame(width: 350.0).background(Color.black)
                Text("Step 5: Distribute groups ->")
            }
            Spacer()
            Divider().background(Color.black)
            Spacer()
            VStack {
                Spacer()
                HStack {
                    if labelShown {
                        Text(inputViewModel.items[3].value)
                        Text("Treatment")
                            .padding(.trailing)
                        ForEach(self.blockingViewModel.items.indices, id: \.self) { index in
                            Text(self.blockingViewModel.items[index].label).padding(.trailing)
                        }
                        if exportShown {
                            Text(inputViewModel.items[4].value)
                        }
                        Spacer()
                            .frame(width: 15.0)
                    }
                }
                ScrollView {
                    ForEach(self.distributeViewModel.items.indices, id: \.self) { index in
                        GridView(input: self.distributeViewModel.items[index],  assignTNum: self.distributeViewModel.bindingTN(for: index), assignBArray: self.distributeViewModel.bindingBF(for: index))
                    }
                }.padding(.bottom)
                Button(action: {
                    if self.warningsManager.gen5Warnings(aInputs: self.distributeViewModel.items, oneInputs: self.inputViewModel.items, bInputs: self.blockingViewModel.items) {
                        return
                    } else {
                        self.modelingViewModel.multipleRunArray.removeAll()
                        self.modelingViewModel.prepareTextFile(subName: self.inputViewModel.items[3].value, blockArray: self.blockingViewModel.items, dvName: self.inputViewModel.items[4].value)
                        self.modelingViewModel.prepareDVTextAndArray(assignArray: self.distributeViewModel.items, treatmentArray: self.treatmentViewModel.items, errorArray: self.errorViewModel.items)
                        self.distributeViewModel.addDV(dvArray: self.modelingViewModel.dvArray)
                        self.exportShown = true
                        self.numGenTimes = 1
                    }
                }) {
                    Text("Reset/Generate Dependent Variable Values")
                }
                    .padding(.bottom)
                    .opacity(labelShown ? 1 : 0)
                Text(self.warningsManager.step5Warnings).foregroundColor(Color.red)
                HStack {
                    Button(action: {
                        if self.warningsManager.gen5Warnings(aInputs: self.distributeViewModel.items, oneInputs: self.inputViewModel.items, bInputs: self.blockingViewModel.items) {
                            return
                        } else {
                            self.modelingViewModel.prepareTextFile(subName: self.inputViewModel.items[3].value, blockArray: self.blockingViewModel.items, dvName: self.inputViewModel.items[4].value)
                            self.modelingViewModel.prepareDVTextAndArray(assignArray: self.distributeViewModel.items, treatmentArray: self.treatmentViewModel.items, errorArray: self.errorViewModel.items)
                            self.distributeViewModel.addDV(dvArray: self.modelingViewModel.dvArray)
                        }
                        self.numGenTimes += 1
                    }) {
                        Text("Add run")
                    }
                    Text("Current run count: \(String(numGenTimes))")
                }
                    .padding(.bottom)
                    .opacity(exportShown ? 1 : 0)
                HStack {
                    Text("Enter Text File Name:")
                    TextField("File Name", text: $textFileName)
                        .frame(width: 125.0)
                    Button(action: {
                        if self.textFileName == "" {
                            self.textFileName = "DataExport"
                        }
                        self.textDataManager.processArray(array: self.modelingViewModel.multipleRunArray)
                        self.textDataManager.writeToFile(name: self.textFileName, SAS: false)
                    }) {
                        Text("Export run(s) to text file")
                    }
                }
                    .padding(.bottom)
                    .opacity(exportShown ? 1 : 0)
                
                HStack {
                    Text("Enter SAS File Name and Experiment Name:")
                    VStack {
                        TextField("SAS File Name", text: $SASFileName)
                        TextField("Experiment Name", text: $SASExperimentName)
                    }
                        .frame(width: 125.0)
                    Button(action: {
                        if self.SASFileName == "" {
                            self.SASFileName = "SASExport"
                        }
                        if self.SASExperimentName == "" {
                            self.SASExperimentName = "ExperimentName"
                        }
                        self.textDataManager.multiSAS(array: self.modelingViewModel.multipleRunArray, experimentName: self.SASExperimentName)
                        self.textDataManager.writeToFile(name: self.SASFileName, SAS: true)
                    }) {
                        Text("Export SAS run(s) to text file")
                    }
                }
                    .padding(.bottom)
                    .opacity(exportShown ? 1 : 0)
                HStack {
                    ScrollView {
                        Text(modelingViewModel.blockText)
                    }
                    ScrollView {
                        Text(modelingViewModel.treatmentText)
                    }
                }
                .padding(.bottom)
                    .frame(height: 200.0)
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
