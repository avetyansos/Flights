//
//  APIAPIClient.swift
//  RyanAirTestApplication
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

struct HTTPHeader {
    let field: String
    let value: String
}

extension HTTPHeader {
    static var contentType: HTTPHeader {
        return HTTPHeader(field: "Content-Type", value: "application/json")
    }
    
    static var appAuth: HTTPHeader? {
        return nil
    }
}

class APIRequest {
    let method: HTTPMethod
    let path: String
    let baseUrl: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    var specialEncodingCharacterSet: CharacterSet?
    
    init(method: HTTPMethod, path: String, baseUrl: String) {
        self.method = method
        self.path = path
        self.baseUrl = baseUrl
    }
    
    init<Body: Encodable>(method: HTTPMethod, path: String, baseUrl: String, body: Body) throws {
        self.method = method
        self.path = path
        self.baseUrl = baseUrl
        self.body = try JSONEncoder().encode(body)
    }
}

struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
    let cookies: [HTTPCookie]
    
    init(statusCode: Int, body: Body, cookies: [HTTPCookie] = []) {
        self.statusCode = statusCode
        self.body = body
        self.cookies = cookies
    }
}

extension APIResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> APIResponse<BodyType> {
        guard let data = body else {
            throw APIError.decodingFailure
        }
        let decodedJSON = try JSONDecoder().decode(BodyType.self, from: data)
        return APIResponse<BodyType>(statusCode: self.statusCode,
                                     body: decodedJSON)
    }
}

struct FailureResponse<Body> {
    let statusCode: Int?
    let body: APIError
}

struct APIErrorResponse: Decodable {
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case message = "Message"
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case badRequest
    case decodingFailure
    case passforFailure
    case noInternet
    case badResponse
    case withDrawError(errorString: String)
    case addBankAccountError(errorString: String)
    case deleteAccountError(errorString: String)
    case deleteBankError(errorString: String)
    case getProviderError(errorString: String)
    case depositError(errorString: String)
    case generalErrorWithString(errorString: String)
    case errorWithString(date: Data)
    case errorWithInfo(info: APIErrorResponse)
    case KYCUnverified
}

enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(FailureResponse<Body>)
}

struct APIClient {
    
    typealias APIClientCompletion = (APIResult<Data?>) -> Void
    
    private let session: URLSession
    
    init() {
        session = URLSession.shared
        session.configuration.httpCookieAcceptPolicy = .always
    }
    
    func get(_ path: String, _ completion: @escaping APIClientCompletion) {
        
    }
    
    func perform(_ request: APIRequest, _ completion: @escaping APIClientCompletion) {
        let baseURL = URL(string: request.baseUrl)!
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        if let characterSet = request.specialEncodingCharacterSet {
            urlComponents.percentEncodedQuery = request.queryItems?.map { item in
                let encodedValue = item.value?.addingPercentEncoding(withAllowedCharacters: characterSet) ?? ""
                let separator = encodedValue.isEmpty ? "" : "="
                return item.name + separator + encodedValue
            }.joined(separator: "&")
        }

        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .invalidURL))); return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        self.makeUserInteractionInabled(false)
        let postTask = session.dataTask(with: urlRequest) { (data, response, error) in
            self.makeUserInteractionInabled(true)
            if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .noInternet)))
            } else if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorBadServerResponse {
                completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .badResponse)))
            } else {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(FailureResponse<Data?>(statusCode: nil, body: .requestFailed))); return
                }
                guard httpResponse.statusCode == 200 else {
                    if httpResponse.statusCode == 401 {
                        completion(.failure(FailureResponse<Data?>(statusCode:httpResponse.statusCode, body : .errorWithInfo(info : APIErrorResponse(message: "Invalid Authentication")))))
                    } else if httpResponse.statusCode == 400 {
                        if let uData = data, let errorInfo = try? JSONDecoder().decode(APIErrorResponse.self, from: uData) {
                            completion(.failure(FailureResponse<Data?>(statusCode: httpResponse.statusCode, body: .errorWithInfo(info: errorInfo))))
                        } else {
                            completion(.failure(FailureResponse<Data?>(statusCode: httpResponse.statusCode, body: .errorWithString(date: data!))))
                        }
                        
                    } else {
                        completion(.failure(FailureResponse<Data?>(statusCode: httpResponse.statusCode, body: .requestFailed)))
                    }
                    return
                }
                var cookies = [HTTPCookie]()
                if let headers = httpResponse.allHeaderFields as? [String: String], let url = httpResponse.url {
                    cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                    
                    if let dateValue = headers["Date"],
                        let dateCookie = HTTPCookie(properties: [.originURL: url, .path: "/", .name: "Date", .value: dateValue]) {
                        cookies.append(dateCookie)
                    }
                }
                
                
                completion(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data, cookies: cookies)))
            }
        }
        postTask.resume()
    }
    
    func makeUserInteractionInabled(_ needToEnable : Bool) {
        DispatchQueue.main.async {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }

                topController.view.isUserInteractionEnabled = needToEnable
            }
        }
    }
}



