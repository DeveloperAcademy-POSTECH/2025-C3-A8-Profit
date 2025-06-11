//
//  KeyboardObserver.swift
//  Soonsu
//
//  Created by coulson on 6/11/25.
//

import SwiftUI
import Combine

final class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible = false

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .merge(with:
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false }
            )
            .receive(on: RunLoop.main)
            .assign(to: &$isKeyboardVisible)
    }
}
