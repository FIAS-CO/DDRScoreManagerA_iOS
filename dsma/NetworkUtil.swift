//
//  NetworkUtil.swift
//  dsma
//
//  Created by LinaNfinE on 2022/10/25.
//  Copyright © 2022 LinaNfinE. All rights reserved.
//

import Foundation

struct NetworkUtil{

    static func sessionSyncRequestGET(_ targetUrl: String) -> Data? {
        /// セマフォ
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        var ret: Data!

        // Httpリクエストの生成
        var request = URLRequest(url: URL(string: targetUrl)!)
        request.httpMethod = "GET"

        // HTTPリクエスト実行
        URLSession.shared.dataTask(with: request, completionHandler: {(data ,response, error)->Void in
            if let error = error {
                ret = nil
                print(error)
            }
            else{
                ret = data
            }
            semaphore.signal()
        }).resume()

        // requestCompleteHandler内でsemaphore.signal()が呼び出されるまで待機する
        semaphore.wait()
        print("request completed")
    
        return ret
        
    }

    static func sessionSyncRequestPOST(_ targetUrl: String, postQuery: String) -> Data? {
        /// セマフォ
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        var ret: Data!

        // Httpリクエストの生成
        var request = URLRequest(url: URL(string: targetUrl)!)
        request.httpMethod = "POST"
        request.httpBody = postQuery.data(using: String.Encoding.utf8, allowLossyConversion: true)

        // HTTPリクエスト実行
        URLSession.shared.dataTask(with: request, completionHandler: {(data ,response, error)->Void in
            if let error = error {
                ret = nil
                print(error)
            }
            else{
                ret = data
            }
            semaphore.signal()
        }).resume()

        // requestCompleteHandler内でsemaphore.signal()が呼び出されるまで待機する
        semaphore.wait()
        print("request completed")
    
        return ret
        
    }

}
