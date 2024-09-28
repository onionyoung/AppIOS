//
//  ApiClient.swift
//  App
//
//  Created by mac on 2024/9/26.
//

import Foundation

public struct ApiClient {
    static func getDataFromServer(url:URL, complete: @escaping(_ success: Bool, _ data: Data?) ->()){
        var request = URLRequest(url:url)
        request.httpMethod = "Get"
        request.setValue("text/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error{
                //handle the error
                print(error)
            } else if let data = data, let response = response as? HTTPURLResponse{
                if response.statusCode == 200{
                    complete(true, data)
                    //parse the data
                } else{
                    //handle the response code
                    print(response)
                }
            }
        }
        task.resume()
    }
}
