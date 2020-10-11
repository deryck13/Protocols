//
//  CodableKeychain.swift
//  North-Mobileworks
//
//  Created by Deryck Tomiuc on 22/09/2020.
//  Copyright © 2020 North-Mobileworks. All rights reserved.
//

import Foundation


/**
 
 These options are used to determine when a keychain item should be readable (default  .accessibleWhenUnlocked)
 
 */
public enum KeychainAccessOptions {
    
    /**
     
     The data in the keychain item can be accessed only while the device is unlocked by the user.
     
     This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.
     
     This is the default value for keychain items added without explicitly setting an accessibility constant.
     
     */
    case accessibleWhenUnlocked
    
    /**
     
     The data in the keychain item can be accessed only while the device is unlocked by the user.
     
     This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
     
     */
    case accessibleWhenUnlockedThisDeviceOnly
    
    /**
     
     The data in the keychain item can always be accessed regardless of whether the device is locked.
     
     This is not recommended for application use. Items with this attribute migrate to a new device when using encrypted backups.
     
     */
    case accessibleAlways
    

    public static var defaultOption: KeychainAccessOptions {
        return .accessibleWhenUnlocked
    }
    
}


/**
 
 Collection of functions to save, retrieve and delete Codable objects to Keychain.
 
 */
public protocol CodableKeychain: class {
    
    /**
     
     Store object in Keychain under the given key.
     
     - Parameters:
        - object: Object to be written to the Keychain.
        - key: Key under which the object is stored in Keychain.
        - encoder: The type that can encode values into a native format for external representation
        - access: Keychain read option
     
     - Returns true, if object was saved to Keychain.
     
     */
    func set<EncodableObject>(_ object: EncodableObject, forKey key: String, encoder: JSONEncoder, access: KeychainAccessOptions) throws -> Bool where EncodableObject : Encodable
    
    /**
     
     Retrieve the object form Keychain corresponding to the given key
     
     - Parameters:
        - key: The key used to read Keychain object.
        - decoder: The type that can decode values from a native format into in-memory representations
     
     - Returns: Object, if succeded or nil if missing.
     
     */
    func get<DecodableObject>(_ key: String, decoder: JSONDecoder) throws -> DecodableObject? where DecodableObject : Decodable
    
    
    /**
     
     Delete object specified by the key from Keychain.
     
     - Parameters:
        - key: Key under which the stored object must be deleted.
     
     - Returns: True, if object was deleted from Keychain.
     
     */
    func delete(_ key: String) -> Bool
    
}


/**
 
 Default implementation for CodableKeychain. It uses JSONEncoder and JSONDecoder as default, with KeychainAccessOptions.defaultOption access option.
 
 */
public extension CodableKeychain {
    
    /**
    
    Store object in Keychain under the given key.
    
    - Parameters:
     - object: Object to be written to the Keychain.
     - key: Key under which the object is stored in Keychain.
    
    - Returns true, if object was saved to Keychain.
    
    */
    func set<EncodableObject>(_ object: EncodableObject, forKey key: String, encoder: JSONEncoder = .init(), access: KeychainAccessOptions = KeychainAccessOptions.defaultOption) throws -> Bool where EncodableObject : Encodable {
        return try self.set(object, forKey: key, encoder: encoder, access: access)
    }
    
    /**
     
     Retrieve the object form Keychain corresponding to the given key
     
     - Parameters:
        - key: The key used to read Keychain object.
     
     - Returns: Object, if succeded or nil if missing.
     
     */
    func get<DecodableObject>(_ key: String, decoder: JSONDecoder = .init()) throws -> DecodableObject? where DecodableObject : Decodable {
        return try self.get(key, decoder: decoder)
    }
    
}
