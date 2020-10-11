//
//  KeychainSwift+CodableKeychain.swift
//  North-Mobileworks
//
//  Created by Deryck Tomiuc on 23/09/2020.
//  Copyright © 2020 North-Mobileworks. All rights reserved.
//

import KeychainSwift


/**
 
 List of errors that must be thrown if error occures.
 
 */
public enum CodableKeychainError: Error {
    
    /**
     
     Decoding fails while retrieving data from Keychain.
     
     */
    case decodingFailed(String)
  
    /**
     
     Encoding fails while saving data to Keychain.
     
     */
    case encodingFailed(String)

}


/**
 
 Extension for KeychainSwift to adopt CodableKeychain protocol.
 
 */
extension KeychainSwift: CodableKeychain {
    
    public func set<EncodableObject>(_ object: EncodableObject, forKey key: String, encoder: JSONEncoder, access: KeychainAccessOptions) throws -> Bool where EncodableObject : Encodable {
        do {
            // Encode object to Data
            let objectData = try encoder.encode(object)
            // Set object to the specified key
            return KeychainSwift().set(objectData, forKey: key)
        } catch let error {
            throw CodableKeychainError.encodingFailed(error.localizedDescription)
        }
    }
    
    public func get<DecodableObject>(_ key: String, decoder: JSONDecoder) throws -> DecodableObject? where DecodableObject : Decodable {
        do {
            // Get object from Keychain, return nil if missing
            guard let objectData = KeychainSwift().getData(key) else { return nil }
            // Decode object
            return try decoder.decode(DecodableObject.self, from: objectData)
        } catch let error {
            throw CodableKeychainError.decodingFailed(error.localizedDescription)
        }
    }
    
}
