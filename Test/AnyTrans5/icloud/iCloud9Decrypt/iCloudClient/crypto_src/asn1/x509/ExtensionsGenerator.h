//
//  ExtensionsGenerator.h
//  crypto
//
//  Created by JGehry on 7/25/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1ObjectIdentifier.h"
#import "Extension.h"
#import "Extensions.h"

@interface ExtensionsGenerator : NSObject {
@private
    NSMutableDictionary *_extensions;
    NSMutableArray *_extOrdering;
}

- (void)reset;
- (void)addExtension:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean paramASN1Encodable:(ASN1Encodable *)paramASN1Encodable;
- (void)addExtension:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramBoolean:(BOOL)paramBoolean paramArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (void)addExtension:(Extension *)paramExtension;
- (BOOL)isEmpty;
- (Extensions *)generate;

@end
