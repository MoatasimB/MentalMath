import SwiftUI

struct ContentView: View {
    
    @State private var selectedTime = 2
    // Binding variable to track switch (toggle) state
    @State private var isAdditionOn = true
    @State private var isSubtractionOn = true
    @State private var isMultiplicationOn = true
    @State private var isDivisionOn = true
    
    // Range bounds for Addition
    @State private var additionLowerBound = "2"
    @State private var additionUpperBound = "100"
    
    // Range bounds for Subtraction
    @State private var subtractionLowerBound = "2"
    @State private var subtractionUpperBound = "100"
    
    // Range bounds for Subtraction
    @State private var multiplicationLowerBound = "2"
    @State private var multiplicationUpperBound = "100"
    
    // Range bounds for Subtraction
    @State private var divisionLowerBound = "2"
    @State private var divisionUpperBound = "100"
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var isGameActive = false

    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                Spacer()
                Text("Arithmetic Game")
                    .font(.largeTitle)
                    .fontWeight(.black)
                Spacer()
                Text("Select Timer Duration (minutes)")
                    .font(.headline)
                
                Picker("Timer", selection: $selectedTime) {
                    Text("1").tag(1)
                    Text("2").tag(2)
                    Text("3").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle()) // Segmented style for a better look
                .padding()
                
                // Addition Toggle
                Toggle("Addition", isOn: $isAdditionOn)
                    .padding()
                
                if isAdditionOn {
                    HStack {
                        Text("Range:")
                        TextField("Lower bound", text: $additionLowerBound)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        
                        Text("-")
                        
                        TextField("Upper bound", text: $additionUpperBound)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                    }
                    .padding(.horizontal)
                }
                
                // Subtraction Toggle
                Toggle("Subtraction", isOn: $isSubtractionOn)
                    .padding()
                
//                if isSubtractionOn && isAdditionOn {
//                    Text("Addition problems in reverse.")
//                    
//                }
//                else if isSubtractionOn {
                if isSubtractionOn {
                    HStack {
                        Text("Range:")
                        TextField("Lower bound", text: $subtractionLowerBound)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        
                        Text("-")
                        
                        TextField("Upper bound", text: $subtractionUpperBound)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                    }
                    .padding(.horizontal)
                }
                
                // Multiplication Toggle
                Toggle("Multiplication", isOn: $isMultiplicationOn)
                    .padding()
                
                if isMultiplicationOn {
                    HStack {
                        Text("Range:")
                        TextField("Lower bound", text: $multiplicationLowerBound)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        
                        Text("-")
                        
                        TextField("Upper bound", text: $multiplicationUpperBound)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                    }
                    .padding(.horizontal)
                }
                
                // Division Toggle
                Toggle("Division", isOn: $isDivisionOn)
                    .padding()
                
//                if isDivisionOn && isMultiplicationOn {
//                    Text("Multiplication problems in reverse.")
//                }
//                else
                if isDivisionOn {
                    HStack {
                        Text("Range:")
                        TextField("Lower bound", text: $divisionLowerBound)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        
                        Text("-")
                        
                        TextField("Upper bound", text: $divisionUpperBound)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                    }
                    .padding(.horizontal)
                }
                
                
                Button("Start Game") {
                    validateAndStartGame()
                    
                }
                .padding()
                .font(.headline)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                NavigationLink(
                                    destination: GameView(
                                        initialTime: selectedTime,
                                        isAdditionOn: isAdditionOn,
                                        additionLowerBound: Int(additionLowerBound) ?? 2,
                                        additionUpperBound: Int(additionUpperBound) ?? 100,
                                        isSubtractionOn: isSubtractionOn,
                                        subtractionLowerBound: Int(subtractionLowerBound) ?? 2,
                                        subtractionUpperBound: Int(subtractionUpperBound) ?? 100,
                                        isMultiplicationOn: isMultiplicationOn,
                                        multiplicationLowerBound: Int(multiplicationLowerBound) ?? 2,
                                        multiplicationUpperBound: Int(multiplicationUpperBound) ?? 100,
                                        isDivisionOn: isDivisionOn,
                                        divisionLowerBound: Int(divisionLowerBound) ?? 2,
                                        divisionUpperBound: Int(divisionUpperBound) ?? 100
                                    ),
                                    isActive: $isGameActive
                                ) {
                                    EmptyView()
                                }
                            }
            .padding()
        }
    }
    
    
    
    func validateAndStartGame() {
        // Check if at least one operation is selected
        if !isAdditionOn && !isSubtractionOn && !isMultiplicationOn && !isDivisionOn {
            alertMessage = "Please select at least one operation."
            showAlert = true
            return
        }
        
        // Validate ranges for each selected operation
        if isAdditionOn {
            if !isValidRange(lower: additionLowerBound, upper: additionUpperBound) {
                alertMessage = "Please enter a valid range for Addition (2-100)."
                showAlert = true
                return
            }
        }
        
        if isSubtractionOn && !isAdditionOn {
            if !isValidRange(lower: subtractionLowerBound, upper: subtractionUpperBound) {
                alertMessage = "Please enter a valid range for Subtraction. (2-100)"
                showAlert = true
                return
            }
        }
        
        if isMultiplicationOn {
            if !isValidRange(lower: multiplicationLowerBound, upper: multiplicationUpperBound) {
                alertMessage = "Please enter a valid range for multiplication (2-100)."
                showAlert = true
                return
            }
        }
        
        if isDivisionOn && !isMultiplicationOn {
            if !isValidRange(lower: subtractionLowerBound, upper: subtractionUpperBound) {
                alertMessage = "Please enter a valid range for division. (2-100)"
                showAlert = true
                return
            }
        }
        
        // If all validations pass, start the game
        print("Game Started with settings:")
        print("Selected Time: \(selectedTime) minute(s)")
        print("Addition: \(isAdditionOn), Range: \(additionLowerBound) - \(additionUpperBound)")
        print("Subtraction: \(isSubtractionOn), Range: \(subtractionLowerBound) - \(subtractionUpperBound)")
        print("Multiplication: \(isMultiplicationOn)")
        print("Division: \(isDivisionOn)")
        
        isGameActive = true
        
    }
    
    // Helper function to validate range input
    func isValidRange(lower: String, upper: String) -> Bool {
        // Convert the lower and upper bounds to integers
        if let lowerBound = Int(lower), let upperBound = Int(upper) {
            return lowerBound <= upperBound && (2<=lowerBound && upperBound<=100) // Valid if lower bound <= upper bound
        }
        return false // Invalid if conversion fails
    }
}


#Preview {
    ContentView()
}
