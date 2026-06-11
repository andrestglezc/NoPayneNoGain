//
//  ContentView.swift
//  No Payne No Gain
//
//  Created by Andres.T Glez on 08-06-26.
//

import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()

    var body: some View {
        TabView {
            Tab("Hype", systemImage: "flame.fill") {
                HypeView()
            }
            Tab("Quiz", systemImage: "trophy.fill") {
                QuizView()
            }
            Tab("Misiones", systemImage: "target") {
                MisionesView()
            }
            Tab("Cantos", systemImage: "music.note") {
                CantosView()
            }
            Tab("Perfil", systemImage: "person.fill") {
                PerfilView()
            }
        }
        .environment(appState)
        .onAppear { appState.checkAndUpdateStreak() }
    }
}

#Preview {
    ContentView()
}
