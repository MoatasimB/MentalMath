//
//  GameView.swift
//  MentalMath
//
//  Created by Moat on 10/29/24.
//

import SwiftUI

struct GameView: View {
    // Selected time for the game in minutes (converted to seconds)
    let initialTime: Int
    let isAdditionOn: Bool
    let additionLowerBound: Int
    let additionUpperBound: Int
    let isSubtractionOn: Bool
    let subtractionLowerBound: Int
    let subtractionUpperBound: Int
    let isMultiplicationOn: Bool
    let multiplicationLowerBound: Int
    let multiplicationUpperBound: Int
    let isDivisionOn: Bool
    let divisionLowerBound: Int
    let divisionUpperBound: Int

    // Timer and game state
    @State private var timeRemaining: Int
    @State private var currentQuestion = "What is 3 + 5?" // Placeholder question, replace with dynamic question generation
    @State private var userAnswer = ""
    @State private var correctAnswer: Int = 0
    @State private var currentScore = 0

    
    @State private var showAlert = false // State to show the end game alert
    @Environment(\.presentationMode) var presentationMode // To go back to the main menu
    // Timer for countdown
    @State private var timer: Timer?

    init(initialTime: Int, isAdditionOn: Bool, additionLowerBound: Int, additionUpperBound: Int, isSubtractionOn: Bool, subtractionLowerBound: Int, subtractionUpperBound: Int, isMultiplicationOn: Bool, multiplicationLowerBound: Int, multiplicationUpperBound: Int, isDivisionOn: Bool, divisionLowerBound: Int, divisionUpperBound: Int ) {
        // Convert minutes to seconds
        self.initialTime = initialTime * 60
        self.isAdditionOn = isAdditionOn
        self.additionLowerBound = additionLowerBound
        self.additionUpperBound = additionUpperBound
        self.isSubtractionOn = isSubtractionOn
        self.subtractionLowerBound = subtractionLowerBound
        self.subtractionUpperBound = subtractionUpperBound
        self.isMultiplicationOn = isMultiplicationOn
        self.multiplicationLowerBound = multiplicationLowerBound
        self.multiplicationUpperBound = multiplicationUpperBound
        self.isDivisionOn = isDivisionOn
        self.divisionLowerBound = divisionLowerBound
        self.divisionUpperBound = divisionUpperBound
        _timeRemaining = State(initialValue: initialTime * 60)

    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Time Remaining: \(timeRemaining) seconds")
                .font(.headline)
                .padding()
            Text("SCORE: " + String(currentScore))
                .font(.headline)
                .padding()
            Spacer()
            Text(currentQuestion)
                .font(.largeTitle)
                .padding()
            
            TextField("Enter your answer", text: $userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
                .onChange(of: userAnswer) {
                    checkAnswer()
                }
            
            Spacer()
        }
        .onAppear {
            startTimer()
            generateQuestion()
        }
        .onDisappear(perform: stopTimer)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Time's Up!"),
                message: Text("Your score: \(currentScore)"),
                primaryButton: .default(Text("Restart")) {
                    restartGame()
                },
                secondaryButton: .cancel(Text("Main Menu")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                showAlert = true
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func generateQuestion() {
        // Collect enabled operations
        var availableOperations: [(String, (Int, Int) -> Int, Int, Int)] = []
        
        if isAdditionOn {
            availableOperations.append(("+", { $0 + $1 }, additionLowerBound, additionUpperBound))
        }
        if isSubtractionOn {
            availableOperations.append(("-", { $0 - $1 }, subtractionLowerBound, subtractionUpperBound))
        }
        if isMultiplicationOn {
            availableOperations.append(("*", { $0 * $1 }, multiplicationLowerBound, multiplicationUpperBound))
        }
        if isDivisionOn {
            availableOperations.append(("/", { $0 / ($1 == 0 ? 1 : $1) }, divisionLowerBound, divisionUpperBound))
        }
        
        // Randomly select an operation
        if let (symbol, operation, lowerBound, upperBound) = availableOperations.randomElement() {
            var num1 = Int.random(in: lowerBound...upperBound)
            var num2 = Int.random(in: lowerBound...upperBound)
            
            // Ensure num2 is not zero for division
            if symbol == "/" && (num2 % num1) != 0 {
                return generateQuestion()
            }
            
            if symbol == "-" && (num1 - num2) < 0{
                var x = num2
                num2 = num1
                num1 = x
            }
            
            // Generate the question and compute the correct answer
            currentQuestion = "\(num1) \(symbol) \(num2)"
            correctAnswer = operation(num1, num2)
        }
        userAnswer=""
    }
    
    func checkAnswer() {
        // Convert correct answer to a string for comparison
        let correctAnswerString = String(correctAnswer)
        
        // If user answer matches the correct answer, generate the next question
        if userAnswer == correctAnswerString {
            currentScore += 1
            print("Correct!")
            generateQuestion()
        }
    }
    
    func restartGame() {
        // Reset the timer, score, and start a new game
        timeRemaining = initialTime
        currentScore = 0
        userAnswer = ""
        generateQuestion()
        startTimer()
    }
}

#Preview {
    GameView(initialTime: 1, isAdditionOn: true, additionLowerBound: 2, additionUpperBound: 100, isSubtractionOn: false, subtractionLowerBound: 2, subtractionUpperBound: 100, isMultiplicationOn: false,
             multiplicationLowerBound: 2, multiplicationUpperBound: 100, isDivisionOn: false, divisionLowerBound: 2, divisionUpperBound: 100)
}
