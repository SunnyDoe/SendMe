import SwiftUI

struct RatingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRating: Int = 0
    @State private var submissionMessage: String?
    @State private var isSubmitting: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Rate Us")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 24)
            
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= selectedRating ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(index <= selectedRating ? .yellow : .gray)
                        .onTapGesture {
                            selectedRating = index
                        }
                }
            }
            .padding(.top, 32)
            
            Spacer()
            
            if let message = submissionMessage {
                Text(message)
                    .foregroundColor(.green)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
            }
            
            Button(action: submitRating) {
                HStack {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 8)
                    }
                    
                    Text(isSubmitting ? "Submitting..." : "Submit Rating")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(25)
            }
            .disabled(selectedRating == 0 || isSubmitting)
            .padding(.horizontal, 24)
        }
        .padding()
    }
    
    private func submitRating() {
        isSubmitting = true
        submissionMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSubmitting = false
            submissionMessage = "Thank you for your rating!"
        }
    }
}

