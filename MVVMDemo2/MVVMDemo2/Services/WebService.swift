//
//  WebService.swift
//  MVVMDemo2
//
//  Created by M1092828 on 05/08/22.
//

import Foundation

enum NetworkError:Error{
    case decodingError
    case domainError
    case urlError
}

enum HTTPMethod:String{
    case post
    case get
}

struct Resource<T:Codable>{
    let url:URL
    var httpMethod:HTTPMethod = .get
    var body:Data? = nil
    init(url:URL)
    {
        self.url=url 
    }
    
}
class WebService:NSObject{
    func load<T>(resource:Resource<T>, completion:@escaping (Result<T,NetworkError>)-> Void){
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.domainError))
                return
            }
            let result = try? JSONDecoder().decode(T.self,from:data)
            if let result = result {
                DispatchQueue.main.async{
                    completion(.success(result))
                }
            }
            else{
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

extension WebService:URLSessionDelegate
{
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
   {
           guard let serverTrust = challenge.protectionSpace.serverTrust else {
               return completionHandler(URLSession.AuthChallengeDisposition.useCredential, nil)
           }
           return completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
   }
}
