//
//  DKUploadSignature.swift
//  Pods
//
//  Created by Alex Givens on 6/22/21.
//

import Foundation

public struct DKUploadSignature: Codable {

    public let id: Int
    public let url: String
    public let parameters: Parameters

    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case parameters = "params"
    }
    
    public struct Parameters: Codable {
        
        public let policy: String
        public let contentType: String
        public let signature: String
        public let acl: String
        public let awsAccessKeyID: String
        public let key: String
        public let successActionStatus: Int
        
        private enum CodingKeys: String, CodingKey {
            case policy
            case contentType = "Content-Type"
            case signature
            case acl
            case awsAccessKeyID = "AWSAccessKeyId"
            case key
            case successActionStatus = "success_action_status"
        }
        
    }
    
}
