//
//  ViewController.swift
//  NasTest
//
//  Created by suyong.lim on 2017. 10. 27..
//  Copyright © 2017년 suyong.lim. All rights reserved.
//

import UIKit
import Moya
import Moya_ObjectMapper
import SwiftyJSON
import ObjectMapper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loginTest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginTest() {
        var userInfo = UserInfoModel()
        userInfo.user_id = "suyong.lim@rgpkorea.co.kr"
        userInfo.password = "2"
        let provider = MoyaProvider<MyService>()
        provider.request(.login(userInfo: userInfo)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let resultString = String(data: data, encoding: .utf8)
                let statusCode = moyaResponse.statusCode
                
                if let json = JSON(moyaResponse.data).dictionary, let resultCode = json["resultCode"], resultCode == "200" {
                    if let model = try? moyaResponse.mapObject(UserInfoModel.self) {
                        print("model = \(model)")
                    }
                }
                print("success = \(resultString!), status = \(statusCode)")
            case let .failure(error):
                print("error = \(error)")
            }
            
        }
    }
}

enum MyService {
    case requestTest
    case login(userInfo: UserInfoModel)
}

extension MyService: TargetType {
    var baseURL: URL { return URL(string: "http://suyongj.synology.me/")! }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    var method: Moya.Method {
        switch self {
        case .requestTest:
            return .post
        case .login:
            return .get
        }
    }
    var path: String {
        switch self {
        case .requestTest:
            return "study/2_printjson.php"
        case .login:
            return "card/login.php"
        }
    }
    var sampleData: Data {
        switch self {
        case .requestTest:
            return "{\"programmers\":[{\"firstName\":\"Brett\",\"lastName\":\"McLaughlin\",\"email\":\"brett@newInstance.com\"},{\"firstName\":\"Jason\",\"lastName\":\"Hunter\",\"email\":\"jason@servlets.com\"}],\"authors\":[{\"firstName\":\"Isaac\",\"lastName\":\"Asimov\",\"genre\":\"science fiction\"},{\"firstName\":\"Frank\",\"lastName\":\"Peretti\",\"genre\":\"christian fiction\"}]}".utf8Encoded
        case .login:
            return "{\"resultCode\":\"500\",\"resultMessage\":\"dafsdfasdf\"}".utf8Encoded
        }
    }
    var task: Task {
        switch self {
        case .requestTest:
            return .requestPlain
        case .login(let userInfo):
            return .requestParameters(parameters: ["user_id": userInfo.user_id, "password": userInfo.password],
                                      encoding: URLEncoding.default)
        }
    }
    var validate: Bool {
        return true
    }
}

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
