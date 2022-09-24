//
//  AppTextField.swift
//  SysVPN (iOS)
//
//  Created by Nguyễn Đình Thạch on 16/12/2021.
//

import Foundation
import SwiftUI

struct AppTextField: UIViewRepresentable {

    // 1
    @Binding var text: String
    @Binding var isRevealed: Bool
    @Binding var isFocused: Bool
    var placeholder: String = ""
     // 2
    func makeUIView(context: UIViewRepresentableContext<AppTextField>) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(Color.white.opacity(0.3)),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
            ]
        )
        tf.isUserInteractionEnabled = true
        tf.delegate = context.coordinator
        tf.textColor = UIColor.white
        tf.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return tf
    }

    func makeCoordinator() -> AppTextField.Coordinator {
        return Coordinator(text: $text, isFocused: $isFocused)
    }

    // 3
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.isSecureTextEntry = !isRevealed
    }

    // 4
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var isFocused: Bool

        init(text: Binding<String>, isFocused: Binding<Bool>) {
            _text = text
            _isFocused = isFocused
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
               self.isFocused = true
            }
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isFocused = false
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return false
        }
    }
}

struct PasswordField: View {
    @Binding var text: String
    @Binding var isRevealed: Bool
    @Binding var isFocused: Bool
    var placeholder: String = ""

    var body: some View {
        HStack {
            AppTextField(text: $text,
                        isRevealed: $isRevealed,
                         isFocused: $isFocused, placeholder: placeholder)
            Spacer().frame(width: 10)
            Button(action: {
                self.isRevealed.toggle()
            }) {
                Image(systemName: self.isRevealed ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(AppColor.themeColor)
            }
        }
    }
}
