//
//  NSDictionary+keychain.m
//  MedAdministrationReminder
//
//  Created by Andela on 5/28/16.
//  Copyright © 2016 Andela. All rights reserved.
//

#import "NSDictionary+keychain.h"

@implementation NSDictionary (keychain)
-(void) storeToKeychainWithKey:(NSString *)aKey {
    // serialize dict
    NSData *serializedDictionary = [NSKeyedArchiver archivedDataWithRootObject:self];
    // encrypt in keychain
    // first, delete potential existing entries with this key (it won't auto update)
    [self deleteFromKeychainWithKey:aKey];
    
    // setup keychain storage properties
    NSDictionary *storageQuery = @{
                                   (__bridge id)kSecAttrAccount:    aKey,
                                   (__bridge id)kSecValueData:      serializedDictionary,
                                   (__bridge id)kSecClass:          (__bridge id)kSecClassGenericPassword,
                                   (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleWhenUnlocked
                                   };
    OSStatus osStatus = SecItemAdd((__bridge CFDictionaryRef)storageQuery, nil);
    if(osStatus != noErr) {
        // do someting with error
    }
}


+(NSDictionary *) dictionaryFromKeychainWithKey:(NSString *)aKey {
    // setup keychain query properties
    NSDictionary *readQuery = @{
                                (__bridge id)kSecAttrAccount: aKey,
                                (__bridge id)kSecReturnData: (id)kCFBooleanTrue,
                                (__bridge id)kSecClass:      (__bridge id)kSecClassGenericPassword
                                };
    
    CFDataRef serializedDictionary = NULL;
    OSStatus osStatus = SecItemCopyMatching((__bridge CFDictionaryRef)readQuery, (CFTypeRef *)&serializedDictionary);
    if(osStatus == noErr) {
        // deserialize dictionary
        NSData *data = (__bridge NSData *)serializedDictionary;
        NSDictionary *storedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return storedDictionary;
    }
    else {
        // do something with error
        return nil;
    }
}


-(void) deleteFromKeychainWithKey:(NSString *)aKey {
    // setup keychain query properties
    NSDictionary *deletableItemsQuery = @{
                                          (__bridge id)kSecAttrAccount:        aKey,
                                          (__bridge id)kSecClass:              (__bridge id)kSecClassGenericPassword,
                                          (__bridge id)kSecMatchLimit:         (__bridge id)kSecMatchLimitAll,
                                          (__bridge id)kSecReturnAttributes:   (id)kCFBooleanTrue
                                          };
    
    CFArrayRef itemList = nil;
    OSStatus osStatus = SecItemCopyMatching((__bridge CFDictionaryRef)deletableItemsQuery, (CFTypeRef *)&itemList);
    // each item in the array is a dictionary
    NSArray *itemListArray = (__bridge NSArray *)itemList;
    for (NSDictionary *item in itemListArray) {
        NSMutableDictionary *deleteQuery = [item mutableCopy];
        [deleteQuery setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        // do delete
        osStatus = SecItemDelete((__bridge CFDictionaryRef)deleteQuery);
        if(osStatus != noErr) {
            // do something with error
        }
    }
}
@end
