//
//  ContentView.swift
//  edutainment
//
//  Created by Muhammad Fahmi on 06/09/23.
//

import SwiftUI

struct ContentView: View {
    @State private var multiTable = 2
    @State private var questionDefaultAmount = 15
    var questionAmount = [5, 10, 15]
    @State private var answer = [String](repeating: "", count: 15)
    @State private var randomNumber = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].shuffled()
    @FocusState private var inputIsFocus: Bool
    @State private var isShowSetting = true
    @State private var isStart = false
    @State private var isCorrect = false
    @State private var correctAnswer = 0
    @State private var inCorrectAnswer = 0
    @State private var isShowResult = false
    
    var body: some View {
        NavigationView{
            Form{
                if isShowSetting{
                    Section{
                        Stepper("Multiplication table: \(multiTable)", value: $multiTable, in: 2...12)
                    } header: {
                        Text("Select multiplication table").bold()
                    }
                    Section{
                        Picker("", selection: $questionDefaultAmount){
                            ForEach(questionAmount, id: \.self){
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text("How many question").bold()
                    }
                }
                Button(isShowSetting ? "Start" : "Answer \(questionDefaultAmount) question below"){
                    withAnimation(.default){
                        isShowSetting = false
                        isStart = true
                    }
                }
                if isStart{
                    Section{
                        VStack(){
                            ForEach(0..<questionDefaultAmount, id: \.self){ num in
                                HStack(){
                                    Text("\(multiTable) x \(num>10 ? randomNumber[num-5] : randomNumber[num]) = ")
                                        .frame(width: 70, alignment: .center)
                                    TextField("Answer here", text: $answer[num])
                                        .foregroundStyle(
                                            (Int(answer[num]) ?? 0) == (multiTable * (num > 10 ? randomNumber[num - 5] : randomNumber[num])) ? .green : .red)
                                        .frame(width: 200, alignment: .center)
                                        .keyboardType(.numberPad)
                                        .focused($inputIsFocus)
                                }
                            }
                        }
                    } header: {
                        Text("Question").bold()
                    }
                    Button("Check answer") {
                        checkAnswer()
                        isShowResult = true
                    }
                    if isShowResult {
                        if isCorrect {
                            Text("All correct!")
                                .foregroundColor(.green)
                        } else {
                            Text("\(correctAnswer) correct & \(inCorrectAnswer) incorrect answers. Try again.")
                                .foregroundColor(.red)
                        }
                    }
                }
                //                Button("Debug"){
                //                    print("questionAmount: \(questionAmount)")
                //                    print("questionDefaultAmount: \(questionDefaultAmount)")
                //                }
            }
            .navigationTitle("Edutainment")
            .toolbar(){
                ToolbarItem(placement: .keyboard){
                    Button("Done"){
                        inputIsFocus = false
                    }
                }
            }
            .toolbar{
                Button("Reset", action: reset)
            }
        }
    }
    func reset() {
        withAnimation(.default){
            randomNumber.shuffle()
            isShowSetting = true
            isStart = false
            isShowResult = false
            multiTable = 2
            questionDefaultAmount = 15
            answer = [String](repeating: "", count: questionDefaultAmount) // Clear all text entries
        }
    }
    func checkAnswer() {
        withAnimation(.default){
            var correctCount = 0
            var inCorrectCount = 0
            
            for num in 0..<questionDefaultAmount {
                let userAnswer = Int(answer[num]) ?? 0
                let trueAnswer = multiTable * (num > 10 ? randomNumber[num - 5] : randomNumber[num])
                
                if userAnswer == trueAnswer {
                    correctCount += 1
                } else {
                    inCorrectCount += 1
                }
            }
            correctAnswer = correctCount
            inCorrectAnswer = inCorrectCount
            isCorrect = correctCount == questionDefaultAmount
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
