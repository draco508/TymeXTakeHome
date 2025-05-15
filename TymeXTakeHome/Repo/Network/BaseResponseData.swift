//
//  BaseApiData.swift
//
//  Created by Draco Nguyen on 07/11/2023.
//
//

class BaseResponseData<D: Codable>: Codable {
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case data
        
    }
    
    var code: Int?
    
    var message: String?
    
    var data: [D]?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decodeIfPresent(Int.self, forKey: .code)
        data = try container.decodeIfPresent([D].self, forKey: .data)
        message = try container.decode(String.self, forKey: .message)
    
    }
    
    func isSuccess() -> Bool {
        return 200 == code
    }
    
}
