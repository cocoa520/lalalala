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
+ (AssetExEncryptedAttributes *)from:(NSMutableData *)data;
+ (AssetExEncryptedAttributes *)fromProtobuf:(NSMutableData *)data;
+ (AssetExEncryptedAttributes *)fromBPList:(NSMutableData *)data;
+ (AssetExEncryptedAttributes *)fromDictionary:(NSDictionary *)data;

@end
