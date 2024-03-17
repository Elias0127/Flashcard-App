//
//  CreateFlashcardView.swift
//  Flashcard
//
//  Created by Elias Woldie on 3/16/24.
//

import SwiftUI

struct CreateFlashcardView: View {

    var onCreate: (Card) -> Void // <--  Closure to pass back the created flashcard

    @Environment(\.dismiss) private var dismiss // <-- The dismiss value from the environment. Allows for programmatic dismissal.

    @State private var questionText = "" // <-- Text property for the question text field
    @State private var answerText = "" // <-- Text property for the answer text field

    var body: some View {
        VStack(spacing: 60) { // <-- Top level VStack, separates the button from the text fields
            HStack { // <-- HStack for the button section
                Spacer() // <-- Spacer on left side of HStack expands to position button furthest right

                // Save button
                Button("Save") {
                    onCreate(Card(question: questionText, answer: answerText)) // <-- Call onCreate closure passing in a created card
                    dismiss() // <-- Dismiss the view
                }
                .disabled(questionText.isEmpty || answerText.isEmpty) // <-- Disable the button if either text field is empty
            }
            VStack { // <-- VStack for the text fields
                // Question text field
                TextField("Add a question...", text: $questionText, axis: .vertical) // <-- Pass in $questionText as binding using `$`

                // Answer text field
                TextField("Add an answer...", text: $answerText, axis: .vertical) // <-- Vertical axis allows text to wrap and expand vertically
            }
            .textFieldStyle(.roundedBorder) // <-- Apply a textfield style with rounded border to both text fields
            .font(.title) // <-- Apply title font to both text fields

            Spacer() //<-- Spacer expands to fill empty space below text fields and button, positioning them at the top
        }
        .padding()
    }
}

#Preview {
    CreateFlashcardView { card in
        print("New card created: \(card)") // <-- prints added card to the console on save button tap
    }
}
