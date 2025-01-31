//
//  Untitled.swift
//  SendMe
//
//  Created by Sandro Tsitskishvili on 24.01.25.
//
import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 56)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .font(.system(size: 17))
    }
}
