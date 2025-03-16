import SwiftUI

class FlareSkillNoteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swiftUIView = ViewFlareNoteUploader()
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }
}

struct ViewFlareNoteUploader: View {
    @State private var userName: String = ""
    @State private var message: String = ""
    @State private var isUserRegistered: Bool = false
    @State private var userId: String = ""
    @State private var showHowToUse: Bool = false
    @State private var isGoogleLinked: Bool = false
    @State private var isLoading: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    private let baseURL = "https://fnapi.fia-s.com/api"
    
    var body: some View {
        ZStack {
            Color.black.opacity(1.0).edgesIgnoringSafeArea(.all)
            
            VStack {
                // ヘッダー部分
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.blue)
                            .font(.system(size: 20, weight: .bold))
                    }
                    .frame(width: 44, height: 44)
                    
                    Spacer()
                    
                    Text("FlareNote Uploader")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Spacer()
                    
                    // 右側のスペースを確保するための空のビュー
                    Color.clear.frame(width: 44, height: 44)
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        if !isUserRegistered {
                            // ユーザー未登録時の表示
                            nonRegisteredUserView
                        } else {
                            // ユーザー登録済み時の表示
                            registeredUserView
                        }
                        
                        Text(message)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        
                        // 共通のリンクボタン
                        HStack {
                            Button("FlareNote TOP") {
                                openURL("https://flarenote.fia-s.com")
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .frame(maxWidth: .infinity)
                            
                            Button(NSLocalizedString("FlareNote_Your Page", comment: "ViewFlareNoteUploader")) {
                                openURL("https://flarenote.fia-s.com/personal-skill/\(userName)")
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .disabled(!isUserRegistered)
                            .frame(maxWidth: .infinity)
                        }
                        
                        if isUserRegistered {
                            Button(NSLocalizedString("FlareNote_Delete User", comment: "ViewFlareNoteUploader"), action: deleteUser)
                                .buttonStyle(DangerButtonStyle())
                        }
                        
                        Text(NSLocalizedString("FlareNote_How to use", comment: "ViewFlareNoteUploader"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(NSLocalizedString("FlareNote_How to use detail", comment: "ViewFlareNoteUploader"))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                AdMobBannerView()
                    .frame(height: 50)
            }
            .padding()
            .disabled(isLoading)
            
            if isLoading {
                LoadingView()
            }
        }
        .foregroundColor(.white)
        .navigationTitle("DDR FlareNote")
        .onAppear {
            loadUserData()
        }
    }
    
    // 未登録ユーザー向けビュー
    private var nonRegisteredUserView: some View {
        VStack(spacing: 20) {
            AdaptiveTextField(
                text: $userName,
                placeholder: "FlareNote_Input_user_name",
                isDisabled: false
            )
            
            Button(action: registerUser) {
                Text(NSLocalizedString("FlareNote_Register User", comment: "ViewFlareNoteUploader"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Divider().background(Color.white.opacity(0.3))
            
            Text("Googleアカウントでログイン")
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: findUserWithGoogle) {
                HStack {
                    Image(systemName: "g.circle.fill")
                        .foregroundColor(.white)
                    Text("Google アカウントと連携")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(GoogleButtonStyle())
        }
    }
    
    // 登録済みユーザー向けビュー
    private var registeredUserView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("ユーザー名: \(userName)")
                    .fontWeight(.bold)
                Spacer()
            }
            
            Button(action: sendData) {
                Text(NSLocalizedString("FlareNote_Send Song Data", comment: "ViewFlareNoteUploader"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Divider().background(Color.white.opacity(0.3))
            
            if isGoogleLinked {
                Button(action: unlinkGoogleAccount) {
                    HStack {
                        Image(systemName: "link.badge.minus")
                            .foregroundColor(.white)
                        Text("Google アカウント連携を解除")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(GoogleDisconnectButtonStyle())
            } else {
                Button(action: linkGoogleAccount) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(.white)
                        Text("Google アカウントと連携")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(GoogleButtonStyle())
            }
        }
    }
    
    // ローディング表示用ビュー
    private struct LoadingView: View {
        var body: some View {
            ZStack {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Text("処理中...")
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
                .padding(25)
                .background(Color.gray.opacity(0.7))
                .cornerRadius(10)
            }
        }
    }
    
    // ユーザーデータの読み込み
    private func loadUserData() {
        let (savedId, savedName) = getIdAndName()
        self.userId = savedId
        self.userName = savedName
        
        isUserRegistered = !userId.isEmpty
        
        // Google連携状態の確認（UserDefaultsなどから読み込む）
        isGoogleLinked = UserDefaults.standard.bool(forKey: "isGoogleLinked_\(userId)")
    }
    
    // ユーザー登録処理
    func registerUser() {
        guard !userName.isEmpty else {
            message = NSLocalizedString("FlareNote_Please enter your username", comment: "ViewFlareNoteUploader")
            return
        }
        
        isLoading = true
        
        let url = URL(string: "\(baseURL)/create-user")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["name": userName]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.message = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.message = NSLocalizedString("FlareNote_Recieving data is failed", comment: "ViewFlareNoteUploader")
                    return
                }
                
                if let userResponse = try? JSONDecoder().decode(UserResponse.self, from: data) {
                    self.userId = userResponse.id
                    self.message = String(format: NSLocalizedString("FlareNote_User created successfully", comment: "FlareNoteUploader"), userName)
                    self.isUserRegistered = true
                    
                    saveIdAndName(id: self.userId, name: self.userName)
                } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    self.message = String(format: NSLocalizedString("FlareNote_error detail", comment: "FlareNoteUploader"), errorResponse.error, errorResponse.detail ?? "none")
                } else {
                    self.message = "Unknown error occurred."
                }
            }
        }.resume()
    }
    
    // 曲データ送信処理
    func sendData() {
        guard isUserRegistered, !userId.isEmpty else {
            message = NSLocalizedString("FlareNote_Please register user", comment: "FlareNoteUploader")
            return
        }
        
        isLoading = true
        
        let url = URL(string: "\(baseURL)/player-scores")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var musicScores = FileReader.readScoreList(nil)
        let musicData = FileReader.readMusicList()
        FlareSkillUpdater.updateAllFlareSkills(musicData: musicData, scoreData: &musicScores)
        let jsonData = TopFlareSkillProcessor.processTopFlareSkills(playerId: userId, mScoreList: musicScores, musicDataMap: musicData).data(using: .utf8)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.message = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.message = NSLocalizedString("FlareNote_Recieving data is failed", comment: "ViewFlareNoteUploader")
                    return
                }
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    self.message = String(format: NSLocalizedString("FlareNote_error detail", comment: "FlareNoteUploader"), errorResponse.error, errorResponse.detail ?? "none")
                } else if (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) != nil {
                    self.message = NSLocalizedString("FlareNote_Sent data successfully", comment: "ViewFlareNoteUploader")
                } else {
                    self.message = "Unknown error occurred."
                }
            }
        }.resume()
    }
    
    // ユーザー削除
    func deleteUser() {
        guard isUserRegistered, !userId.isEmpty else {
            message = "No user found."
            return
        }
        
        isLoading = true
        
        let url = URL(string: "\(baseURL)/delete-user")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["id": userId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.message = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.message = NSLocalizedString("FlareNote_Recieving data is failed", comment: "ViewFlareNoteUploader")
                    return
                }
                
                if let response = try? JSONDecoder().decode([String: String].self, from: data),
                   let deletedUser = response["user"] {
                    self.message = String(format: NSLocalizedString("FlareNote_User deleted", comment: "ViewFlareNoteUploader"), userName)
                    self.isUserRegistered = false
                    self.isGoogleLinked = false
                    self.userId = ""
                    self.userName = ""
                    
                    // Google連携情報も削除
                    UserDefaults.standard.removeObject(forKey: "isGoogleLinked_\(userId)")
                    
                    saveIdAndName(id: "", name: "")
                } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    self.message = String(format: NSLocalizedString("FlareNote_error detail", comment: "FlareNoteUploader"), errorResponse.error, errorResponse.detail ?? "none")
                } else {
                    self.message = "Unknown error occurred."
                }
            }
        }.resume()
    }
    
    // Googleアカウントを使ってユーザーを検索
    func findUserWithGoogle() {
        isLoading = true
        
        // rootViewControllerを取得
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            isLoading = false
            message = "内部エラー: rootViewControllerが見つかりません"
            return
        }
        
        GoogleAuthManager.shared.signIn(presentingViewController: rootViewController) { result in
            switch result {
            case .success(let idToken, _):
                GoogleAuthManager.shared.findPlayerByGoogleToken(idToken) { result in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.message = result.message
                        
                        if result.success && result.found, let player = result.player {
                            self.userId = player.id
                            self.userName = player.name
                            self.isUserRegistered = true
                            self.isGoogleLinked = true
                            
                            UserDefaults.standard.set(true, forKey: "isGoogleLinked_\(player.id)")
                            saveIdAndName(id: player.id, name: player.name)
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.message = "Google認証エラー: \(error.localizedDescription)"
                }
                
            case .cancelled:
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.message = "Google認証がキャンセルされました"
                }
            }
        }
    }
    
    // Googleアカウントとユーザーを紐づける
    func linkGoogleAccount() {
        guard isUserRegistered, !userId.isEmpty else {
            message = "ユーザーが登録されていません"
            return
        }
        
        isLoading = true
        
        // rootViewControllerを取得
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            isLoading = false
            message = "内部エラー: rootViewControllerが見つかりません"
            return
        }
        
        GoogleAuthManager.shared.signIn(presentingViewController: rootViewController) { result in
            switch result {
            case .success(let idToken, _):
                GoogleAuthManager.shared.connectUserWithGoogleToken(playerId: self.userId, googleToken: idToken) { result in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.message = result.message
                        
                        if result.success {
                            self.isGoogleLinked = true
                            UserDefaults.standard.set(true, forKey: "isGoogleLinked_\(self.userId)")
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.message = "Google認証エラー: \(error.localizedDescription)"
                }
                
            case .cancelled:
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.message = "Google認証がキャンセルされました"
                }
            }
        }
    }
    
    // Googleアカウントとの連携を解除
    func unlinkGoogleAccount() {
        isLoading = true
        
        GoogleAuthManager.shared.unlinkGoogleAccount(playerId: userId) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                self.message = message
                
                if success {
                    self.isGoogleLinked = false
                    UserDefaults.standard.set(false, forKey: "isGoogleLinked_\(self.userId)")
                }
            }
        }
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

func saveIdAndName(id: String, name: String) {
    let defaults = UserDefaults.standard
    defaults.set(id, forKey: "flareNoteId")
    defaults.set(name, forKey: "flareNoteName")
    print("IDと名前を保存しました: \(id), \(name)")
}

func getIdAndName() -> (id: String, name: String) {
    let defaults = UserDefaults.standard
    
    // 保存されていなければデフォルト値を使用
    let id = defaults.string(forKey: "flareNoteId") ?? ""
    let name = defaults.string(forKey: "flareNoteName") ?? "" // `nil`の場合は空文字を返す
    
    return (id, name)
}

struct UserResponse: Codable {
    let id: String
    let name: String
}

struct ErrorResponse: Codable {
    let error: String
    let detail: String?
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isEnabled ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
            .foregroundColor(isEnabled ? .white : .gray)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEnabled ? Color.white.opacity(0.5) : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.black.opacity(0.3))
            .foregroundColor(isEnabled ? .white : .gray)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEnabled ? Color.white.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct GoogleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue.opacity(0.5))
            .foregroundColor(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue.opacity(0.8), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct GoogleDisconnectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.orange.opacity(0.5))
            .foregroundColor(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.orange.opacity(0.8), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct DangerButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isEnabled ? Color.red.opacity(0.3) : Color.red.opacity(0.1))
            .foregroundColor(isEnabled ? .white : .gray)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEnabled ? Color.red.opacity(0.5) : Color.red.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct AdaptiveTextField: View {
    @Binding var text: String
    let placeholder: String
    let isDisabled: Bool
    
    var body: some View {
        TextField(NSLocalizedString(placeholder, comment: ""), text: $text)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .foregroundColor(textColor)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )
            .disabled(isDisabled)
            .environment(\.colorScheme, .light) // 常にライトモードの外観を強制
    }
    
    private var backgroundColor: Color {
        isDisabled ? Color(.systemGray5) : Color.white
    }
    
    private var borderColor: Color {
        isDisabled ? Color.gray.opacity(0.4) : Color.gray.opacity(0.5)
    }
    
    private var textColor: Color {
        isDisabled ? Color.gray.opacity(0.7) : .black
    }
}
