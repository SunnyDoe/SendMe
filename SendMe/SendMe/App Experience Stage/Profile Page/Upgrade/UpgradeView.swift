import SwiftUI

struct UpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingPlanSelection = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                .accessibilityLabel("Go back")
                
                Spacer()
                
                Text("Upgrade to Pro")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(width: 60)
            }
            .padding()
            
            VStack(spacing: 24) {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.yellow)
                    .padding(.top, 32)
                
                Text("Unlock Premium Features")
                    .font(.system(size: 24, weight: .bold))
                
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "bolt.fill", text: "Faster transfers")
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Higher transfer limits")
                    FeatureRow(icon: "person.2.fill", text: "Priority support")
                    FeatureRow(icon: "percent", text: "Lower fees")
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("Starting at $2.99/week")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                Button(action: {
                    showingPlanSelection = true
                }) {
                    Text("Choose your plan")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingPlanSelection) {
            NavigationView {
                PlanSelectionView()
                    .presentationDetents([.height(520)])
            }
        }
    }
}

