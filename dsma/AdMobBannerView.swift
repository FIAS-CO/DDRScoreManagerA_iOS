import SwiftUI
import GoogleMobileAds

struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-8151928728657048/4727276862"
        bannerView.rootViewController = getRootViewController()
        bannerView.load(GADRequest())
        return bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
    
    private func getRootViewController() -> UIViewController? {
        // UIWindowSceneを取得
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("Failed to get root view controller")
            return nil
        }
        return rootViewController
    }
}
