import SwiftUI

struct InviteFriendsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                
                Spacer()

            }
            .padding(.horizontal)
            
            VStack(spacing: 16) {
                Text("Invite friends and\nget $25")
                    .font(.system(size: 40, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("You can add another account later on, too.")
                    .foregroundColor(.gray)
                    .font(.system(size: 17))
            }
            .padding(.top, 40)
            
            VStack(spacing: 12) {
                Text("1 out of 3")
                    .font(.system(size: 17, weight: .semibold))
                
                Text("Invite friends and earn reward when 3\nfriends send over $100 in one go.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(width: 100, height: 4)
                    
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 200, height: 4)
                }
                .frame(width: 300, height: 4)
            }
            .padding(24)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: {}) {
                    Text("Share your link")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                
                Button(action: {}) {
                    Text("Copy link")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal)
            
            Text("By sharing referral links, you accept our\nTerms of Use and Privacy Policy.")
                .font(.system(size: 13))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    InviteFriendsView()
} 
