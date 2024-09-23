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
    @Environment(\.presentationMode) var presentationMode
    
    private let baseURL = "https://fnapi.fia-s.com/api"
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(1.0).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
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
                    TextField(NSLocalizedString("FlareNote_Input_user_name", comment: "ViewFlareNoteUploader"), text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(isUserRegistered)
                        .foregroundColor(.black)
                    
                    Button(action: registerUser) {
                        Text(NSLocalizedString("FlareNote_Register User", comment: "ViewFlareNoteUploader"))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(isUserRegistered)
                    
                    Button(action: sendData) {
                        Text(NSLocalizedString("FlareNote_Send Song Data", comment: "ViewFlareNoteUploader"))
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
                        .frame(maxWidth: .infinity)
                        
                        Button(NSLocalizedString("FlareNote_Your Page", comment: "ViewFlareNoteUploader")) {
                            openURL("https://flarenote.fia-s.com/personal-skill/\(userName)")
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        .disabled(!isUserRegistered)
                        .frame(maxWidth: .infinity)
                    }
                    
                    Button(NSLocalizedString("FlareNote_Delete User", comment: "ViewFlareNoteUploader"), action: deleteUser)
                        .buttonStyle(DangerButtonStyle())
                    
                    Text(NSLocalizedString("FlareNote_How to use", comment: "ViewFlareNoteUploader"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(NSLocalizedString("FlareNote_How to use detail", comment: "ViewFlareNoteUploader"))
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
        .onAppear {
            let (savedId, savedName) = getIdAndName()
            self.userId = savedId
            self.userName = savedName
            
            isUserRegistered = !userId.isEmpty
        }
    }
    
    func registerUser() {
        guard !userName.isEmpty else {
            message = NSLocalizedString("FlareNote_Please enter your username", comment: "ViewFlareNoteUploader")
            return
        }
        
        let url = URL(string: "\(baseURL)/create-user")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["name": userName]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
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
    
    func sendData() {
        guard isUserRegistered, !userId.isEmpty else {
            message = NSLocalizedString("FlareNote_Please register user", comment: "FlareNoteUploader")
            return
        }
        
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
    
    func deleteUser() {
        guard isUserRegistered, !userId.isEmpty else {
            message = "No user found."
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
                    self.userId = ""
                    self.userName = ""
                    saveIdAndName(id: "", name: "")
                } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    self.message = String(format: NSLocalizedString("FlareNote_error detail", comment: "FlareNoteUploader"), errorResponse.error, errorResponse.detail ?? "none")
                } else {
                    self.message = "Unknown error occurred."
                }
            }
        }.resume()
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

//struct FlareSkillNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewFlareNoteUploader()
//    }
//}
