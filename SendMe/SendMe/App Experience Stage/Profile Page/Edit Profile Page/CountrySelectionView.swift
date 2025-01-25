import SwiftUI

struct CountrySelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCountry: String
    
    private let countries: [(flag: String, name: String)] = [
        ("🇺🇸", "United States"),
        ("🇬🇧", "United Kingdom"),
        ("🇨🇦", "Canada"),
        ("🇦🇺", "Australia"),
        ("🇩🇪", "Germany"),
        ("🇫🇷", "France"),
        ("🇪🇸", "Spain"),
        ("🇮🇹", "Italy"),
        ("🇯🇵", "Japan"),
        ("🇨🇳", "China"),
        ("🇮🇳", "India"),
        ("🇧🇷", "Brazil"),
        ("🇲🇽", "Mexico"),
        ("🇵🇱", "Poland"),
        ("🇳🇱", "Netherlands"),
        ("🇬🇪", "Georgia")
    ].sorted(by: { $0.name < $1.name })
    
    var body: some View {
        List {
            ForEach(countries, id: \.name) { country in
                Button(action: {
                    selectedCountry = country.name
                    dismiss()
                }) {
                    HStack {
                        Text(country.flag)
                            .font(.title2)
                        Text(country.name)
                            .padding(.leading, 8)
                        Spacer()
                        if country.name == selectedCountry {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle("Select Country")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        CountrySelectionView(selectedCountry: .constant("United States"))
    }
}
