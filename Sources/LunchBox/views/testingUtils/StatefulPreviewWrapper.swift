//
//  StatefulPreviewWrapper.swift
//  
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(wrappedValue: value)
        self.content = content
    }
}


//@available(iOS 16.0, *)
//struct StatefulPreviewWrapper_PreviewProvider : PreviewProvider {
//    static var previews: some View {
//        StatefulPreviewWrapper(1, content: { item in
//            Text("This is \(item)")
//        })
//    }
//}
