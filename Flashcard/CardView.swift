//
//  CardView.swift
//  Flashcard
//
//  Created by Elias Woldie on 3/16/24.
//

import SwiftUI

// Card data model
struct Card: Equatable {
    let question: String
    let answer: String
    static let mockedCards = [
        Card(question: "What is the capital of Washington?", answer: "Olympia"),
        Card(question: "Which city serves as the capital of Texas?", answer: "Austin"),
        Card(question: "What is the capital of New York?", answer: "Albany"),
        Card(question: "Which city is the capital of Florida?", answer: "Tallahassee"),
        Card(question: "What is the capital of Colorado?", answer: "Denver")
    ]
}

struct CardView: View {
    let card: Card
    @State private var isShowingQuestion = true
    @State private var offset: CGSize = .zero
    @State private var isRemoved = false
    var onSwipedLeft: (() -> Void)?
    var onSwipedRight: (() -> Void)?

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 25.0)
                .fill(offset.width < 0 ? .red : .green)
                .opacity(1 - abs(offset.width) / 200.0)

            RoundedRectangle(cornerRadius: 25.0)
                .fill(isShowingQuestion ? Color.blue.gradient : Color.indigo.gradient)
                .opacity(1 - abs(offset.width) / 200.0)
                .shadow(color: .black, radius: 4, x: -2, y: 2)

            VStack(spacing: 20) {

                // Card type (question vs answer)
                Text(isShowingQuestion ? "Question" : "Answer")
                    .bold()

                // Separator
                Rectangle()
                    .frame(height: 1)

                // Card text
                Text(isShowingQuestion ? card.question : card.answer)
            }
            .font(.title)
            .foregroundColor(.white)
            .padding()
            .rotationEffect(.degrees(offset.width / 20.0))
        }
        .frame(width: 300, height: 500)
        .offset(CGSize(width: offset.width, height: 0))
        .gesture(DragGesture()
            .onChanged { gesture in
                let translation = gesture.translation
                offset = translation
            }
            .onEnded { gesture in
                if gesture.translation.width > 200 { // Swipe right threshold
                    onSwipedRight?()
                } else if gesture.translation.width < -200 { // Swipe left threshold
                    onSwipedLeft?()
                } else {
                    withAnimation {
                        offset = .zero
                    }
                }
            }
        )
        .opacity(isRemoved ? 0 : 1)
        .animation(.default, value: offset)
    }

#if DEBUG
    struct CardView_Previews: PreviewProvider {
        static var previews: some View {
            CardView(card: Card(question: "Located at the southern end of Puget Sound, what is the capitol of Washington?", answer: "Olympia"))
        }
    }
#endif
}
