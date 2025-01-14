import SwiftUI

struct PaymentMethodsView: View {
    @StateObject private var viewModel = PaymentMethodsViewModel()
    
    var body: some View {
        List {
            Button(action: {
            }) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .shadow(color: Color.gray.opacity(0.6), radius: 1)
                        
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                    }
                    
                    Text("Add a payment method")
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray.opacity(0.5))
                        .font(.system(size: 14))
                }
                .padding(.vertical, 8)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
        .background(Color.white)
        .navigationTitle("Payment methods")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        PaymentMethodsView()
    }
} 
