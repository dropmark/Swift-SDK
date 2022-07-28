//
//  DKPromiseRouter.swift
//  Pods
//
//  Created by Alex Givens on 6/22/21.
//

import Foundation
import PromiseKit
import Alamofire
import Combine

//@available(iOS 15, *)
//public struct DKNetwork {
//    
//    public static var jsonDecoder: JSONDecoder = {
//        let decoder = JSONDecoder()
//        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = CoreDataStack.shared.viewContext
//        decoder.dateDecodingStrategy = .formatted(Formatter.dropmark)
//        return decoder
//    }()
//    
//    public static func listItemsInCollection(id: NSNumber, parameters: Parameters) async throws -> [DKItem]  {
//        let urlRequest = DKRouter.listItemsInCollection(id: id, queryParameters: parameters).urlRequest!
//        let (data, _) = try await URLSession.shared.data(for: urlRequest)
//        return try jsonDecoder.decode([DKItem].self, from: data)
//    }
//    
//}

public struct DKPromise {
    
    // MARK: Activity
    
    public static func activity(parameters: Parameters? = nil) -> CancellablePromise<[DKItem]> {
        let request = DKRouter.activity(parameters: parameters).urlRequest!
        return genericPromise(request: request)
    }
    
    // MARK: Authentication
    
    public static func authenticate(parameters: Parameters, includeDefaultParameters: Bool = true) -> CancellablePromise<DKUser> {
        var params = parameters
        if includeDefaultParameters {
            params.add(key: "include", value: ["teams"])
        }
        let request = DKRouter.authenticate(parameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
    // MARK: Collections
    
    public static func listCollections(parameters: Parameters? = nil, includeDefaultParameters: Bool = true) -> CancellablePromise<[DKCollection]> {
        var params = parameters ?? Parameters()
        if includeDefaultParameters {
            params.add(key: "per_page", value: DKRouter.pageSize)
            params.add(key: "include", value: ["users", "items"])
            params.add(key: "items_per_page", value: 4)
            params.add(key: "items_not_type", value: "stack")
        }
        let request = DKRouter.listCollections(queryParameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func createCollection(queryParameters: Parameters? = nil, bodyParameters: Parameters, includeDefaultQueryParameters: Bool = true) -> CancellablePromise<DKCollection> {
        var queryParams = queryParameters ?? Parameters()
        if includeDefaultQueryParameters {
            queryParams.add(key: "include", value: ["users", "items"])
        }
        let request = DKRouter.createCollection(queryParameters: queryParams, bodyParameters: bodyParameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func getCollection(id: NSNumber, parameters: Parameters? = nil, includeDefaultParameters: Bool = true) -> CancellablePromise<DKCollection> {
        var params = parameters ?? Parameters()
        if includeDefaultParameters {
            params.add(key: "include", value: ["users", "items"])
            params.add(key: "items_per_page", value: 4)
            params.add(key: "items_not_type", value: "stack")
        }
        let request = DKRouter.getCollection(id: id, queryParameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func updateCollection(id: NSNumber, queryParameters: Parameters? = nil, bodyParameters: Parameters, includeDefaultQueryParameters: Bool = true) -> CancellablePromise<DKCollection> {
        var queryParams = queryParameters ?? Parameters()
        if includeDefaultQueryParameters {
            queryParams.add(key: "include", value: ["users", "items"])
            queryParams.add(key: "items_per_page", value: 4)
            queryParams.add(key: "items_not_type", value: "stack")
        }
        let request = DKRouter.updateCollection(id: id, queryParameters: queryParams, bodyParameters: bodyParameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func deleteCollection(id: NSNumber) -> CancellablePromise<Void> {
        return request(DKRouter.deleteCollection(id: id)).validate().promise()
    }
    
//    public static func getCollectionsCount() -> CancellablePromise<Int> {
//        return request(DKRouter.getCollectionsCount).validate()
//    }
    
//    public static func getItemsCountForCollection(id: NSNumber) -> CancellablePromise<Int> {
//        return request(DKRouter.getItemsCountForCollection(id: id)).validate()
//    }
    
    public static func listCollaboratorsInCollection(id: NSNumber) -> CancellablePromise<[DKUser]> {
        let request = DKRouter.listCollaboratorsInCollection(id: id).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func addCollaboratorToCollection(id: NSNumber, parameters: Parameters) -> CancellablePromise<Void> {
        return request(DKRouter.addCollaboratorToCollection(id: id, bodyParameters: parameters)).validate().promise()
    }
    
    public static func removeCollaboratorFromCollection(userID: NSNumber, collectionID: NSNumber) -> CancellablePromise<Void> {
        return request(DKRouter.removeCollaboratorFromCollection(userID: userID, collectionID: collectionID)).validate().promise()
    }
    
    // MARK: Comments
    
    public static func listCommentsForItem(itemID: NSNumber, includeDefaultParameters: Bool = true) -> CancellablePromise<[DKComment]> {
        var params = Parameters()
        if includeDefaultParameters {
            params.add(key: "per_page", value: 1000)
        }
        let request = DKRouter.listCommentsForItem(itemID: itemID, bodyParameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func createCommentForItem(itemID: NSNumber, parameters: Parameters) -> CancellablePromise<DKComment> {
        let request = DKRouter.createCommentForItem(itemID: itemID, bodyParameters: parameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func updateComment(id: NSNumber, parameters: Parameters) -> CancellablePromise<DKComment> {
        let request = DKRouter.updateComment(id: id, bodyParameters: parameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func deleteComment(id: NSNumber) -> CancellablePromise<Void> {
        return request(DKRouter.deleteComment(id: id)).validate().promise()
    }
    
    // MARK: Emails
    
//    public static func listEmails() -> CancellablePromise<String> {
//        return request(DKRouter.listEmails).validate()
//    }
    
    public static func createEmail(email: String) -> CancellablePromise<Void> {
        let bodyParameters: Parameters = [
            "email": email
        ]
        return request(DKRouter.createEmail(bodyParameters: bodyParameters)).validate().promise()
    }
    
    public static func deleteEmail(id: NSNumber) -> CancellablePromise<Void> {
        return request(DKRouter.deleteEmail(id: id)).validate().promise()
    }
    
    // MARK: Items
    
    public static func listItems(parameters: Parameters, includeDefaultParameters: Bool = true) -> CancellablePromise<[DKItem]> {
        var params = parameters
        if includeDefaultParameters {
            params.add(key: "per_page", value: DKRouter.pageSize)
            params.add(key: "include", value: ["items"])
            params.add(key: "items_per_page", value: 4)
        }
        let request = DKRouter.listItems(queryParameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func listItemsInCollection(id: NSNumber, parameters: Parameters, includeDefaultParameters: Bool = true) -> CancellablePromise<[DKItem]> {
        var params = parameters
        if includeDefaultParameters {
            params.add(key: "per_page", value: DKRouter.pageSize)
            params.add(key: "include", value: ["items"])
            params.add(key: "items_per_page", value: 4)
        }
        let request = DKRouter.listItemsInCollection(id: id, queryParameters: parameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func createItemInCollection(id: NSNumber, queryParameters: Parameters? = nil, bodyParameters: Parameters, includeDefaultQueryParameters: Bool = true) -> CancellablePromise<DKItem> {
        var queryParams = queryParameters ?? Parameters()
        if includeDefaultQueryParameters {
            queryParams.add(key: "include", value: ["items"])
            queryParams.add(key: "items_per_page", value: 4)
        }
        let request = DKRouter.createItemInCollection(id: id, queryParameters: queryParams, bodyParameters: bodyParameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func updateItemsInCollection(id: NSNumber, queryParameters: Parameters? = nil, bodyParameters: Parameters, includeDefaultQueryParameters: Bool = true) -> CancellablePromise<[DKItem]> {
        var queryParams = queryParameters ?? Parameters()
        if includeDefaultQueryParameters {
            queryParams.add(key: "include", value: ["items"])
            queryParams.add(key: "items_per_page", value: 4)
        }
        let request = DKRouter.updateItemsInCollection(id: id, queryParameters: queryParams, bodyParameters: bodyParameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func updateItems(parameters: Parameters) -> CancellablePromise<[DKItem]> {
        let request = DKRouter.updateItems(bodyParameters: parameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func getItem(id: NSNumber, parameters: Parameters? = nil, includeDefaultParameters: Bool = true) -> CancellablePromise<DKItem> {
        var params = parameters ?? Parameters()
        if includeDefaultParameters {
            params.add(key: "include", value: ["items"])
            params.add(key: "items_per_page", value: 4)
        }
        let request = DKRouter.getItem(id: id, queryParameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func updateItem(id: NSNumber, queryParameters: Parameters? = nil, bodyParameters: Parameters, includeDefaultQueryParameters: Bool = true) -> CancellablePromise<DKItem> {
        var queryParams = queryParameters ?? Parameters()
        if includeDefaultQueryParameters {
            queryParams.add(key: "include", value: ["items"])
            queryParams.add(key: "items_per_page", value: 4)
        }
        let request = DKRouter.updateItem(id: id, queryParameters: queryParams, bodyParameters: bodyParameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func deleteItem(id: NSNumber, parameters: Parameters? = nil) -> CancellablePromise<Void> {
        return request(DKRouter.deleteItem(id: id, bodyParameters: parameters)).validate().promise()
    }
    
    public static func deleteItemsInCollection(id: NSNumber, parameters: Parameters) -> CancellablePromise<Void> {
        return request(DKRouter.deleteItemsInCollection(id: id, bodyParameters: parameters)).validate().promise()
    }
    
    public static func copyItems(parameters: Parameters) -> CancellablePromise<[DKItem]> {
        let request = DKRouter.copyItems(bodyParameters: parameters).urlRequest!
        return genericPromise(request: request)
    }
    
    // MARK: Reactions
    
    public static func listReactionsForItem(id: NSNumber) -> CancellablePromise<[DKReaction]> {
        let request = DKRouter.listReactionsForItem(itemID: id).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func createReactionForItem(id: NSNumber) -> CancellablePromise<DKReaction> {
        let request = DKRouter.createReactionForItem(itemID: id).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func deleteReaction(id: NSNumber) -> CancellablePromise<Void> {
        return request(DKRouter.deleteReaction(id: id)).validate().promise()
    }
    
    // MARK: Search
    
    public static func search(parameters: Parameters, includeDefaultParameters: Bool = true) -> CancellablePromise<[Any]> {
        var params = parameters
        if includeDefaultParameters {
            params.add(key: "per_page", value: DKRouter.pageSize)
            params.add(key: "include", value: ["items"])
            params.add(key: "items_per_page", value: 4)
        }
        return request(DKRouter.search(queryParameters: params)).validate().promiseListAny()
    }
    
    // MARK: Tags
    
    public static func listTags(parameters: Parameters? = nil, includeDefaultParameters: Bool = true) -> CancellablePromise<[DKTag]> {
        var params = parameters ?? Parameters()
        if includeDefaultParameters {
            params.add(key: "per_page", value: 1000)
        }
        let request = DKRouter.listTags(bodyParameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func listTagsForItem(id: NSNumber, parameters: Parameters? = nil, includeDefaultParameters: Bool = true) -> CancellablePromise<[DKTag]> {
        var params = parameters ?? Parameters()
        if includeDefaultParameters {
            params.add(key: "per_page", value: 1000)
        }
        let request = DKRouter.listTagsForItem(itemID: id, bodyParameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func createTagForItem(id: NSNumber, name: String) -> CancellablePromise<DKTag> {
        let bodyParameters: Parameters = [
            "name": name
        ]
        let request = DKRouter.createTagForItem(itemID: id, bodyParameters: bodyParameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func deleteTag(id: NSNumber) -> CancellablePromise<Void> {
        return request(DKRouter.deleteTag(id: id)).validate().promise()
    }
    
    // MARK: Teams
    
    public static func listTeams(parameters: Parameters? = nil, includeDefaultParameters: Bool = true) -> CancellablePromise<[DKTeam]> {
        var params = parameters ?? Parameters()
        if includeDefaultParameters {
            params.add(key: "per_page", value: DKRouter.pageSize)
        }
        let request = DKRouter.listTeams(queryParameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func getTeam(id: NSNumber) -> CancellablePromise<DKTeam> {
        let request = DKRouter.getTeam(id: id).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func updateTeam(id: NSNumber, parameters: Parameters) -> CancellablePromise<DKTeam> {
        let request = DKRouter.updateTeam(id: id, bodyParameters: parameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func listUsersInTeam(id: NSNumber) -> CancellablePromise<[DKUser]> {
        let request = DKRouter.listUsersInTeam(id: id).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func createUserInTeam(id: NSNumber, parameters: Parameters) -> CancellablePromise<DKUser> {
        let request = DKRouter.createUserInTeam(id: id, bodyParameters: parameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func updateUserInTeam(teamID: NSNumber, userID: NSNumber, parameters: Parameters) -> CancellablePromise<DKUser> {
        let request = DKRouter.updateUserInTeam(teamID: teamID, userID: userID, bodyParameters: parameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func deleteUserInTeam(teamID: NSNumber, userID: NSNumber) -> CancellablePromise<Void> {
        return request(DKRouter.deleteUserInTeam(teamID: teamID, userID: userID)).validate().promise()
    }
    
    // MARK: Users
    
    public static func createUser(parameters: Parameters) -> CancellablePromise<DKUser> {
        let request = DKRouter.createUser(bodyParameters: parameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func getUser(parameters: Parameters? = nil, includeDefaultParameters: Bool = true) -> CancellablePromise<DKUser> {
        var params = parameters ?? Parameters()
        if includeDefaultParameters {
            params.add(key: "include", value: ["teams"])
        }
        let request = DKRouter.getUser(queryParameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func updateUser(queryParameters: Parameters? = nil, bodyParameters: Parameters, includeDefaultQueryParameters: Bool = true) -> CancellablePromise<DKUser> {
        var queryParams = queryParameters ?? Parameters()
        if includeDefaultQueryParameters {
            queryParams.add(key: "include", value: ["teams"])
        }
        let request = DKRouter.updateUser(queryParameters: queryParams, bodyParameters: bodyParameters).urlRequest!
        return genericPromise(request: request)
    }
    
    public static func listContacts(parameters: Parameters? = nil, includeDefaultParameters: Bool = true) -> CancellablePromise<[DKUser]> {
        var params = parameters ?? Parameters()
        if includeDefaultParameters {
            params.add(key: "per_page", value: 1000)
        }
        let request = DKRouter.listContacts(parameters: params).urlRequest!
        return genericPromise(request: request)
    }
    
//    public static func getEmailAvailability(email: String) -> CancellablePromise<Bool> {
//        return request(DKRouter.getEmailAvailability(email: email)).validate()
//    }
    
//    public static func getUsernameAvailability(username: String) -> CancellablePromise<Bool> {
//        return request(DKRouter.getUsernameAvailability(username: username)).validate()
//    }
    
    // MARK: Uploads
    
    public static func createUploadSignature(parameters: Parameters) -> CancellablePromise<DKUploadSignature> {
        
        return CancellablePromise<DKUploadSignature> ( resolver: { resolver in
            
            let signatureRequest = request(DKRouter.createUploadSignature(bodyParameters: parameters)).validate().responseData() { response in
                
                if
                    let data = response.data,
                    let signature = try? JSONDecoder().decode(DKUploadSignature.self, from: data)
                {
                    resolver.fulfill(signature)
                } else {
                    if let error = response.error {
                        resolver.reject(error)
                    } else {
                        resolver.reject(DKError.unableToSerializeJSON)
                    }
                }
                
            }
            
            return {
                signatureRequest.cancel()
            }
            
        })
        
    }
    
    // MARK: Utility
    
    public static func genericPromise<T: Decodable>(request: URLRequest) -> CancellablePromise<T> {
        
        return CancellablePromise<T> ( resolver: { resolver in
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.managedObjectContext] = CoreDataStack.shared.viewContext
                    decoder.dateDecodingStrategy = .formatted(Formatter.dropmark)
                    
                    do {
                        let objects = try decoder.decode(T.self, from: data)
                        resolver.fulfill(objects)
                    } catch {
                        resolver.reject(error)
                    }
                    
                } else if let error = error {
                    resolver.reject(error)
                } else {
                    resolver.reject(DKError.unableToSerializeJSON)
                }
                
            }

            task.resume()
            
            return {
                task.cancel()
            }
            
        })
        
    }
    
}

