//
//  DKRouter.swift
//
//  Copyright © 2020 Oak, LLC (https://oak.is)
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

/// Route network traffic across all supported API endpoints for Dropmark
public enum DKRouter: URLRequestConvertible {
    
    /// The domain and path for all endpoints on the Dropmark API. Defaults to "https://api.dropmark.com/v1", and may be modified for different API versions.
    public static var baseURLString = "https://api.dropmark.com/v1"
    
    /// The number of objects to list per page request. Defaults to 24
    public static var pageSize = 24
    
    // MARK: Activity
    
    /// Get a list of the most recently updated items across a user's teams and personal accounts. Returns a `DKItem` list.
    case activity(parameters: Parameters?)
    
    // MARK: Authentication
    
    /// Pass in an email and password, and get a user object containing the `token` necessary to authenticate requests on behalf of the user.  Returns a `DKUser` object.
    case authenticate(parameters: Parameters)
    
    // MARK: Collections
    
    /// Get a list of collections. Returns a `DKCollection` list.
    case listCollections(queryParameters: Parameters?)
    
    /// Create a collection. Returns a `DKCollection` object.
    case createCollection(queryParameters: Parameters?, bodyParameters: Parameters?)
    
    /// Get a single collection. Returns a `DKCollection` object.
    case getCollection(id: NSNumber, queryParameters: Parameters?)
    
    /// Update a single collection. Returns a `DKCollection` object.
    case updateCollection(id: NSNumber, queryParameters: Parameters?, bodyParameters: Parameters)
    
    /// Delete a single collection. Returns only a 200 response.
    case deleteCollection(id: NSNumber)
    
    /// Get the total number of collections available to the user. Returns an integer.
    case getCollectionsCount
    
    /// Get the total number of items in a collection. Returns an integer.
    case getItemsCountForCollection(id: NSNumber)
    
    /// Get a list of users with permission to access the collection. Returns a `DKUser` list.
    case listCollaboratorsInCollection(id: NSNumber)
    
    /// Give a user access to a collection (only works if the current user has permission)
    case addCollaboratorToCollection(id: NSNumber, bodyParameters: Parameters)
    
    /// Remove a user's access to a collection (only works if the current user has permission). Returns only a 200 response.
    case removeCollaboratorFromCollection(userID: NSNumber, collectionID: NSNumber)
    
    // MARK: Comments
    
    /// Get a list of comments associated with an item. Returns a `DKComment` list.
    case listCommentsForItem(itemID: NSNumber, bodyParameters: Parameters)
    
    /// Add a comment to an item. Returns a `DKComment` object.
    case createCommentForItem(itemID: NSNumber, bodyParameters: Parameters)
    
    /// Update a comment. Returns a `DKComment` object.
    case updateComment(id: NSNumber, bodyParameters: Parameters)
    
    /// Delete a comment. Returns only a 200 response.
    case deleteComment(id: NSNumber)
    
    // MARK: Emails
    
    /// Get a list of emails associated with the current user. Returns a `String` list.
    case listEmails
    
    /// Add an email for the current user
    case createEmail(bodyParameters: Parameters)
    
    /// Delete an email for the current user
    case deleteEmail(id: NSNumber)
    
    // MARK: Items
    
    /// Get a list of all items matching the query parameters. Returns a `DKItem` list.
    case listItems(queryParameters: Parameters?)
    
    /// Get a list of all child items in a collection (adding a `parent_id` will filter in a stack). Returns a `DKItem` list.
    case listItemsInCollection(id: NSNumber, queryParameters: Parameters?)
    
    /// Create a new item in a parent collection. Returns a `DKItem` object.
    case createItemInCollection(id: NSNumber, queryParameters: Parameters?, bodyParameters: Parameters)
    
    /// Update multiple items within a collection. Returns a `DKItem` list.
    case updateItemsInCollection(id: NSNumber, queryParameters: Parameters?, bodyParameters: Parameters)
    
    /// Update multiple items. Returns a `DKItem` list.
    case updateItems(bodyParameters: Parameters)
    
    /// Get a single item. Returns a `DKItem` object.
    case getItem(id: NSNumber, queryParameters: Parameters?)
    
    /// Update a single item. Returns a `DKItem` object.
    case updateItem(id: NSNumber, queryParameters: Parameters?, bodyParameters: Parameters?)
    
    /// Delete a single item. Returns only a 200 response.
    case deleteItem(id: NSNumber, bodyParameters: Parameters?)
    
    /// Delete multiple items within a parent collection. Returns only a 200 response.
    case deleteItemsInCollection(id: NSNumber, bodyParameters: Parameters)
    
    /// Duplicate an item(s) within a parent collection. Returns a `DKItem` list.
    case copyItems(bodyParameters: Parameters)
    
    // MARK: Reactions
    
    /// Get a list of reactions associated with an item. Returns a `DKReaction` list.
    case listReactionsForItem(itemID: NSNumber)
    
    /// Create a reaction for an item. Returns a `DKReaction` object.
    case createReactionForItem(itemID: NSNumber)
    
    /// Delete a reaction. Returns only a 200 response.
    case deleteReaction(id: NSNumber)
    
    // MARK: Search
    
    /// Run a search for collections, items, comments, reactions, and invites using the `q` parameter. Note: Be sure to use the `DKResponseListAny` serializer to accept varying object types. Returns a list containing 'DKCollection', 'DKItem', 'DKComment', 'DKReaction', and 'DKInvite' objects.
    case search(queryParameters: Parameters?)
    
    // MARK: Tags
    
    /// Get a list of tags associated with the current user. Returns a `DKTag` list.
    case listTags(bodyParameters: Parameters?)
    
    /// Get a list of tags applied to the specified item. Returns a `DKTag` list.
    case listTagsForItem(itemID: NSNumber, bodyParameters: Parameters?)
    
    /// Create a new tag and apply it to the specified item. Returns a `DKTag` object.
    case createTagForItem(itemID: NSNumber, bodyParameters: Parameters)
    
    /// Delete a tag. Returns only a 200 response.
    case deleteTag(id: NSNumber)
    
    // MARK: Teams
    
    /// Get a list of teams the current user belongs to. Returns a `DKTeam` list.
    case listTeams(queryParameters: Parameters?)
    
    /// Get a specified team, if visible to the current user. Returns a `DKTeam` object.
    case getTeam(id: NSNumber)
    
    /// Update a team. Returns a `DKTeam` object.
    case updateTeam(id: NSNumber, bodyParameters: Parameters)
    
    /// List all users belonging to the specified team. Returns a `DKUser` list.
    case listUsersInTeam(id: NSNumber)
    
    /// Add a user to a team. Returns a `DKUser` object.
    case createUserInTeam(id: NSNumber, bodyParameters: Parameters)
    
    /// Update a user within a team. Returns a `DKUser` object.
    case updateUserInTeam(teamID: NSNumber, userID: NSNumber, bodyParameters: Parameters)
    
    /// Remove a user from a team. Returns only a 200 response.
    case deleteUserInTeam(teamID: NSNumber, userID: NSNumber)
    
    // MARK: Users
    
    /// Create a user (aka register a new account). Returns a `DKUser` object.
    case createUser(bodyParameters: Parameters)
    
    /// Get the user object for the current user. NOTE: The user object returned by this endpoint will not contain a 'token' for authentication. Returns a `DKUser` object.
    case getUser(queryParameters: Parameters?)
    
    /// Update information for the current user. Returns a `DKUser` object.
    case updateUser(queryParameters: Parameters?, bodyParameters: Parameters)
    
    /// Delete the current User. NOTE: All collections and teams must be deleted prior to running this action.
    case deleteUser
    
    /// Get a list of users associated with the current user
    case listContacts(parameters: Parameters?)
    
    /// Check if an email is available for registration. Returns a `Bool` value.
    case getEmailAvailability(email: String)
    
    /// Check if a username is available for registration. Returns a `Bool` value.
    case getUsernameAvailability(username: String)
    
    // MARK: Uploads
    
    /// Use this endpoint to get an upload signature for direct uploads to Amazon S3
    case createUploadSignature(bodyParameters: Parameters)
    
    
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
        case .deleteUser:
            return .delete
            
        case .listContacts:
            return .get
        case .getEmailAvailability:
            return .get
        case .getUsernameAvailability:
            return .get
            
        // Uploads
        case .createUploadSignature:
            return .post
            
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
        case .getCollection(let id, _):
            return "/collections/\(id)"
        case .updateCollection(let id, _, _):
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
        case .listCommentsForItem(let itemID, _):
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
        case .createItemInCollection(let collectionID, _, _):
            return "/collections/\(collectionID)/items"
        case .updateItemsInCollection(let collectionID, _, _):
            return "/collections/\(collectionID)/items"
        case .updateItems:
            return "/items"
        case .getItem(let id, _):
            return "/items/\(id)"
        case .updateItem(let id, _, _):
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
        case .listTagsForItem(let itemID, _):
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
        case .updateTeam(let id, _):
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
        case .deleteUser:
            return "/users/me"
            
        case .listContacts:
            return "/users/contacts"
        case .getEmailAvailability:
            return "/users/email"
        case .getUsernameAvailability:
            return "/users/username"
            
        // Uploads
        case .createUploadSignature:
            return "/uploads"
            
        }
    }
    
    
    // MARK: URLRequestConvertible
    
    /**

    Returns a URL request or throws if an `Error` was encountered.

        - Throws: An `Error` if the underlying `URLRequest` is `nil`.
        - Returns: A URL request.

    */
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try DKRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        try DKRouter.authenticateAPIRequest(&urlRequest)

        switch self {
            
        case .authenticate, .createUser:
            break
            
        default:
            try DKRouter.authorizeUserRequest(&urlRequest)
            
        }
        
        switch self {
        
        // Activity
        case .activity(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        // Authentication
        case .authenticate(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        // Collections
        case .listCollections(let queryParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        case .createCollection(let queryParameters, let bodyParameters):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParameters)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .getCollection(_, let queryParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        case .updateCollection(_, let queryParameters, let bodyParameters):
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
        case .listCommentsForItem(_, let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .createCommentForItem(_, let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .updateComment(_, let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .deleteComment:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Emails
        case .listEmails:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .createEmail(let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .deleteEmail:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Items
        case .listItems(let queryParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        case .listItemsInCollection(_ , let queryParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        case .createItemInCollection(_ , let queryParameters, let bodyParameters):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParameters)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .updateItemsInCollection(_ , let queryParameters, let bodyParameters):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParameters)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .updateItems(let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .getItem(_, let queryParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        case .updateItem(_, let queryParameters, let bodyParameters):
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
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
            
        // Tags
        case .listTags(let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .listTagsForItem(_, let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .createTagForItem(_, let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .deleteTag:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Teams
        case .listTeams(let queryParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
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
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        case .updateUser(let queryParameters, let bodyParameters):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParameters)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
        case .deleteUser:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        case .listContacts(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
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
            
        // Uploads
        case .createUploadSignature(let bodyParameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: bodyParameters)
            
        }
        
        return urlRequest
    }
    
    // MARK: Authentication
    
    /**
     
     To access API resources, an API token is required in the header of all requests. To authenticate with this function, first set the `DKRouter.apiToken` variable. Then pass a reference to a request through.
     
     - Parameters:
        - urlRequest: A reference to a `URLRequest`
     
     - Throws: Returns an error if no API token is found
     
     */
    
    public static func authenticateAPIRequest(_ urlRequest: inout URLRequest) throws {
        
        guard let apiToken = DKSession.apiToken else {
            throw DKError.missingAPIToken
        }
        
        urlRequest.setValue(apiToken, forHTTPHeaderField: "X-API-Key")
        
    }
    
    /**
     
     To authorize requests on behalf of a user, the user's private token must be encoded and supplied in the `Authorization` header. To authorize a user's request for the duration of the app session, set an authenticated user to `DKRouter.user`.
     
     - Parameters:
        - urlRequest: A reference to a `URLRequest`
     
     - Throws: Returns errors if no user or user token are found
     
     */
    
    public static func authorizeUserRequest(_ urlRequest: inout URLRequest) throws {
        
        guard let user = DKSession.user else {
            print("DKSession user object was not set. Be sure to assign a user to access credentialed API endpoints.")
            throw DKError.missingUser
        }
        
        guard let userToken = user.token else {
            print("DKSession user object does not contain a token. Remember - only the user object returned from the /auth endpoint contains a token.")
            throw DKError.missingUserToken
        }
        
        let plainString = "\(user.id):\(userToken)" as NSString
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        urlRequest.setValue("Basic \(base64String!)", forHTTPHeaderField: "Authorization")
        
    }
    
}
