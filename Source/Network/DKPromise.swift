//
//  DKPromiseRouter.swift
//  Pods
//
//  Created by Alex Givens on 6/22/21.
//

import Foundation
import PromiseKit
import Alamofire

public struct DKPromise {
    
    // MARK: Activity
    
    public static func activity(parameters: Parameters? = nil) -> CancellablePromise<[DKItem]> {
        return AF.request(DKRouter.activity(parameters: parameters)).validate().promiseList()
    }
    
    // MARK: Authentication
    
    public static func authenticate(parameters: Parameters) -> CancellablePromise<DKUser> {
        return AF.request(DKRouter.authenticate(parameters: parameters)).validate().promiseObject()
    }
    
    // MARK: Collections
    
    public static func listCollections(parameters: Parameters? = nil) -> CancellablePromise<[DKCollection]> {
        return AF.request(DKRouter.listCollections(queryParameters: parameters)).validate().promiseList()
    }
    
    public static func createCollection(parameters: Parameters? = nil) -> CancellablePromise<DKCollection> {
        return AF.request(DKRouter.createCollection(bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func getCollection(id: NSNumber) -> CancellablePromise<DKCollection> {
        return AF.request(DKRouter.getCollection(id: id)).validate().promiseObject()
    }
    
    public static func updateCollection(id: NSNumber, parameters: Parameters) -> CancellablePromise<DKCollection> {
        return AF.request(DKRouter.updateCollection(id: id, bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func deleteCollection(id: NSNumber) -> CancellablePromise<Void> {
        return AF.request(DKRouter.deleteCollection(id: id)).validate().promise()
    }
    
//    public static func getCollectionsCount() -> CancellablePromise<Int> {
//        return AF.request(DKRouter.getCollectionsCount).validate()
//    }
    
//    public static func getItemsCountForCollection(id: NSNumber) -> CancellablePromise<Int> {
//        return AF.request(DKRouter.getItemsCountForCollection(id: id)).validate()
//    }
    
    public static func listCollaboratorsInCollection(id: NSNumber) -> CancellablePromise<[DKUser]> {
        return AF.request(DKRouter.listCollaboratorsInCollection(id: id)).validate().promiseList()
    }
    
    public static func addCollaboratorToCollection(id: NSNumber, parameters: Parameters) -> CancellablePromise<Void> {
        return AF.request(DKRouter.addCollaboratorToCollection(id: id, bodyParameters: parameters)).validate().promise()
    }
    
    public static func removeCollaboratorFromCollection(userID: NSNumber, collectionID: NSNumber) -> CancellablePromise<Void> {
        return AF.request(DKRouter.removeCollaboratorFromCollection(userID: userID, collectionID: collectionID)).validate().promise()
    }
    
    // MARK: Comments
    
    public static func listCommentsForItem(itemID: NSNumber) -> CancellablePromise<[DKComment]> {
        return AF.request(DKRouter.listCommentsForItem(itemID: itemID)).validate().promiseList()
    }
    
    public static func createCommentForItem(itemID: NSNumber, parameters: Parameters) -> CancellablePromise<DKComment> {
        return AF.request(DKRouter.createCommentForItem(itemID: itemID, bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func updateComment(id: NSNumber, parameters: Parameters) -> CancellablePromise<DKComment> {
        return AF.request(DKRouter.updateComment(id: id, bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func deleteComment(id: NSNumber) -> CancellablePromise<Void> {
        return AF.request(DKRouter.deleteComment(id: id)).validate().promise()
    }
    
    // MARK: Emails
    
//    public static func listEmails() -> CancellablePromise<String> {
//        return AF.request(DKRouter.listEmails).validate()
//    }
    
    public static func createEmail(email: String) -> CancellablePromise<Void> {
        return AF.request(DKRouter.createEmail(email: email)).validate().promise()
    }
    
    public static func deleteEmail(id: NSNumber) -> CancellablePromise<Void> {
        return AF.request(DKRouter.deleteEmail(id: id)).validate().promise()
    }
    
    // MARK: Items
    
    public static func listItems(parameters: Parameters) -> CancellablePromise<[DKItem]> {
        return AF.request(DKRouter.listItems(queryParameters: parameters)).validate().promiseList()
    }
    
    public static func listItemsInCollection(id: NSNumber, parameters: Parameters) -> CancellablePromise<[DKItem]> {
        return AF.request(DKRouter.listItemsInCollection(id: id, queryParameters: parameters)).validate().promiseList()
    }
    
    public static func createItemInCollection(id: NSNumber, parameters: Parameters) -> CancellablePromise<DKItem> {
        return AF.request(DKRouter.createItemInCollection(id: id, bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func updateItemsInCollection(id: NSNumber, parameters: Parameters) -> CancellablePromise<[DKItem]> {
        return AF.request(DKRouter.updateItemsInCollection(id: id, bodyParameters: parameters)).validate().promiseList()
    }
    
    public static func updateItems(parameters: Parameters) -> CancellablePromise<[DKItem]> {
        return AF.request(DKRouter.updateItems(bodyParameters: parameters)).validate().promiseList()
    }
    
    public static func getItem(id: NSNumber, parameters: Parameters? = nil) -> CancellablePromise<DKItem> {
        return AF.request(DKRouter.getItem(id: id, queryParameters: parameters)).validate().promiseObject()
    }
    
    public static func updateItem(id: NSNumber, parameters: Parameters) -> CancellablePromise<DKItem> {
        return AF.request(DKRouter.updateItem(id: id, bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func deleteItem(id: NSNumber, parameters: Parameters? = nil) -> CancellablePromise<Void> {
        return AF.request(DKRouter.deleteItem(id: id, bodyParameters: parameters)).validate().promise()
    }
    
    public static func deleteItemsInCollection(id: NSNumber, parameters: Parameters) -> CancellablePromise<Void> {
        return AF.request(DKRouter.deleteItemsInCollection(id: id, bodyParameters: parameters)).validate().promise()
    }
    
    public static func copyItems(parameters: Parameters) -> CancellablePromise<[DKItem]> {
        return AF.request(DKRouter.copyItems(bodyParameters: parameters)).validate().promiseList()
    }
    
    // MARK: Reactions
    
    public static func listReactionsForItem(id: NSNumber) -> CancellablePromise<[DKReaction]> {
        return AF.request(DKRouter.listReactionsForItem(itemID: id)).validate().promiseList()
    }
    
    public static func createReactionForItem(id: NSNumber) -> CancellablePromise<DKReaction> {
        return AF.request(DKRouter.createReactionForItem(itemID: id)).validate().promiseObject()
    }
    
    public static func deleteReaction(id: NSNumber) -> CancellablePromise<Void> {
        return AF.request(DKRouter.deleteReaction(id: id)).validate().promise()
    }
    
    // MARK: Search
    
    public static func search(parameters: Parameters) -> CancellablePromise<[Any]> {
        return AF.request(DKRouter.search(queryParameters: parameters)).validate().promiseListAny()
    }
    
    // MARK: Tags
    
    public static func listTags() -> CancellablePromise<[DKTag]> {
        return AF.request(DKRouter.listTags).validate().promiseList()
    }
    
    public static func listTagsForItem(id: NSNumber) -> CancellablePromise<[DKTag]> {
        return AF.request(DKRouter.listTagsForItem(itemID: id)).validate().promiseList()
    }
    
    public static func createTagForItem(id: NSNumber, name: String) -> CancellablePromise<DKTag> {
        return AF.request(DKRouter.createTagForItem(itemID: id, name: name)).validate().promiseObject()
    }
    
    public static func deleteTag(id: NSNumber) -> CancellablePromise<Void> {
        return AF.request(DKRouter.deleteTag(id: id)).validate().promise()
    }
    
    // MARK: Teams
    
    public static func listTeams(parameters: Parameters? = nil) -> CancellablePromise<[DKTeam]> {
        return AF.request(DKRouter.listTeams(queryParameters: parameters)).validate().promiseList()
    }
    
    public static func getTeam(id: NSNumber) -> CancellablePromise<DKTeam> {
        return AF.request(DKRouter.getTeam(id: id)).validate().promiseObject()
    }
    
    public static func updateTeam(id: NSNumber, parameters: Parameters) -> CancellablePromise<DKTeam> {
        return AF.request(DKRouter.updateTeam(id: id, bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func listUsersInTeam(id: NSNumber) -> CancellablePromise<[DKUser]> {
        return AF.request(DKRouter.listUsersInTeam(id: id)).validate().promiseList()
    }
    
    public static func createUserInTeam(id: NSNumber, parameters: Parameters) -> CancellablePromise<DKUser> {
        return AF.request(DKRouter.createUserInTeam(id: id, bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func updateUserInTeam(teamID: NSNumber, userID: NSNumber, parameters: Parameters) -> CancellablePromise<DKUser> {
        return AF.request(DKRouter.updateUserInTeam(teamID: teamID, userID: userID, bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func deleteUserInTeam(teamID: NSNumber, userID: NSNumber) -> CancellablePromise<Void> {
        return AF.request(DKRouter.deleteUserInTeam(teamID: teamID, userID: userID)).validate().promise()
    }
    
    // MARK: Users
    
    public static func createUser(parameters: Parameters) -> CancellablePromise<DKUser> {
        return AF.request(DKRouter.createUser(bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func getUser(parameters: Parameters? = nil) -> CancellablePromise<DKUser> {
        return AF.request(DKRouter.getUser(queryParameters: parameters)).validate().promiseObject()
    }
    
    public static func updateUser(parameters: Parameters) -> CancellablePromise<DKUser> {
        return AF.request(DKRouter.updateUser(bodyParameters: parameters)).validate().promiseObject()
    }
    
    public static func listContacts() -> CancellablePromise<[DKUser]> {
        return AF.request(DKRouter.listContacts).validate().promiseList()
    }
    
//    public static func getEmailAvailability(email: String) -> CancellablePromise<Bool> {
//        return AF.request(DKRouter.getEmailAvailability(email: email)).validate()
//    }
    
//    public static func getUsernameAvailability(username: String) -> CancellablePromise<Bool> {
//        return AF.request(DKRouter.getUsernameAvailability(username: username)).validate()
//    }
    
    // MARK: Uploads
    
    public static func createUploadSignature(parameters: Parameters) -> CancellablePromise<DKUploadSignature> {
        
        return CancellablePromise<DKUploadSignature> ( resolver: { resolver in
            
            let signatureRequest = AF.request(DKRouter.createUploadSignature(bodyParameters: parameters)).validate().responseData() { response in
                
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
    
}

