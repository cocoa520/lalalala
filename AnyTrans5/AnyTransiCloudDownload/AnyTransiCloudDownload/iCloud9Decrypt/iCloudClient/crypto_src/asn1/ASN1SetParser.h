//
//  ASN1SetParser.h
//  crypto
//
//  Created by JGehry on 6/1/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1Encodable.h"

@interface ASN1SetParser : ASN1Encodable {
@private
    int _index;
}

- (ASN1Encodable *)readObject;
- (ASN1Primitive *)getLoadedObject;
- (ASN1Primitive *)toASN1Primitive;

@end
