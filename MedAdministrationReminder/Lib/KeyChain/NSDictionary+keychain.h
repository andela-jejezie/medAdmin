//
//  NSDictionary+keychain.h
//  MedAdministrationReminder
//
//  Created by Andela on 5/28/16.
//  Copyright © 2016 Andela. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (keychain)
+(NSDictionary *) dictionaryFromKeychainWithKey:(NSString *)aKey;
-(void) deleteFromKeychainWithKey:(NSString *)aKey;
-(void) storeToKeychainWithKey:(NSString *)aKey;
@end
