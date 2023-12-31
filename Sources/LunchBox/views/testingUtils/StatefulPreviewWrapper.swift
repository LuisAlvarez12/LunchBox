//
//  StatefulPreviewWrapper.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    public var body: some View {
        content($value)
    }

    public init(value: Value, _ content: @escaping (Binding<Value>) -> Content) {
        _value = State(wrappedValue: value)
        self.content = content
    }
}

@available(iOS 16.0, *)
struct StatefulPreviewWrapper_PreviewProvider: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(value: 123) { val in
            Text("Value is \(val.wrappedValue)")
        }
    }
}
