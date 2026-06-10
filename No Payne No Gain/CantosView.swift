import SwiftUI

private let fanChants: [String] = [
    "Amándote desde el día que te vi (hoy) 🔥",
    "Mi madre me dio la vida, y Tim Payne me dio las ganas de vivirla.",
    "No Payne, No Gain. Eso es ley.",
    "No sé qué es Wellington Phoenix pero daría la vida por él.",
    "Tim Payne es el World Cup del pueblo.",
    "Tenía 4.700 seguidores. Ahora tiene un ejército.",
    "El Scarso lo encontró. El mundo lo quedó.",
    "El Grupo G es el grupo de Tim ahora. Los demás están de visita.",
    "Este hombre entrenó toda su vida para este momento. Nosotros somos el momento.",
    "Busqué en todos los planteles. Tim me estaba esperando.",
    "No es solo un defensor. Defiende nuestros corazones.",
    "De 4.700 a 2,5 millones. Eso no son seguidores, eso es un movimiento.",
    "Ya es el jugador del torneo.",
    "Un influencer. Un defensor. Siete mil millones de fans potenciales.",
]

private let chantTemplates: [String] = [
    "¡No Payne, no gain, ese es el grito!\n{name} lo sabe y lo va a cantar\nDe {country} al mundo, pequeñito\n¡Tim Payne nos vino a emocionar! 🇳🇿⚽",
    "¡Ohh Tim Payne, cuánta emoción!\n{name} te manda su corazón\nDe 4.700 a toda una nación\n¡El pueblo eligió, es una misión! 🔥",
    "¡Dale Tim, dale campeón!\n{name} de {country} con todo el fervor\nWellington grita con emoción\n¡Tim Payne, el jugador de honor! 🌍⚽",
    "🎵 Llegó desde Nueva Zelanda\ncon solo cuatro mil fans\nhoy {name} de {country} le manda\namor que nunca se irá jamás 🇳🇿",
]

struct CantosView: View {
    @State private var userName: String = ""
    @State private var userCountry: String = ""
    @State private var generatedChant: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#070A0D").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        GeneratorCard(
                            userName: $userName,
                            userCountry: $userCountry,
                            generatedChant: $generatedChant
                        )
                        FanChantsSection()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle("Cantos 🎵")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Generator Card

private struct GeneratorCard: View {
    @Binding var userName: String
    @Binding var userCountry: String
    @Binding var generatedChant: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("🎵 Creá tu Canto")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)

            TextField("Tu nombre", text: $userName)
                .padding(12)
                .background(Color.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
                .tint(Color(hex: "#F0C130"))

            TextField("Tu país (opcional)", text: $userCountry)
                .padding(12)
                .background(Color.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
                .tint(Color(hex: "#F0C130"))

            Button {
                generate()
            } label: {
                HStack {
                    Spacer()
                    Text("Generar Canto 🎶")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color(hex: "#070A0D"))
                    Spacer()
                }
                .padding(.vertical, 14)
                .background(
                    userName.trimmingCharacters(in: .whitespaces).isEmpty
                        ? Color.white.opacity(0.2)
                        : Color(hex: "#F0C130")
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(userName.trimmingCharacters(in: .whitespaces).isEmpty)

            if !generatedChant.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text(generatedChant)
                        .font(.system(size: 16))
                        .italic()
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(3)

                    ShareLink(item: generatedChant + "\n\n🇳🇿 No Payne, No Gain\ntimpaynefans.com") {
                        HStack {
                            Spacer()
                            Label("Compartir", systemImage: "square.and.arrow.up")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color(hex: "#F0C130"))
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .background(Color(hex: "#F0C130").opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(14)
                .background(Color(hex: "#F0C130").opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#F0C130").opacity(0.25), lineWidth: 1)
                )
            }
        }
        .padding(18)
        .background(Color(hex: "#1A1A2E"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func generate() {
        let name    = userName.trimmingCharacters(in: .whitespaces)
        let country = userCountry.trimmingCharacters(in: .whitespaces).isEmpty
                      ? "Planet Earth"
                      : userCountry.trimmingCharacters(in: .whitespaces)
        let template = chantTemplates.randomElement()!
        generatedChant = template
            .replacingOccurrences(of: "{name}",    with: name)
            .replacingOccurrences(of: "{country}", with: country)
    }
}

// MARK: - Fan Chants Section

private struct FanChantsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cantos de Fans")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 2)

            ForEach(fanChants, id: \.self) { chant in
                ChantCard(chant: chant)
            }
        }
    }
}

private struct ChantCard: View {
    let chant: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\u{201C}")
                .font(.system(size: 32, weight: .black))
                .foregroundStyle(Color(hex: "#F0C130").opacity(0.3))
                .offset(x: -4, y: 4)

            Text(chant)
                .font(.system(size: 15))
                .italic()
                .foregroundStyle(Color.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(2)
                .padding(.top, -8)

            HStack {
                Text("— Internet, 2026")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.white.opacity(0.35))
                Spacer()
                ShareLink(item: chant + "\n\n🇳🇿 No Payne, No Gain\ntimpaynefans.com") {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color(hex: "#F0C130"))
                }
            }
        }
        .padding(16)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    CantosView()
}
