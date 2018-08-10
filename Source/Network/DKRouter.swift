//
//  DKRouter.swift
//
//  Copyright © 2018 Oak, LLC (https://oak.is)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import Alamofire

public enum DKRouter: URLRequestConvertible {
    
    public static let baseURLString = "https://api.dropmark.com/v1"
    
    public static var apiToken: String {
        let token = Bundle.keyForID("DropmarkAPIToken")
        assert(token != nil, "Dropmark API token was not loaded from keys.plist")
        return token!
    }
    
    public static var user: DKUser?
    
    public static var pageSize = 24
    
    // Activity
    case activity(parameters: Parameters?)
    
    // Authentication
    case authenticate(parameters: Parameters?)
    
    // Collections
    case listCollections(queryParameters: Parameters?)
    case createCollection(bodyParameters: Parameters?)
    case getCollection(id: NSNumber)
    case updateCollection(id: NSNumber, bodyParameters: Parameters?)
    case deleteCollection(id: NSNumber)
    
    case getCollectionsCount
    case getItemsCountForCollection(id: NSNumber)
    
    case listCollaboratorsInCollection(id: NSNumber)
    case addCollaboratorToCollection(id: NSNumber, bodyParameters: Parameters?)
    case removeCollaboratorFromCollection(userID: NSNumber, collectionID: NSNumber)
    
    // Comments
    case listCommentsForItem(itemID: NSNumber)
    case createCommentForItem(itemID: NSNumber, bodyParameters: Parameters?)
    case updateComment(id: NSNumber, bodyParameters: Parameters?)
    case deleteComment(id: NSNumber)
    
    // Emails
    case listEmails
    case createEmail(email: String)
    case deleteEmail(id: NSNumber)
    
    // Items
    case listItems(queryParameters: Parameters?)
    case listItemsInCollection(id: NSNumber, queryParameters: Parameters?)
    case createItemInCollection(id: NSNumber, bodyParameters: Parameters?)
    case updateItemsInCollection(id: NSNumber, bodyParameters: Parameters?)
    case updateItems(bodyParameters: Parameters?)
    case getItem(id: NSNumber, queryParameters: Parameters?)
    case updateItem(id: NSNumber, bodyParameters: Parameters?)
    case deleteItem(id: NSNumber, bodyParameters: Parameters?)
    case deleteItemsInCollection(id: NSNumber, bodyParameters: Parameters?)
    case copyItems(bodyParameters: Parameters?)
    
    // Reactions
    case listReactionsForItem(itemID: NSNumber)
    case createReactionForItem(itemID: NSNumber)
    case deleteReaction(id: NSNumber)
    
    // Search
    case search(queryParameters: Parameters?)
    
    // Tags
    case listTags
    case listTagsForItem(itemID: NSNumber)
    case createTagForItem(itemID: NSNumber, name: String)
    case deleteTag(id: NSNumber)
    
    // Teams
    case listTeams(queryParameters: Parameters?)
    case getTeam(id: NSNumber)
    case updateTeam(teamid: NSNumber, bodyParameters: Parameters?)
    
    case listUsersInTeam(teamID: NSNumber)
    case createUserInTeam(teamID: NSNumber, bodyParameters: Parameters?)
    case updateUserInTeam(teamID: NSNumber, userID: NSNumber, bodyParameters: Parameters?)
    case deleteUserInTeam(teamID: NSNumber, userID: NSNumber)
    
    // Users
    case createUser(bodyParameters: Parameters)
    case getUser(queryParameters: Parameters?)
    case updateUser(bodyParameters: Parameters?)
    
    case listContacts
    case getEmailAvailability(email: String)
    case getUsernameAvailability(username: String)
    
    
    var method: HTTPMethod {
        switch self {
        
        // Activity
        case .activity:
            return .get
            
        // Authentication
        case .authenticate:
            return .post
            
        // Collections
        case .listCollections:
            return .get
        case .createCollection:
            return .post
        case .getCollection:
            return .get
        case .updateCollection:
            return .put
        case .deleteCollection:
            return .delete
            
        case .getCollectionsCount:
            return .get
        case .getItemsCountForCollection:
            return .get
            
        case .listCollaboratorsInCollection:
            return .get
        case .addCollaboratorToCollection:
            return .post
        case .removeCollaboratorFromCollection:
            return .delete
            
        // Comments
        case .listCommentsForItem:
            return .get
        case .createCommentForItem:
            return .post
        case .updateComment:
            return .put
        case .deleteComment:
            return .delete
            
        // Emails
        case .listEmails:
            return .get
        case .createEmail:
            return .post
        case .deleteEmail:
            return .delete
            
        // Items
        case .listItems:
            return .get
        case .listItemsInCollection:
            return .get
        case .createItemInCollection:
            return .post
        case .updateItemsInCollection:
            return .put
        case .updateItems:
            return .put
        case .getItem:
            return .get
        case .updateItem:
            return .put
        case .deleteItem:
            return .delete
        case .deleteItemsInCollection:
            return .delete
        case .copyItems:
            return .post
            
        // Reactions
        case .listReactionsForItem:
            return .get
        case .createReactionForItem:
            return .post
        case .deleteReaction:
            return .delete
            
        // Search
        case .search:
            return .get
            
        // Tags
        case .listTags:
            return .get
        case .listTagsForItem:
            return .get
        case .createTagForItem:
            return .post
        case .deleteTag:
            return .delete
            
        // Teams
        case .listTeams:
            return .get
        case .getTeam:
            return .get
        case .updateTeam:
            return .put
            
        case .listUsersInTeam:
            return .get
        case .createUserInTeam:
            return .post
        case .updateUserInTeam:
            return .put
        case .deleteUserInTeam:
            return .delete
            
        // Users
        case .createUser:
            return .post
        case .getUser:
            return .get
        case .updateUser:
            return .put
            
        case .listContacts:
            return .get
        case .getEmailAvailability:
            return .get
        case .getUsernameAvailability:
            return .get
            
        }
    }
    
    var path: String {
        switch self {
            
        // Activity
        case .activity:
            return "/activity"
            
        // Authentication
        case .authenticate:
            return "/auth"
            
        // Collections
        case .listCollections:
            return "/collections"
        case .createCollection:
            return "/collections"
        case .getCollection(let id):
            return "/collections/\(id)"
        case .updateCollection(let id, _):
            return "/collections/\(id)"
        case .deleteCollection(let id):
            return "/collections/\(id)"
            
        case .getCollectionsCount:
            return "/collections/count"
        case .getItemsCountForCollection(let collectionID):
            return "/collections/\(collectionID)/count"
            
        case .listCollaboratorsInCollection(let id):
            return "collections/\(id)/users"
        case .addCollaboratorToCollection(let id, _):
            return "collections/\(id)/users"
        case .removeCollaboratorFromCollection(let userID, let collectionID):
            return "/collections/\(collectionID)/users/\(userID)"
            
        // Comments
        case .listCommentsForItem(let itemID):
            return "/items/\(itemID)/comments"
        case .createCommentForItem(let itemID, _):
            return "/items/\(itemID)/comments"
        case .updateComment(let id, _):
            return "/comments/\(id)"
        case .deleteComment(let id):
            return "/comments/\(id)"
            
        // Emails
        case .listEmails:
            return "/emails"
        case .createEmail:
            return "/emails"
        case .deleteEmail(let id):
            return "/emails/\(id)"
            
        // Items
        case .listItems:
            return "/items"
        case .listItemsInCollection(let collectionID, _):
            return "/collections/\(collectionID)/items"
        case .createItemInCollection(let collectionID, _):
            return "/collections/\(collectionID)/items"
        case .updateItemsInCollection(let collectionID, _):
            return "/collections/\(collectionID)/items"
        case .updateItems:
            return "/items"
        case .getItem(let id, _):
            return "/items/\(id)"
        case .updateItem(let id, _):
            return "/items/\(id)"
        case .deleteItem(let id, _):
            return "/items/\(id)"
        case .deleteItemsInCollection(let collectionID, _):
            return "/collections/\(collectionID)/items"
        case .copyItems:
            return "/items/copy"
            
        // Reactions
        case .listReactionsForItem(let itemID):
            return "/items/\(itemID)/reactions"
        case .createReactionForItem(let itemID):
            return "/items/\(itemID)/reactions"
        case .deleteReaction(let id):
            return "/reactions/\(id)"
            
        // Search
        case .search:
            return "/search"
            
        // Tags
        case .listTags:
            return "/tags"
        case .listTagsForItem(let itemID):
            return "/items/\(itemID)/tags"
        case .createTagForItem(let itemID, _):
            return "/items/\(itemID)"
        case .deleteTag(let id):
            return "/tags/\(id)"
            
        // Teams
        case .listTeams:
            return "/teams"
        case .getTeam(let id):
            return "/teams/\(id)"
        case .updateTeam(let id):
            return "/teams/\(id)"
            
        case .listUsersInTeam(let teamID):
            return "/teams/\(teamID)/users"
        case .createUserInTeam(let teamID, _):
            return "/teams/\(teamID)/users"
        case .updateUserInTeam(let teamID, let userID, _):
            return "/teams/\(teamID)/users/\(userID)"
        case .deleteUserInTeam(let teamID, let userID):
            return "/teams/\(teamID)/users/\(userID)"
            
        // Users
        case .createUser:
            return "/users/signup"
        case .getUser:
            return "/users/me"
        case .updateUser:
            return "/users/me"
            
        case .listContacts:
            return "/users/contacts"
        case .getEmailAvailability:
            return "/users/email"
        case .getUsernameAvailability:
            return "/users/username"
            
        }
    }
    
    
    // MARK: URLRequestConvertible
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try DKRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
            
        case .authenticate, .createUser:
            DKRouter.authenticateDropmarkRequest(&urlRequest)
            
        default:
            DKRouter.authenticateDropmarkRequest(&urlRequest)
            try DKRouter.credentialRequest(&urlRequest, with: DKRouter.user)
            
        }
        
        switch self {
            
        // Activity
        case .activity(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        // Authentication
        case .authenticate(let parameters):
            var params = parameters ?? Parameters()
            params.addUserParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            
        // Collections
        case .listCollections(let queryParameters):
            var queryParams = queryParameters ?? Parameters()
            queryParams.addListParams()
            queryParams.addCollectionParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParams)
        case .createCollection(let bodyParameters):
            let queryParameters = Parameters.collectionParams()
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParameters)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .getCollection:
            let queryParameters = Parameters.collectionParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        case .updateCollection(_, let bodyParameters):
            let queryParameters = Parameters.collectionParams()
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParameters)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .deleteCollection:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        case .getCollectionsCount:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .getItemsCountForCollection:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        case .listCollaboratorsInCollection:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .addCollaboratorToCollection(_, let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .removeCollaboratorFromCollection:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Comments
        case .listCommentsForItem:
            let queryParameters = Parameters.listParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        case .createCommentForItem(_, let bodyParamaters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParamaters)
        case .updateComment(_, let bodyParamaters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParamaters)
        case .deleteComment:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Emails
        case .listEmails:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .createEmail(let email):
            let bodyParameters: Parameters = [
                "email": email
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .deleteEmail:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Items
        case .listItems(let queryParameters):
            var queryParams = queryParameters ?? Parameters()
            queryParams.addListParams()
            queryParams.addItemParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParams)
        case .listItemsInCollection(_ , let queryParameters):
            var queryParams = queryParameters ?? Parameters()
            queryParams.addListParams()
            queryParams.addItemParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParams)
        case .createItemInCollection(_ , let bodyParameters):
            let queryParameters = Parameters.itemParams()
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParameters)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .updateItemsInCollection(_ , let bodyParameters):
            let queryParameters = Parameters.itemParams()
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParameters)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .updateItems(let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .getItem(_, let queryParameters):
            var queryParams = queryParameters ?? Parameters()
            queryParams.addItemParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParams)
        case .updateItem(_, let bodyParameters):
            let queryParameters = Parameters.itemParams()
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParameters)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .deleteItem(_, let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .deleteItemsInCollection(_ , let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .copyItems(let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
            
        // Reactions
        case .listReactionsForItem:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .createReactionForItem:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .deleteReaction:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Search
        case .search(let queryParameters):
            var queryParams = queryParameters ?? Parameters()
            queryParams.addListParams()
            queryParams.addItemParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParams)
            
        // Tags
        case .listTags:
            let queryParamters: Parameters = [
                "per_page": DKRouter.pageSize
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParamters)
        case .listTagsForItem:
            let queryParamters: Parameters = [
                "per_page": DKRouter.pageSize
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParamters)
        case .createTagForItem(_, let name):
            let bodyParameters: Parameters = [
                "name": name
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .deleteTag:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Teams
        case .listTeams(let queryParameters):
            var queryParams = queryParameters ?? Parameters()
            queryParams.addListParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParams)
        case .getTeam:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .updateTeam(_, let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
            
        case .listUsersInTeam:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .createUserInTeam(_, let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .updateUserInTeam(_, _, let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .deleteUserInTeam:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Users
        case .createUser(let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .getUser(let queryParameters):
            var queryParams = queryParameters ?? Parameters()
            queryParams.addUserParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParams)
        case .updateUser(let bodyParameters):
            let queryParameters = Parameters.userParams()
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParameters)
            
        case .listContacts:
            let queryParameters: Parameters = [
                "per_page": 1000
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        case .getEmailAvailability(let email):
            let queryParameters: Parameters = [
                "email": email
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        case .getUsernameAvailability(let username):
            let queryParameters: Parameters = [
                "username": username
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
            
        }
        
        return urlRequest
    }
    
    // MARK: Authentication Utlity
    
    /**
     
     Pass in a URL Request to add token authentication
     
     */
    
    public static func authenticateDropmarkRequest(_ urlRequest: inout URLRequest) {
        urlRequest.setValue("\(DKRouter.apiToken)", forHTTPHeaderField: "X-API-Key")
    }
    
    /**
     
     Pass in a URL Request and user to credential the request.
     
     */
    
    public static func credentialRequest(_ urlRequest: inout URLRequest, with user: DKUser?) throws {
        
        guard let user = user else {
            throw DKRouterError.missingUser
        }
        
        guard let userToken = user.token else {
            throw DKRouterError.missingUserToken
        }
        
        let plainString = "\(user.id!):\(userToken)" as NSString
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        urlRequest.setValue("Basic \(base64String!)", forHTTPHeaderField: "Authorization")
        
    }
    
}

extension Dictionary {
    
    static func listParams() -> Parameters {
        var dictionary = Parameters()
        dictionary.addListParams()
        return dictionary
    }
    
    static func collectionParams() -> Parameters {
        var dictionary = Parameters()
        dictionary.addCollectionParams()
        return dictionary
    }
    
    static func itemParams() -> Parameters {
        var dictionary = Parameters()
        dictionary.addItemParams()
        return dictionary
    }
    
    static func userParams() -> Parameters {
        var dictionary = Parameters()
        dictionary.addUserParams()
        return dictionary
    }
    
    mutating func addListParams() {
        self.add(key: "per_page", value: DKRouter.pageSize)
    }
    
    mutating func addCollectionParams() {
        self.add(key: "include", value: ["users", "items"])
        self.add(key: "items_per_page", value: 4)
        self.add(key: "items_not_type", value: "stack")
    }
    
    mutating func addItemParams() {
        self.add(key: "include", value: ["items"])
        self.add(key: "items_per_page", value: 4)
    }
    
    mutating func addUserParams() {
        self.add(key: "include", value: ["teams"])
    }
    
    mutating func add(key: String, value: Any) {
        if
            let uKey = key as? Key,
            let uValue = value as? Value,
            self[uKey] == nil
        {
            self[uKey] = uValue
        }
    }
    
}
