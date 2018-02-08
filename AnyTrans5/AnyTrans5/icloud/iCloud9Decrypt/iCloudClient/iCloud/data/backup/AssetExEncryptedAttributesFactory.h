//
//  AssetExEncryptedAttributesFactory.h
//  
//
//  Created by JGehry on 6/15/17.
//
//

#import <Foundation/Foundation.h>
#import "AssetExEncryptedAttributes.h"

@interface AssetExEncryptedAttributesFactory : NSObject

+ (NSMutableData *)BPLIST;
+ (AssetExEncryptedAttributes *)from:(NSMutableData *)data withDomain:(NSString *)domain;
+ (AssetExEncryptedAttributes *)fromProtobuf:(NSMutableData *)data withDomain:(NSString *)domain;
+ (AssetExEncryptedAttributes *)fromBPList:(NSMutableData *)data withDomain:(NSString *)domain;
+ (AssetExEncryptedAttributes *)fromDictionary:(NSDictionary *)data withDomain:(NSString *)domain;

@end
