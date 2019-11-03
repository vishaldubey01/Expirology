//
//  SearchBarView.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var completion: (() -> ())?
    
    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
        var completion: (() -> ())?

        init(text: Binding<String>, completion: (() -> ())?) {
            _text = text
            self.completion = completion
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            completion?()
        }
    }
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text, completion: completion)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search"
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
