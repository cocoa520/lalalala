//
//  Extensions.h
//  crypto
//
//  Created by JGehry on 6/22/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Object.h"
#import "ASN1ObjectIdentifier.h"
#import "Extension.h"
#import "ASN1TaggedObject.h"

@interface Extensions : ASN1Object {
@private
    NSMutableDictionary *_extensions;
    NSMutableArray *_ordering;
}

+ (Extensions *)getInstance:(id)paramObject;
+ (Extensions *)getInstance:(ASN1TaggedObject *)paramASN1TaggedObject paramBoolean:(BOOL)paramBoolean;
- (instancetype)initParamExtension:(Extension *)paramExtension;
- (instancetype)initParamArrayOfExtension:(NSMutableArray *)paramArrayOfExtension;
- (NSEnumerator *)oids;
- (Extension *)getExtension:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (ASN1Encodable *)getExtensionParsedValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier;
- (ASN1Primitive *)toASN1Primitive;
- (BOOL)equivalent:(Extensions *)paramExtensions;
- (NSMutableArray *)getExtensionOIDs;
- (NSMutableArray *)getNonCriticalExtensionOIDs;
- (NSMutableArray *)getCriticalExtensionOIDs;
- (NSMutableArray *)getExtensionOIDs:(BOOL)paramBoolean;
- (NSMutableArray *)toOidArray:(NSMutableArray *)paramVector;

@end
