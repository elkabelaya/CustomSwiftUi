//
//  SwiftUIView.swift
//  
//
//  Created by Elka Belaya on 15.03.2021.
//

import SwiftUI

public struct CustomButton<Content>: View where Content: View {
    private let action: () -> Void
    private let content:() -> Content
    
    @State private var tapped:Bool = false
    
    public init(action:@escaping () -> Void, @ViewBuilder content: @escaping () -> Content){
        self.action = action
        self.content = content
    }
    public var body: some View {
        content()
            .font(.title)
            .padding()
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(6)
            
            .onTapGesture {
                action()
            }
            .onLongPressGesture(minimumDuration: 100, pressing: { isPressing in
                tapped = isPressing
            }, perform: {})
            .opacity(tapped ? 0.4 : 1)
                
            
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton( action: {}){
            Text("CustomButton")
        }
    }
}
