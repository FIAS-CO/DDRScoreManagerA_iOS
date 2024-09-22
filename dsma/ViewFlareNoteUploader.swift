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
    @State private var username: String = ""
    @State private var message: String = ""
    @State private var isUserRegistered: Bool = false
    @State private var userId: String = ""
    @State private var showHowToUse: Bool = false
    
    private let baseURL = "https://fnapi.fia-s.com/api"
    
    var body: some View {
        ZStack {
            Color.black.opacity(1.0).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    TextField("ユーザー名を入力", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(isUserRegistered)
                        .foregroundColor(.black)
                    
                    Button(action: registerUser) {
                        Text("ユーザー登録")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(isUserRegistered)
                    
                    Button(action: sendData) {
                        Text("楽曲データを送信")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Text(message)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    HStack {
                        Button("FlareNote TOP") {
                            openURL("https://flarenote.fia-s.com")
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        Button("ユーザーページ") {
                            openURL("https://flarenote.fia-s.com/personal-skill/\(username)")
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        .disabled(!isUserRegistered)
                    }
                    
                    Button("ユーザー削除", action: deleteUser)
                        .buttonStyle(DangerButtonStyle())
                    
                        Text("使い方")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    
                        Text("ここに使い方の説明を記述")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                }
                .padding()
            }
        }
        .foregroundColor(.white)
        .navigationTitle("DDR FlareNote")
    }
    
    func registerUser() {
        guard !username.isEmpty else {
            message = "ユーザー名を入力してください"
            return
        }
        
        let url = URL(string: "\(baseURL)/create-user")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["name": username]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.message = "エラー: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.message = "データが受信できませんでした"
                    return
                }
                
                if let userResponse = try? JSONDecoder().decode(UserResponse.self, from: data) {
                    self.userId = userResponse.id
                    self.message = "ユーザー '\(userResponse.name)' が登録されました"
                    self.isUserRegistered = true
                    // ここでUserDefaultsなどにuserIdとusernameを保存するとよいでしょう
                } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    self.message = "エラー: \(errorResponse.error)\n詳細: \(errorResponse.detail ?? "なし")"
                } else {
                    self.message = "不明なエラーが発生しました"
                }
            }
        }.resume()
    }
    
    func sendData() {
        guard isUserRegistered, !userId.isEmpty else {
            message = "ユーザーを登録してからデータを送信してください"
            return
        }
        
        // ここで楽曲データを取得し、JSONに変換する処理を行います
        // この例では、ダミーデータを使用しています
        let dummyData: [String: Any] = [
            "userId": userId,
            "scores": [["songId": "1", "score": 1000000]]
        ]
        
        let url = URL(string: "\(baseURL)/player-scores")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dummyData, options: [])
            request.httpBody = jsonData
        } catch {
            self.message = "JSONの作成に失敗しました: \(error.localizedDescription)"
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.message = "エラー: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.message = "データが受信できませんでした"
                    return
                }
                
                if let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.message = "データが正常に送信されました"
                } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    self.message = "エラー: \(errorResponse.error)\n詳細: \(errorResponse.detail ?? "なし")"
                } else {
                    self.message = "不明なエラーが発生しました"
                }
            }
        }.resume()
    }
    
    func deleteUser() {
        guard isUserRegistered, !userId.isEmpty else {
            message = "削除するユーザーが登録されていません"
            return
        }
        
        let url = URL(string: "\(baseURL)/delete-user")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["id": userId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.message = "エラー: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.message = "データが受信できませんでした"
                    return
                }
                
                if let response = try? JSONDecoder().decode([String: String].self, from: data),
                   let deletedUser = response["user"] {
                    self.message = "ユーザー '\(deletedUser)' が削除されました"
                    self.isUserRegistered = false
                    self.userId = ""
                    self.username = ""
                    // ここでUserDefaultsなどからuserIdとusernameを削除するとよいでしょう
                } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    self.message = "エラー: \(errorResponse.error)\n詳細: \(errorResponse.detail ?? "なし")"
                } else {
                    self.message = "不明なエラーが発生しました"
                }
            }
        }.resume()
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
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
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct DangerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct FlareSkillNoteView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFlareNoteUploader()
    }
}
