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

struct UnlinkResponse: Codable {
    let success: Bool
    let message: String?
}

// 連携解除時のエラーレスポンス構造体
struct UnlinkErrorResponse: Codable {
    let success: Bool
    let error: String
    let details: String?
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
                    message: NSLocalizedString("No response from server", comment: "GoogleAuthManager")
                )
            }
            
            if let response = try? JSONDecoder().decode(FindPlayerResponse.self, from: data) {
                if response.success && response.found, let player = response.player {
                    // 既存のユーザーが見つかった場合
                    return FindPlayerResult(
                        success: true,
                        found: true,
                        player: player,
                        message: String(format: NSLocalizedString("Authenticated with Google account, logged in as user '%@'", comment: "GoogleAuthManager"), player.name)
                    )
                } else {
                    return FindPlayerResult(
                        success: true,
                        found: false,
                        player: nil,
                        message: NSLocalizedString("No user linked to this Google account. Please register a new user.", comment: "GoogleAuthManager")
                    )
                }
            } else {
                return FindPlayerResult(
                    success: false,
                    found: false,
                    player: nil,
                    message: NSLocalizedString("Failed to parse response", comment: "GoogleAuthManager")
                )
            }
        } catch {
            return FindPlayerResult(
                success: false,
                found: false,
                player: nil,
                message: String(format: NSLocalizedString("Error: %@", comment: "GoogleAuthManager"), error.localizedDescription)
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
                    message: NSLocalizedString("No response from server", comment: "GoogleAuthManager")
                )
            }
            
            if let response = try? JSONDecoder().decode(ConnectGoogleResponse.self, from: data) {
                if response.success {
                    return ConnectGoogleResult(
                        success: true,
                        player: response.player,
                        message: NSLocalizedString("Google account connection completed", comment: "GoogleAuthManager")
                    )
                } else {
                    let errorMessage = response.error ?? NSLocalizedString("Unknown error", comment: "GoogleAuthManager")
                    return ConnectGoogleResult(
                        success: false,
                        player: nil,
                        message: String(format: NSLocalizedString("Google account connection failed: %@", comment: "GoogleAuthManager"), errorMessage)
                    )
                }
            } else {
                return ConnectGoogleResult(
                    success: false,
                    player: nil,
                    message: NSLocalizedString("Failed to parse response", comment: "GoogleAuthManager")
                )
            }
        } catch {
            return ConnectGoogleResult(
                success: false,
                player: nil,
                message: "Error: \(error.localizedDescription)"
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
                return (false, NSLocalizedString("No response from server", comment: "GoogleAuthManager"))
            }
            
            if let response = try? JSONDecoder().decode(UnlinkResponse.self, from: data),
               response.success == true {
                return (true, response.message ?? NSLocalizedString("Google account connection removed", comment: "GoogleAuthManager"))
            } else if let errorResponse = try? JSONDecoder().decode(UnlinkErrorResponse.self, from: data) {
                return (false, errorResponse.error)
            } else {
                // デバッグのためにデータを表示
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                }
                return (false, NSLocalizedString("Failed to disconnect Google account", comment: "GoogleAuthManager"))
            }
        } catch {
            return (false, "Error: \(error.localizedDescription)")
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
