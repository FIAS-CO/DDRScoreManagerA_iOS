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
    func findPlayerByGoogleToken(_ googleToken: String) async -> FindPlayerResult {
        let url = URL(string: "\(baseURL)/auth/find-player-by-google")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let body = ["googleToken": googleToken]
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard !data.isEmpty else {
                return FindPlayerResult(
                    success: false,
                    found: false,
                    player: nil,
                    message: "サーバーからのレスポンスがありません"
                )
            }
            
            if let response = try? JSONDecoder().decode(FindPlayerResponse.self, from: data) {
                if response.success && response.found, let player = response.player {
                    // 既存のユーザーが見つかった場合
                    return FindPlayerResult(
                        success: true,
                        found: true,
                        player: player,
                        message: "Googleアカウントで認証され、ユーザー「\(player.name)」としてログインしました"
                    )
                } else {
                    return FindPlayerResult(
                        success: true,
                        found: false,
                        player: nil,
                        message: "Googleアカウントに紐づけられたユーザーが見つかりませんでした。新規ユーザー登録を行ってください。"
                    )
                }
            } else {
                return FindPlayerResult(
                    success: false,
                    found: false,
                    player: nil,
                    message: "レスポンスの解析に失敗しました"
                )
            }
        } catch {
            return FindPlayerResult(
                success: false,
                found: false,
                player: nil,
                message: "エラー: \(error.localizedDescription)"
            )
        }
    }
    
    // ユーザーとGoogleアカウントを紐づける
    func connectUserWithGoogleToken(playerId: String, googleToken: String) async -> ConnectGoogleResult {
        let url = URL(string: "\(baseURL)/auth/connect-google")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let body = ["playerId": playerId, "googleToken": googleToken]
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard !data.isEmpty else {
                return ConnectGoogleResult(
                    success: false,
                    player: nil,
                    message: "サーバーからのレスポンスがありません"
                )
            }
            
            if let response = try? JSONDecoder().decode(ConnectGoogleResponse.self, from: data) {
                if response.success {
                    return ConnectGoogleResult(
                        success: true,
                        player: response.player,
                        message: "Googleアカウントとの連携が完了しました"
                    )
                } else {
                    return ConnectGoogleResult(
                        success: false,
                        player: nil,
                        message: "Googleアカウント連携に失敗しました: \(response.error ?? "不明なエラー")"
                    )
                }
            } else {
                return ConnectGoogleResult(
                    success: false,
                    player: nil,
                    message: "レスポンスの解析に失敗しました"
                )
            }
        } catch {
            return ConnectGoogleResult(
                success: false,
                player: nil,
                message: "エラー: \(error.localizedDescription)"
            )
        }
    }
    
    // Googleアカウントとの連携を解除する
    func unlinkGoogleAccount(playerId: String) async -> (success: Bool, message: String) {
        let url = URL(string: "\(baseURL)/auth/unlink-google")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let body = ["playerId": playerId]
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard !data.isEmpty else {
                return (false, "サーバーからのレスポンスがありません")
            }
            
            
            if let response = try? JSONDecoder().decode([String: Bool].self, from: data),
               response["success"] == true {
                return (true, "Googleアカウントとの連携を解除しました")
            } else if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                      let errorMessage = errorResponse["error"] {
                return (false, errorMessage)
            } else {
                return (false, "Googleアカウント連携解除に失敗しました")
            }
        } catch {
            return (false, "エラー: \(error.localizedDescription)")
        }
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
