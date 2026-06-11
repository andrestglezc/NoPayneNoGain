import SwiftUI

// MARK: - Data models

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctIndex: Int
}

struct QuizCategory: Identifiable, Hashable {
    let id: String
    let emoji: String
    let label: String
    let subtitle: String
    let questions: [QuizQuestion]
    var isFeatured: Bool = false
    var gradientStart: Color = Color(hex: "#1A1A2E")
    var gradientEnd: Color   = Color(hex: "#0D0D1A")

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: QuizCategory, rhs: QuizCategory) -> Bool { lhs.id == rhs.id }
}

// MARK: - Question banks

private let timPayneQuestions: [QuizQuestion] = [
    QuizQuestion(question: "¿En qué posición juega Tim Payne?",
                 options: ["Arquero", "Lateral derecho", "Delantero centro", "Mediocampista defensivo"], correctIndex: 1),
    QuizQuestion(question: "¿En qué club juega Tim Payne?",
                 options: ["Auckland City", "All Whites FC", "Wellington Phoenix", "Waitakere United"], correctIndex: 2),
    QuizQuestion(question: "¿Cuántos seguidores tenía Tim antes de que El Scarso publicara sobre él?",
                 options: ["4.715", "47.150", "471", "147.000"], correctIndex: 0),
    QuizQuestion(question: "¿Cuál es el nombre real de El Scarso?",
                 options: ["Carlos Mendez", "Valen Scarsini", "Diego Scarso", "Juan El Scarso"], correctIndex: 1),
    QuizQuestion(question: "¿De qué nacionalidad es El Scarso?",
                 options: ["Chileno", "Uruguayo", "Brasileño", "Argentino"], correctIndex: 3),
    QuizQuestion(question: "¿En cuántos mundiales ha participado New Zealand históricamente?",
                 options: ["Es su primera vez", "2 torneos", "5 torneos", "10 torneos"], correctIndex: 1),
    QuizQuestion(question: "¿Cuál es el número de Tim Payne en Wellington Phoenix?",
                 options: ["4", "7", "6", "11"], correctIndex: 2),
    QuizQuestion(question: "¿En qué grupo está New Zealand en el World Cup 2026?",
                 options: ["Grupo A", "Grupo G", "Grupo D", "Grupo F"], correctIndex: 1),
    QuizQuestion(question: "¿Con qué rapidez consiguió Tim su primer millón de seguidores?",
                 options: ["1 mes", "1 semana", "En menos de 48 horas", "10 días"], correctIndex: 2),
    QuizQuestion(question: "¿A qué hace referencia 'No Payne No Gain'?",
                 options: ["Una frase original de Tim", "La clásica frase 'no pain no gain'", "Un canto de Wellington", "Un video de El Scarso"], correctIndex: 1),
    QuizQuestion(question: "El arma más peligrosa de Tim Payne en el campo es:",
                 options: ["Su pie izquierdo", "Su pelo", "Presentarse", "Su presencia en Instagram"], correctIndex: 2),
    QuizQuestion(question: "Si Tim tuviera un rating FIFA antes del World Cup, sería:",
                 options: ["99 en general", "55 en general", "75 en general", "88 en general"], correctIndex: 1),
    QuizQuestion(question: "El Scarso eligió a Tim porque era:",
                 options: ["El mejor jugador del torneo", "El más seguido", "El jugador menos conocido que pudo encontrar", "El ídolo de su infancia"], correctIndex: 2),
    QuizQuestion(question: "El stat VIR (Viralidad) de Tim Payne es:",
                 options: ["55", "72", "88", "99"], correctIndex: 3),
    QuizQuestion(question: "¿Cuál sería el titular de LinkedIn de Tim?",
                 options: ["'Futbolista del World Cup e influencer'", "'Lateral derecho. Wellington. Ocasionalmente viral.'", "'CEO del fútbol de NZ'", "'Socio de El Scarso'"], correctIndex: 1),
    QuizQuestion(question: "El marcador de goles de Tim en el World Cup es:",
                 options: ["5", "1", "3", "0"], correctIndex: 3),
    QuizQuestion(question: "La descripción más precisa de Tim Payne es:",
                 options: ["El Messi del Hemisferio Sur", "Un tipo que fue a trabajar y se hizo famoso sin querer", "El goleador más prolífico de NZ", "El verdadero El Scarso"], correctIndex: 1),
    QuizQuestion(question: "La reacción de Tim ante 2,9M de seguidores fue:",
                 options: ["Contrató relaciones públicas", "Publicó 47 veces por día", "Siguió entrenando tranquilo", "Le mandó un desafío a Messi"], correctIndex: 2),
    QuizQuestion(question: "Si Tim fuera un cromo de Panini, sería:",
                 options: ["El más intercambiado", "El que nadie conocía hasta ahora", "El que ya tiene todo el mundo repetido", "Imposible de conseguir"], correctIndex: 1),
    QuizQuestion(question: "El stat de calidad de pelo de Tim Payne sería:",
                 options: ["45 — necesita trabajo", "67 — decente", "99 — élite", "12 — trágico"], correctIndex: 2),
    QuizQuestion(question: "¿Cuántas vistas tuvo el video de El Scarso sobre Tim?",
                 options: ["600.000", "6 millones", "60.000", "60 millones"], correctIndex: 1),
    QuizQuestion(question: "¿Qué le diría Tim a El Scarso si se encontraran?",
                 options: ["'Por favor, pará'", "'Hagamos un negocio'", "'Gracias, creo'", "'¿Quién sos?'"], correctIndex: 2),
    QuizQuestion(question: "Tim Payne le sacó seguidores a qué famosa cuenta de NZ:",
                 options: ["The All Blacks", "Air New Zealand", "El Primer Ministro", "Wellington Phoenix oficial"], correctIndex: 0),
    QuizQuestion(question: "La verdadera razón por la que Tim es famoso:",
                 options: ["Hizo un hat-trick", "Atajó un penal", "Un argentino en internet lo decidió", "Fue a un programa de TV"], correctIndex: 2),
    QuizQuestion(question: "El índice de aprobación de El Scarso sobre Tim es:",
                 options: ["67%", "78%", "91%", "99%"], correctIndex: 3),
    QuizQuestion(question: "¿Cómo describiría Tim las últimas semanas?",
                 options: ["'Lo esperaba'", "'48 horas bastante locas, todavía practicando el español'", "'Finalmente el mundo ve mi genialidad'", "'La culpa es de El Scarso'"], correctIndex: 1),
    QuizQuestion(question: "¿Qué idioma está practicando Tim según los rumores?",
                 options: ["Māori", "Portugués", "Español", "Francés"], correctIndex: 2),
    QuizQuestion(question: "Tim vs Cristiano Ronaldo: ¿quién tiene más seguidores en Instagram?",
                 options: ["Tim, obvio", "Ronaldo por poco", "Ronaldo por varios cientos de millones", "Están igual"], correctIndex: 2),
    QuizQuestion(question: "La historia de Tim Payne es esencialmente:",
                 options: ["Un futbolista comprando seguidores", "Internet eligiendo a alguien al azar para amar", "Un escándalo de la FIFA", "Una campaña de Wellington Phoenix"], correctIndex: 1),
    QuizQuestion(question: "La canción de entrada al campo de Tim sería:",
                 options: ["'Eye of the Tiger'", "'Muchachos'", "'No Payne No Gain' (el canto)", "Algo de Coldplay, bajito"], correctIndex: 2),
    QuizQuestion(question: "El estilo defensivo de Tim se describe mejor como:",
                 options: ["Impulsivo y caótico", "Confiable, sólido, sin glamour", "De clase mundial, al estilo Cafu", "Puro vibe"], correctIndex: 1),
    QuizQuestion(question: "¿Cómo se llamaría la autobiografía de Tim?",
                 options: ["'En el lugar correcto, de lateral'", "'Solo estaba haciendo mi trabajo'", "'El efecto El Scarso'", "Todas las anteriores"], correctIndex: 3),
    QuizQuestion(question: "El stat más viral de Tim antes del World Cup era:",
                 options: ["Goles por partido", "Recuperaciones por 90", "Cantidad de seguidores", "No tenía stats virales. Ese era el punto."], correctIndex: 3),
    QuizQuestion(question: "Si Tim gana el World Cup, El Scarso recibe:",
                 options: ["Nada, es solo un fan", "Co-MVP", "Su propio sello en NZ", "La camiseta de Tim, obvio"], correctIndex: 3),
    QuizQuestion(question: "La lección de la historia de Tim Payne es:",
                 options: ["Las redes sociales lo son todo", "Los laterales están subestimados", "A veces internet simplemente te elige", "Siempre jugá para NZ"], correctIndex: 2),
]

private let worldcupQuestions: [QuizQuestion] = [
    QuizQuestion(question: "¿Dónde se juega el FIFA World Cup 2026?",
                 options: ["Solo en USA", "USA, Canadá y México", "Brasil y Argentina", "Europa y USA"], correctIndex: 1),
    QuizQuestion(question: "¿Cuántos equipos participan en el World Cup 2026?",
                 options: ["32", "40", "48", "36"], correctIndex: 2),
    QuizQuestion(question: "¿En qué grupo está New Zealand?",
                 options: ["Grupo A", "Grupo D", "Grupo F", "Grupo G"], correctIndex: 3),
    QuizQuestion(question: "¿Cuál es el primer rival de NZ en el World Cup 2026?",
                 options: ["Egypt", "Belgium", "Iran", "Argentina"], correctIndex: 2),
    QuizQuestion(question: "¿En qué estadio juega NZ su primer partido?",
                 options: ["MetLife Stadium", "SoFi Stadium", "AT&T Stadium", "Levi's Stadium"], correctIndex: 1),
    QuizQuestion(question: "¿Cuántos partidos de World Cup ha ganado NZ en toda su historia?",
                 options: ["0", "1", "3", "5"], correctIndex: 0),
    QuizQuestion(question: "¿En qué World Cup anterior participó Tim Payne?",
                 options: ["2018 Rusia", "2022 Catar", "2014 Brasil", "Nunca había jugado un World Cup antes"], correctIndex: 3),
    QuizQuestion(question: "¿De qué país es El Scarso?",
                 options: ["Chile", "Uruguay", "Argentina", "España"], correctIndex: 2),
    QuizQuestion(question: "El apodo de New Zealand es:",
                 options: ["The Kiwis", "The All Whites", "The Ferns", "The Black Caps"], correctIndex: 1),
    QuizQuestion(question: "¿Cuántos goles marcó NZ en el World Cup 2010?",
                 options: ["0", "2", "3", "5"], correctIndex: 2),
]

private let deepLoreQuestions: [QuizQuestion] = [
    QuizQuestion(question: "¿En qué ciudad nació Tim Payne?",
                 options: ["Wellington", "Christchurch", "Auckland", "Dunedin"], correctIndex: 2),
    QuizQuestion(question: "¿En qué año se unió Tim Payne a Wellington Phoenix?",
                 options: ["2015", "2017", "2019", "2021"], correctIndex: 2),
    QuizQuestion(question: "¿A qué club inglés fichó Tim Payne al inicio de su carrera?",
                 options: ["Everton", "Blackburn Rovers", "Bolton Wanderers", "Leeds United"], correctIndex: 1),
    QuizQuestion(question: "¿Qué le dijo Tim a El Scarso en su DM?",
                 options: ["'Por favor, pará'", "'Me preguntaba por qué mis redes explotaban, gracias hermano'", "'¿Podemos dividir los seguidores?'", "Nunca respondió"], correctIndex: 1),
    QuizQuestion(question: "¿Qué idioma está practicando Tim según los rumores?",
                 options: ["Māori", "Portugués", "Francés", "Español"], correctIndex: 3),
    QuizQuestion(question: "¿Cuántos años tiene Tim Payne?",
                 options: ["28", "30", "32", "35"], correctIndex: 2),
    QuizQuestion(question: "El número de Tim Payne en Wellington Phoenix es:",
                 options: ["4", "6", "9", "11"], correctIndex: 1),
    QuizQuestion(question: "¿En qué club americano jugó Tim Payne?",
                 options: ["LA Galaxy 2", "New York Red Bulls II", "Portland Timbers 2", "Seattle Sounders 2"], correctIndex: 2),
    QuizQuestion(question: "¿Aproximadamente cuántas caps internacionales tiene Tim Payne?",
                 options: ["Menos de 10", "Alrededor de 25", "Más de 50", "Exactamente 100"], correctIndex: 2),
    QuizQuestion(question: "¿Por cuánto tiempo firmó Tim con Wellington Phoenix en 2024?",
                 options: ["1 año", "2 años", "3 años", "5 años"], correctIndex: 2),
]

private let bootsQuestions: [QuizQuestion] = [
    QuizQuestion(question: "Botín legendario usado por Zidane, revolucionó la técnica de disparo:",
                 options: ["Adidas Predator Mania", "Nike Total 90", "Puma King", "Diadora Maracana"], correctIndex: 0),
    QuizQuestion(question: "Ronaldo Nazário lo usó en Francia 98. El botín más liviano de su época:",
                 options: ["Adidas Predator", "Nike Mercurial", "Puma v1.06", "Lotto Zhero"], correctIndex: 1),
    QuizQuestion(question: "Símbolo del fútbol callejero a principios de los 2000:",
                 options: ["Adidas F50", "Nike Shox R4", "Nike Total 90 Laser", "Adidas Predator Pulse"], correctIndex: 2),
    QuizQuestion(question: "¿Qué marca usó Messi durante la mayoría de su carrera en Barcelona?",
                 options: ["Nike", "Puma", "Adidas", "New Balance"], correctIndex: 2),
    QuizQuestion(question: "Pelé los usó durante toda su carrera:",
                 options: ["Adidas Copa Mundial", "Puma King", "Hummel Stadion", "Adidas World Cup"], correctIndex: 1),
    QuizQuestion(question: "Debutó en el World Cup 2010, criticado por su movimiento impredecible:",
                 options: ["Nike Mercurial Vapor", "Adidas Predator X", "Puma PowerCat", "Adidas adiPure"], correctIndex: 1),
    QuizQuestion(question: "La línea de botines de Cristiano Ronaldo se llama:",
                 options: ["Nike Mercurial", "Nike Phantom", "Nike Tiempo", "Nike Hypervenom"], correctIndex: 0),
    QuizQuestion(question: "¿Qué botines usó Thierry Henry en la temporada Invencibles 2003-04?",
                 options: ["Adidas Predator", "Nike Air Zoom Total 90", "Puma v1.06", "Umbro Speciali"], correctIndex: 1),
    QuizQuestion(question: "Las adidas Copa Mundial están en producción desde:",
                 options: ["1968", "1979", "1982", "1990"], correctIndex: 2),
    QuizQuestion(question: "¿Qué botín está asociado al slogan 'El botín más rápido del mundo'?",
                 options: ["Adidas F50 adiZero", "Nike Mercurial Vapor", "Puma evoSpeed", "Under Armour Clutchfit"], correctIndex: 0),
]

private let goatsQuestions: [QuizQuestion] = [
    QuizQuestion(question: "¿Quién ha ganado más Balones de Oro?",
                 options: ["Cristiano Ronaldo", "Lionel Messi", "Ronaldo Nazário", "Zinedine Zidane"], correctIndex: 1),
    QuizQuestion(question: "¿Qué país ha ganado más mundiales?",
                 options: ["Alemania", "Italia", "Brasil", "Argentina"], correctIndex: 2),
    QuizQuestion(question: "¿Quién marcó más goles en un solo torneo de World Cup?",
                 options: ["Ronaldo", "Miroslav Klose", "Just Fontaine", "Gerd Müller"], correctIndex: 2),
    QuizQuestion(question: "¿Qué arquero es considerado el mejor de todos los tiempos?",
                 options: ["Peter Schmeichel", "Gianluigi Buffon", "Manuel Neuer", "Lev Yashin"], correctIndex: 3),
    QuizQuestion(question: "¿En qué club juega Cristiano Ronaldo en 2026?",
                 options: ["Manchester United", "Real Madrid", "Al Nassr", "Juventus"], correctIndex: 2),
    QuizQuestion(question: "¿Qué nación ganó el FIFA World Cup 2022?",
                 options: ["Francia", "Brasil", "Argentina", "Croacia"], correctIndex: 2),
    QuizQuestion(question: "¿Quién es el máximo goleador histórico del World Cup?",
                 options: ["Ronaldo Nazário", "Gerd Müller", "Miroslav Klose", "Lionel Messi"], correctIndex: 2),
    QuizQuestion(question: "¿A qué jugador apodan 'El Rey Egipcio'?",
                 options: ["Ahmed Hassan", "Mohamed Salah", "Hossam Hassan", "Amr Zaki"], correctIndex: 1),
    QuizQuestion(question: "¿En qué club juega Kylian Mbappé en 2026?",
                 options: ["PSG", "Real Madrid", "Bayern Munich", "Arsenal"], correctIndex: 1),
    QuizQuestion(question: "¿Qué equipo ganó el primer FIFA World Cup en 1930?",
                 options: ["Brasil", "Argentina", "Uruguay", "Italia"], correctIndex: 2),
]

private let ballsQuestions: [QuizQuestion] = [
    QuizQuestion(question: "El Jabulani fue la pelota oficial de qué World Cup:",
                 options: ["2006 Alemania", "2010 Sudáfrica", "2014 Brasil", "2018 Rusia"], correctIndex: 1),
    QuizQuestion(question: "¿En qué World Cup se usó la pelota Brazuca?",
                 options: ["2010", "2014", "2018", "2022"], correctIndex: 1),
    QuizQuestion(question: "El Telstar fue la primera pelota con pentágonos negros. ¿En qué año?",
                 options: ["1966", "1970", "1974", "1978"], correctIndex: 1),
    QuizQuestion(question: "La pelota del World Cup Qatar 2022 se llamaba:",
                 options: ["Brazuca", "Jabulani", "Al Rihla", "Teamgeist"], correctIndex: 2),
    QuizQuestion(question: "¿Qué pelota fue criticada por los arqueros por su movimiento impredecible?",
                 options: ["Brazuca", "Teamgeist", "Jabulani", "Al Rihla"], correctIndex: 2),
    QuizQuestion(question: "El Fevernova se usó en qué World Cup:",
                 options: ["1998 Francia", "2002 Corea/Japón", "2006 Alemania", "2010 Sudáfrica"], correctIndex: 1),
    QuizQuestion(question: "¿Qué pelota se usó en el World Cup Francia 1998?",
                 options: ["Tricolore", "Questra", "Fevernova", "Telstar"], correctIndex: 0),
    QuizQuestion(question: "Adidas provee la pelota oficial del World Cup desde:",
                 options: ["1954", "1970", "1978", "1982"], correctIndex: 1),
    QuizQuestion(question: "La pelota del World Cup Rusia 2018 se llamaba:",
                 options: ["Brazuca", "Al Rihla", "Telstar 18", "Jabulani"], correctIndex: 2),
    QuizQuestion(question: "¿Qué empresa fabrica todas las pelotas oficiales del FIFA World Cup?",
                 options: ["Nike", "Puma", "Adidas", "Under Armour"], correctIndex: 2),
]

private let footballIQQuestions: [QuizQuestion] = [
    QuizQuestion(question: "¿Cuánto dura un partido de fútbol estándar?",
                 options: ["80 minutos", "90 minutos", "100 minutos", "120 minutos"], correctIndex: 1),
    QuizQuestion(question: "¿Cuántos jugadores hay en el campo por equipo?",
                 options: ["10", "11", "12", "9"], correctIndex: 1),
    QuizQuestion(question: "¿Qué es un hat-trick?",
                 options: ["Dos goles en un partido", "Tres goles en un partido", "Cuatro goles en un partido", "Un penal atajado"], correctIndex: 1),
    QuizQuestion(question: "El offside aplica cuando:",
                 options: ["Un jugador está detrás de la mitad de cancha", "Un jugador está más cerca del arco que la pelota y el segundo último defensor al momento del pase", "Un jugador toca la pelota con la mano", "Un jugador está fuera del área"], correctIndex: 1),
    QuizQuestion(question: "¿Qué color de tarjeta expulsa a un jugador?",
                 options: ["Amarilla", "Naranja", "Roja", "Negra"], correctIndex: 2),
    QuizQuestion(question: "¿Cuántos cambios puede hacer un equipo en un partido estándar?",
                 options: ["3", "4", "5", "6"], correctIndex: 2),
    QuizQuestion(question: "¿Qué es un clásico?",
                 options: ["Un partido entre los dos primeros de la liga", "Un partido entre clubes rivales locales", "Una final de copa", "Un partido amistoso"], correctIndex: 1),
    QuizQuestion(question: "¿Qué país inventó el fútbol?",
                 options: ["Brasil", "España", "Inglaterra", "Alemania"], correctIndex: 2),
    QuizQuestion(question: "¿Qué significa VAR?",
                 options: ["Video Assistant Referee", "Virtual Automated Review", "Video Analysis Recording", "Verified Action Referee"], correctIndex: 0),
    QuizQuestion(question: "¿Desde dónde se ejecuta un penal?",
                 options: ["A 10 yardas", "A 12 yardas", "A 15 yardas", "A 18 yardas"], correctIndex: 1),
]

// MARK: - Category list

let quizCategories: [QuizCategory] = [
    QuizCategory(id: "timpayne",   emoji: "🇳🇿", label: "¿Sos del Ejército?",     subtitle: "35 preguntas · Tim, El Scarso y la leyenda", questions: timPayneQuestions,   isFeatured: true, gradientStart: Color(hex: "#F0C130"), gradientEnd: Color(hex: "#E07B00")),
    QuizCategory(id: "worldcup",   emoji: "⚽", label: "Mundial 2026",             subtitle: "Grupos, partidos y momentos de Tim",          questions: worldcupQuestions,   gradientStart: Color(hex: "#C0392B"), gradientEnd: Color(hex: "#7B0000")),
    QuizCategory(id: "deepLore",   emoji: "🇳🇿", label: "Lore de Tim Payne",       subtitle: "El Scarso, el origen, la leyenda",             questions: deepLoreQuestions,   gradientStart: Color(hex: "#00A859"), gradientEnd: Color(hex: "#005C30")),
    QuizCategory(id: "boots",      emoji: "👟", label: "¿Qué botín es?",           subtitle: "Total 90, Predator, Tiempo y más",             questions: bootsQuestions,      gradientStart: Color(hex: "#2980B9"), gradientEnd: Color(hex: "#1A3A5C")),
    QuizCategory(id: "goats",      emoji: "🏆", label: "Los Mejores del Mundo",    subtitle: "Cracks, Balón de Oro y debates",               questions: goatsQuestions,      gradientStart: Color(hex: "#8E44AD"), gradientEnd: Color(hex: "#4A0E6E")),
    QuizCategory(id: "balls",      emoji: "🔵", label: "¿Qué pelota es?",          subtitle: "Las pelotas del Mundial en la historia",       questions: ballsQuestions,      gradientStart: Color(hex: "#16A085"), gradientEnd: Color(hex: "#0A4D40")),
    QuizCategory(id: "footballiq", emoji: "🧠", label: "Fútbol IQ",                subtitle: "Reglas, historia y cultura futbolera",         questions: footballIQQuestions,  gradientStart: Color(hex: "#E67E22"), gradientEnd: Color(hex: "#7D3C00")),
]

// MARK: - QuizView (root)

struct QuizView: View {
    @State private var path: [QuizCategory] = []
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(hex: "#070A0D").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        // Featured card — full width
                        FeaturedCategoryCard(category: quizCategories[0]) {
                            path.append(quizCategories[0])
                        }
                        // 2-column grid for remaining categories
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                            ForEach(quizCategories.dropFirst()) { cat in
                                SmallCategoryCard(category: cat) {
                                    path.append(cat)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .navigationTitle("Quiz 🧠")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(for: QuizCategory.self) { cat in
                QuizGameView(category: cat, onDone: { path = [] }, appState: appState)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

// MARK: - Category Cards

private struct FeaturedCategoryCard: View {
    let category: QuizCategory
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                LinearGradient(
                    colors: [category.gradientStart, category.gradientEnd],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                // subtle dark vignette so text stays readable
                LinearGradient(
                    colors: [Color.black.opacity(0.25), Color.black.opacity(0.5)],
                    startPoint: .top, endPoint: .bottom
                )
                VStack(alignment: .leading, spacing: 10) {
                    Text("DESTACADO")
                        .font(.system(size: 10, weight: .bold))
                        .kerning(2)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.18))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.4), lineWidth: 1))

                    Text(category.label)
                        .font(.system(size: 22, weight: .black))
                        .foregroundStyle(.white)

                    Text(category.subtitle)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white.opacity(0.75))

                    HStack {
                        Spacer()
                        Text("Empezar Quiz →")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Spacer()
                    }
                    .padding(.top, 4)
                }
                .padding(24)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(minHeight: 200)
    }
}

private struct SmallCategoryCard: View {
    let category: QuizCategory
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topLeading) {
                LinearGradient(
                    colors: [category.gradientStart, category.gradientEnd],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                LinearGradient(
                    colors: [Color.black.opacity(0.15), Color.black.opacity(0.45)],
                    startPoint: .top, endPoint: .bottom
                )
                VStack(alignment: .leading, spacing: 8) {
                    Text(category.emoji)
                        .font(.system(size: 28))
                    Text(category.label)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(category.subtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(Color.white.opacity(0.7))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Text("→")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.white.opacity(0.9))
                }
                .padding(16)
            }
            .frame(maxWidth: .infinity, minHeight: 160, alignment: .topLeading)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

// MARK: - Confetti (CAEmitterLayer)

import UIKit

private struct FullScreenConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -10)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)

        let colors: [UIColor] = [
            UIColor(red: 0,       green: 168/255, blue: 89/255,  alpha: 1),
            UIColor(red: 240/255, green: 193/255, blue: 48/255,  alpha: 1),
            .white,
            .systemRed,
            .systemBlue,
            .systemOrange,
            .systemPink,
            .systemPurple,
        ]

        emitter.emitterCells = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate = 12
            cell.lifetime = 6.0
            cell.velocity = 400
            cell.velocityRange = 200
            cell.yAcceleration = 200
            cell.xAcceleration = 10
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = 3
            cell.spinRange = 5
            cell.scaleRange = 0.5
            cell.scale = 0.12
            cell.color = color.cgColor
            cell.contents = makeConfettiImage()
            return cell
        }

        view.layer.addSublayer(emitter)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            emitter.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            emitter.removeFromSuperlayer()
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func makeConfettiImage() -> CGImage? {
        let size = CGSize(width: 10, height: 6)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.fill(CGRect(origin: .zero, size: size))
        }
        return image.cgImage
    }
}

// MARK: - QuizGameView

struct QuizGameView: View {
    let category: QuizCategory
    let onDone: () -> Void
    let appState: AppState

    @State private var questions: [QuizQuestion] = []
    @State private var currentIndex: Int = 0
    @State private var score: Int = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showResult: Bool = false

    // Confetti
    @State private var showConfetti: Bool = false
    @State private var confettiTrigger: Int = 0
    @State private var correctAnswerCount: Int = 0

    // Wrong X
    @State private var showWrongX: Bool = false
    @State private var wrongXScale: CGFloat = 0.3
    @State private var wrongXOpacity: Double = 1.0

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(red: 7/255, green: 10/255, blue: 13/255).ignoresSafeArea()
            Color(red: 7/255, green: 10/255, blue: 13/255) // fills any transition gap

            if showResult {
                QuizResultView(
                    category: category,
                    score: score,
                    total: questions.count,
                    onPlayAgain: { resetQuiz() },
                    onDone: { dismiss() }
                )
                .transition(.opacity)
            } else if !questions.isEmpty {
                QuizQuestionView(
                    question: questions[currentIndex],
                    questionNumber: currentIndex + 1,
                    total: questions.count,
                    score: score,
                    selectedAnswer: $selectedAnswer,
                    onAnswer: handleAnswer
                )
                .id(currentIndex)
            }

            // Confetti burst — topmost layer, above all content
            if showConfetti {
                FullScreenConfettiView()
                    .id(confettiTrigger)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }

            // Wrong ❌ overlay
            if showWrongX {
                Text("❌")
                    .font(.system(size: 120))
                    .scaleEffect(wrongXScale)
                    .opacity(wrongXOpacity)
                    .animation(.spring(response: 0.28, dampingFraction: 0.55), value: wrongXScale)
                    .animation(.easeOut(duration: 0.8), value: wrongXOpacity)
                    .allowsHitTesting(false)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(red: 7/255, green: 10/255, blue: 13/255), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sensoryFeedback(.success, trigger: correctAnswerCount)
        .onAppear { resetQuiz() }
    }

    private func resetQuiz() {
        questions = Array(category.questions.shuffled().prefix(5))
        currentIndex = 0
        score = 0
        selectedAnswer = nil
        showResult = false
        showConfetti = false
        showWrongX = false
    }

    private func handleAnswer(_ index: Int) {
        guard selectedAnswer == nil else { return }
        selectedAnswer = index
        let isCorrect = index == questions[currentIndex].correctIndex

        if isCorrect {
            score += 1
            correctAnswerCount += 1   // triggers .sensoryFeedback
            confettiTrigger += 1      // forces UIViewRepresentable to re-create emitter
            showConfetti = true       // fires immediately on tap
        } else {
            wrongXScale = 0.3
            wrongXOpacity = 1.0
            showWrongX = true
            // Trigger scale and fade on next runloop tick so initial state renders first
            DispatchQueue.main.async {
                wrongXScale = 1.5
                wrongXOpacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                showWrongX = false
            }
        }

        let delay: Double = isCorrect ? 3.0 : 1.2
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            showConfetti = false
            showWrongX = false
            wrongXScale = 0.3
            wrongXOpacity = 1.0
            withAnimation(.none) {
                if currentIndex + 1 < questions.count {
                    currentIndex += 1
                    selectedAnswer = nil
                } else {
                    if score > appState.quizBestScore { appState.quizBestScore = score }
                    showResult = true
                }
            }
        }
    }
}

// MARK: - Quiz Question View

// Neo-brutalism option palette — A / B / C / D
private let quizOptionColors: [Color] = [
    Color(hex: "#E91E76"),   // A · hot pink
    Color(hex: "#2ECC71"),   // B · emerald green
    Color(hex: "#F0C130"),   // C · gold yellow
    Color(hex: "#3498DB"),   // D · sky blue
]
private let quizCorrectGreen = Color(hex: "#2ECC71")

private struct QuizQuestionView: View {
    let question: QuizQuestion
    let questionNumber: Int
    let total: Int
    let score: Int
    @Binding var selectedAnswer: Int?
    let onAnswer: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // TOP BAR — question counter centered, running score on the right
            ZStack {
                Text("PREGUNTA \(questionNumber) DE \(total)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                HStack(spacing: 5) {
                    Spacer()
                    Text("⚽")
                        .font(.system(size: 16))
                    Text("\(score)")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color(hex: "#F0C130"))
                        .contentTransition(.numericText())
                }
            }
            .padding(.bottom, 16)

            // PROGRESS BAR — chunky gold
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.12))
                    Capsule()
                        .fill(Color(hex: "#F0C130"))
                        .frame(width: max(0, geo.size.width * CGFloat(questionNumber) / CGFloat(total)))
                }
            }
            .frame(height: 6)
            .padding(.bottom, 28)

            // QUESTION — left aligned, bold, no quotes
            Text(question.question)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 24)

            // ANSWER BUTTONS — bright neo-brutalism blocks
            VStack(spacing: 14) {
                ForEach(0..<question.options.count, id: \.self) { i in
                    AnswerButton(
                        text: question.options[i],
                        baseColor: quizOptionColors[i % quizOptionColors.count],
                        state: answerState(for: i),
                        onTap: { onAnswer(i) }
                    )
                }
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private func answerState(for index: Int) -> AnswerState {
        guard let selected = selectedAnswer else { return .idle }
        if index == question.correctIndex { return .correct }
        if index == selected { return .wrong }
        return .dimmed
    }
}

enum AnswerState { case idle, correct, wrong, dimmed }

private struct NeoBrutalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct AnswerButton: View {
    let text: String
    let baseColor: Color
    let state: AnswerState
    let onTap: () -> Void

    @State private var pulse = false

    private var isCorrect: Bool { state == .correct }
    private var isDimmed: Bool { state == .wrong || state == .dimmed }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Text(text)
                    .font(.system(size: 17, weight: .heavy))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                if isCorrect {
                    Spacer(minLength: 0)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.black)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 72)
            .padding(.horizontal, 18)
            .background(isCorrect ? quizCorrectGreen : baseColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(NeoBrutalButtonStyle())
        .opacity(isDimmed ? 0.4 : 1.0)
        .scaleEffect(isCorrect && pulse ? 1.04 : 1.0)
        .shadow(color: .black.opacity(0.6), radius: 0, x: 3, y: 3)
        .disabled(state != .idle)
        .animation(.easeInOut(duration: 0.25), value: isDimmed)
        .onChange(of: state) { _, newState in
            if newState == .correct {
                withAnimation(.easeInOut(duration: 0.45).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
        }
    }
}

// MARK: - Quiz Result View

private struct QuizResultView: View {
    let category: QuizCategory
    let score: Int
    let total: Int
    let onPlayAgain: () -> Void
    let onDone: () -> Void

    private var pct: Int { score * 100 / total }

    private var headline: String {
        switch score {
        case 5:  return "¡PERFECTO! 🏆"
        case 4:  return "¡Casi perfecto! 🔥"
        case 3:  return "¡Nada mal! ⚡"
        default: return "¡Seguí practicando! 💪"
        }
    }

    private var headlineColor: Color {
        switch score {
        case 5:  return Color(hex: "#F0C130")   // gold
        case 4:  return Color(hex: "#2ECC71")   // green
        case 3:  return .white
        default: return Color(hex: "#8E8E93")   // gray
        }
    }

    private var tierDesc: String {
        switch score {
        case 5:    return "Existís en silencio, defendés con confianza, y de alguna forma 2,9 millones de personas te bancaron. Icónico."
        case 4:    return "Sos básicamente el suplente de Tim. Misma energía, un poco menos viral."
        case 3:    return "Aparecés. Lo intentás. De vez en cuando alguien en Buenos Aires se da cuenta."
        case 2:    return "Conocés a Tim Payne. Con eso alcanza. Bienvenido al ejército."
        default:   return "Probablemente tenés cuenta verificada. Una vergüenza."
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Result card
            VStack(spacing: 16) {
                Text(category.emoji)
                    .font(.system(size: 48))

                Text("\(score)/\(total)")
                    .font(.system(size: 80, weight: .black, design: .default))
                    .foregroundStyle(.white)
                    .kerning(-2)

                Text(headline)
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(headlineColor)
                    .multilineTextAlignment(.center)

                if category.id == "timpayne" {
                    Text(tierDesc)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.top, 4)
                        .padding(.horizontal, 8)
                }
            }
            .padding(28)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#12121A"))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(headlineColor.opacity(0.3), lineWidth: 1.5)
            )

            Spacer()

            VStack(spacing: 12) {
                ShareLink(item: "Saqué \(score)/\(total) (\(pct)%) en \"\(category.label)\" 🇳🇿 #NoPayneNoGain timpaynefans.com") {
                    HStack {
                        Spacer()
                        Label("Compartir resultado", systemImage: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color(hex: "#070A0D"))
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .background(Color(hex: "#F0C130"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button(action: onPlayAgain) {
                    HStack {
                        Spacer()
                        Text("Intentar de nuevo")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                }

                Button(action: onDone) {
                    Text("← Volver a los Quizzes")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
}

#Preview {
    QuizView()
        .environment(AppState())
}
