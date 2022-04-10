//
//  ContentView.swift
//  iConvert
//
//  Created by Emmanuel K. Nketia on 4/9/22.
//

import SwiftUI

struct ContentView: View {
    @State private var input = 100.0
    @State private var selectedUnits = 0
    @State private var inputUnit: Dimension = UnitLength.meters
    @State private var outputUnit: Dimension = UnitLength.kilometers
    @FocusState private var inputFocused: Bool
    
    
    let conversions = ["Distance", "Mass", "Temperature", "Time"]
    let unitType = [
        [UnitLength.feet, UnitLength.kilometers, UnitLength.meters, UnitLength.miles, UnitLength.yards],
        [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds],
        [UnitTemperature.fahrenheit, UnitTemperature.celsius, UnitTemperature.kelvin],
        [UnitDuration.hours, UnitDuration.minutes, UnitDuration.seconds],
        
    ]
    
    
    
    let formatter : MeasurementFormatter
    
    var result: String {
        let inputMeasurement = Measurement(value: input, unit: inputUnit)
        let outputMeasurement = inputMeasurement.converted(to: outputUnit)
        return formatter.string(from: outputMeasurement)
        
    }
    
    var body: some View {
        NavigationView {
            Form{
                Section{
                    TextField("Amount", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputFocused)
                } header: {
                    Text("Amount to convert")
                }
                
                Picker("Conversion", selection: $selectedUnits) {
                    ForEach (0..<conversions.count) {
                        Text (conversions[$0])
                    }
                }
                
                Picker("Convert from:", selection: $inputUnit){
                    ForEach(unitType[selectedUnits], id: \.self) {
                        Text(formatter.string(from: $0).capitalized)
                    }
                }
                Picker("Convert to:", selection: $outputUnit){
                    ForEach(unitType[selectedUnits], id: \.self) {
                        Text(formatter.string(from: $0).capitalized)
                    }
                }
                
                Section{
                    Text(result)
                } header: {
                    Text("Results")
                }
            }
            .navigationTitle("iConvert")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done"){
                        inputFocused = false
                    }
                }
            }
            .onChange(of: selectedUnits) { newSelection in
                let units = unitType[newSelection]
                inputUnit = units[0]
                outputUnit = units[1]
                
            }
        }
    }
    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .long
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
