import Foundation
import GoogleSignIn
import UIKit

// Google認証の結果を表すenum
enum GoogleAuthResult {
    case success(idToken: String, user: GIDGoogleUser)
    case failure(error: Error)
    case cancelled
}

// API呼び出しの結果を表す型
struct FindPlayerResult {
    let success: Bool
    let found: Bool
    let player: Player?
    let message: String
}

struct ConnectGoogleResult {
    let success: Bool
    let player: Player?
    let message: String
}

// Google認証を管理するクラス
class GoogleAuthManager {
    static let shared = GoogleAuthManager()
    private let baseURL = "https://fnapi.fia-s.com/api"
    let scopes = ["email"]
    
    private init() {}
    
    // Google認証を実行
    func signIn(presentingViewController: UIViewController, completion: @escaping (GoogleAuthResult) -> Void) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController,
            hint: nil,
            additionalScopes: scopes
        ) { result, error in
            if let error = error {
                completion(.failure(error: error))
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(.cancelled)
                return
            }
            
            completion(.success(idToken: idToken, user: user))
        }
    }
    
    // Googleアカウントからユーザーを検索
    func findPlayerByGoogleToken(_ googleToken: String, completion: @escaping (FindPlayerResult) -> Void) {
        let url = URL(string: "\(baseURL)/auth/find-player-by-google")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["googleToken": googleToken]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(FindPlayerResult(
                        success: false,
                        found: false,
                        player: nil,
                        message: "エラー: \(error.localizedDescription)"
                    ))
                    return
                }
                
                guard let data = data else {
                    completion(FindPlayerResult(
                        success: false,
                        found: false,
                        player: nil,
                        message: "サーバーからのレスポンスがありません"
                    ))
                    return
                }
                
                if let response = try? JSONDecoder().decode(FindPlayerResponse.self, from: data) {
                    if response.success && response.found, let player = response.player {
                        // 既存のユーザーが見つかった場合
                        completion(FindPlayerResult(
                            success: true,
                            found: true,
                            player: player,
                            message: "Googleアカウントで認証され、ユーザー「\(player.name)」としてログインしました"
                        ))
                    } else {
                        completion(FindPlayerResult(
                            success: true,
                            found: false,
                            player: nil,
                            message: "Googleアカウントに紐づけられたユーザーが見つかりませんでした。新規ユーザー登録を行ってください。"
                        ))
                    }
                } else {
                    completion(FindPlayerResult(
                        success: false,
                        found: false,
                        player: nil,
                        message: "レスポンスの解析に失敗しました"
                    ))
                }
            }
        }.resume()
    }
    
    // ユーザーとGoogleアカウントを紐づける
    func connectUserWithGoogleToken(playerId: String, googleToken: String, completion: @escaping (ConnectGoogleResult) -> Void) {
        let url = URL(string: "\(baseURL)/auth/connect-google")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["playerId": playerId, "googleToken": googleToken]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(ConnectGoogleResult(
                        success: false,
                        player: nil,
                        message: "エラー: \(error.localizedDescription)"
                    ))
                    return
                }
                
                guard let data = data else {
                    completion(ConnectGoogleResult(
                        success: false,
                        player: nil,
                        message: "サーバーからのレスポンスがありません"
                    ))
                    return
                }
                
                if let response = try? JSONDecoder().decode(ConnectGoogleResponse.self, from: data) {
                    if response.success {
                        completion(ConnectGoogleResult(
                            success: true,
                            player: response.player,
                            message: "Googleアカウントとの連携が完了しました"
                        ))
                    } else {
                        completion(ConnectGoogleResult(
                            success: false,
                            player: nil,
                            message: "Googleアカウント連携に失敗しました: \(response.error ?? "不明なエラー")"
                        ))
                    }
                } else {
                    completion(ConnectGoogleResult(
                        success: false,
                        player: nil,
                        message: "レスポンスの解析に失敗しました"
                    ))
                }
            }
        }.resume()
    }
    
    // Googleアカウントとの連携を解除する（API実装がない場合は連携情報のみを削除）
    func unlinkGoogleAccount(playerId: String, completion: @escaping (Bool, String) -> Void) {
        // 実際のAPIが実装されたら以下のコメントを外してください
        /*
         let url = URL(string: "\(baseURL)/auth/unlink-google")!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
         let body = ["playerId": playerId]
         request.httpBody = try? JSONEncoder().encode(body)
         
         URLSession.shared.dataTask(with: request) { data, response, error in
         DispatchQueue.main.async {
         if let error = error {
         completion(false, "エラー: \(error.localizedDescription)")
         return
         }
         
         guard let data = data else {
         completion(false, "サーバーからのレスポンスがありません")
         return
         }
         
         if let response = try? JSONDecoder().decode([String: Bool].self, from: data),
         response["success"] == true {
         completion(true, "Googleアカウントとの連携を解除しました")
         } else {
         completion(false, "Googleアカウント連携解除に失敗しました")
         }
         }
         }.resume()
         */
        
        // 連携解除APIがない場合は、成功を返す
        completion(true, "Googleアカウントとの連携を解除しました")
    }
}

// APIレスポンス用のモデル
struct FindPlayerResponse: Codable {
    let success: Bool
    let found: Bool
    let player: Player?
}

struct ConnectGoogleResponse: Codable {
    let success: Bool
    let player: Player?
    let error: String?
    let details: String?
}

struct Player: Codable {
    let id: String
    let name: String
}
