//
//  ServiceKeySetBuilder.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class KeyID;
@class KeySet;
@class ServiceKeySet;
@class SignatureInfo;
@class PrivateKey;
@class TypeData;

@interface ServiceKeySetBuilder : NSObject {
@private
    NSArray *                                   _fieldLengthToCurveName;
    BOOL                                        _useCompactKeys;
    NSMutableDictionary *                       _serviceKeyIDs;
    NSMutableArray *                            _keys;
    SignatureInfo *                             _signature;
    NSString *                                  _ksID;
    NSString *                                  _name;
    int                                         _flags;
}

+ (ServiceKeySetBuilder*)builder;
+ (ServiceKeySet*)buildWithKeySet:(KeySet*)keySet;

- (ServiceKeySetBuilder*)putFieldLengthToCurveName:(NSArray*)fieldLengthToCurveName;
- (ServiceKeySetBuilder*)putUseCompactKeys:(BOOL)useCompactKeys;
- (ServiceKeySetBuilder*)putName:(NSString*)name;
- (ServiceKeySetBuilder*)addPrivateKeys:(NSSet*)keys;
- (ServiceKeySetBuilder*)addPrivateKey:(PrivateKey*)key;
- (ServiceKeySetBuilder*)addServiceKeys:(NSSet*)serviceKeys;
- (ServiceKeySetBuilder*)addServiceKey:(TypeData*)serviceKey;
- (ServiceKeySetBuilder*)addServiceKeyWithService:(int)service withKeyID:(KeyID*)keyID;
- (ServiceKeySetBuilder*)putChecksum:(NSData*)checksum;
- (ServiceKeySetBuilder*)putKsID:(NSString*)ksID;
- (ServiceKeySetBuilder*)putFlags:(int)flags;
- (ServiceKeySetBuilder*)putSignature:(SignatureInfo*)signature;
- (ServiceKeySetBuilder*)putKeySet:(KeySet*)keySet;
- (ServiceKeySet*)build;

@end
