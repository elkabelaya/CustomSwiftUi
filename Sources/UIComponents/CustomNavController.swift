//
//  CustomNavController.swift
//  
//
//  Created by Elka Belaya on 16.03.2021.
//

import SwiftUI

//Mark: - Model
private struct Screen:Identifiable, Equatable {
    let id:String
    let nextString:AnyView
    
    static func == (lhs:Screen, rhs:Screen) -> Bool{
        lhs == rhs
    }
}

private struct ScreenStack {
    private var screens: [Screen] = .init()
    mutating func push(_ s: Screen){
        screens.append(s)
    }
    
    func top() -> Screen? {
        screens.last
    }
    mutating func popToPrevious() {
        _ = screens.popLast()
    }
    
    mutating func popToRoot() {
        screens.removeAll()
    }
}

//Mark: - ViewModel
public final class NavControllerViewModel: ObservableObject {
    @Published fileprivate var currentScreen: Screen?
    private var screenStack: ScreenStack = .init(){
        didSet {
            currentScreen = screenStack.top()
        }
    }
    
    func push<S : View>(_ screenView: S){
        let screen: Screen = .init(id: UUID().uuidString, nextString: AnyView(screenView))
        screenStack.push(screen)
    }
    
    func pop() {
        screenStack.popToPrevious()
    }
}

//Mark: - UI

public struct NavControllerView<Content>: View where Content: View {
    @ObservedObject var viewModel: NavControllerViewModel
    
    private let content:Content
    
    public init(@ViewBuilder content: @escaping () -> Content){
        viewModel = NavControllerViewModel()
        self.content = content()
    }
    public var body: some View {
        let isRoot = viewModel.currentScreen == nil
        return ZStack{
            if isRoot{
                content
                    .environmentObject(viewModel)
            } else {
                viewModel.currentScreen!.nextString
            }
        }
    }
}
    
