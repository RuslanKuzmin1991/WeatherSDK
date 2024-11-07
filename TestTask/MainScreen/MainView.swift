//
//  MainView.swift
//  TestTask
//
//  Created by Ruslan Kuzmin on 17.10.24.
//

import SwiftUI

struct NavigationControllerKey: EnvironmentKey {
    static let defaultValue: RouterApp? = nil
}

extension EnvironmentValues {
    var router: RouterApp? {
        get {
            return self[NavigationControllerKey.self]
        }
        set {
            self[NavigationControllerKey.self] = newValue
        }
    }
}

struct MainView: View {
    @State var state: any MainState
    //Router in view is used for SwiftUI navigation
    @State var weatherViewIsOn: Bool = false
    @Environment(\.router) var router
    
    init(state: any MainState) {
        self.state = state
    }
    
    var body: some View {
            NavigationStack {
                if !state.isEmbedded {
                    Text("main_screen_title".localized)
                        .font(.title)
                        .navigationBarTitleDisplayMode(.inline)
                    Divider()
                        .background(.textSecondary)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    Text("main_screen_header".localized)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2, reservesSpace: true)
                        .font(.h2)
                    TextField("main_screen_edittext_placeholder".localized, text: $state.cityName)
                        .padding(.vertical, 18)
                        .padding(.leading, 18)
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.control, lineWidth: 1)
                        )
                        .font(.textRegular)
                    Button {
                        //TODO: SwiftUI Navigation. Need to be uncommented for usage
//                        weatherViewIsOn.toggle()
                        state.onWeatherTap()
                    } label: {
                        HStack {
                            Text("main_screen_button_title".localized)
                                .padding(.vertical, 18)
                                .padding(.horizontal, 0)
                                .foregroundStyle(.titleButton)
                                .font(.title)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.control)
                    .cornerRadius(100)
                    .navigationDestination(isPresented: $weatherViewIsOn) {
                        if weatherViewIsOn {
                            router?.navigateToWeatherView(forCity: state.cityName)
                        }
                    }
                    Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            }.padding(.all, 0)
            .ignoresSafeArea()
    }
}

#Preview {
    MainView(state: MainStateImpl(router: nil,
                                  cityName: "Munich"))
}


