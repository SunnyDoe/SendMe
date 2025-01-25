import SwiftUI

struct PaymentMethodsView: View {
    @StateObject var viewModel: PaymentMethodsViewModel
    @State private var showSuccessToast = false
    @State private var showingAddCard = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.savedCards) { card in
                        CardView(card: card)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        viewModel.removeCard(card)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    
                    Button(action: { showingAddCard = true }) {
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
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .navigationTitle("Payment methods")
                .navigationBarTitleDisplayMode(.inline)
                
                if showSuccessToast {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Card added successfully")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(25)
                        .padding(.bottom, 32)
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .cardAdded)) { _ in
                withAnimation {
                    showSuccessToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSuccessToast = false
                        }
                    }
                }
            }
            .onAppear {
                viewModel.loadSavedCards()
            }
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showingAddCard) {
            NavigationView {
                AddCardView()
            }
        }
    }
}

extension Notification.Name {
    static let cardAdded = Notification.Name("cardAdded")
}

#Preview {
    PaymentMethodsView(viewModel: PaymentMethodsViewModel())
} 
