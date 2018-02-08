//
//  DEROctetStringParser.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "ASN1OctetStringParser.h"
#import "DefiniteLengthInputStream.h"

@interface DEROctetStringParser : ASN1OctetStringParser {
@private
    DefiniteLengthInputStream *_stream;
}

- (instancetype)initParamDefiniteLengthInputStream:(DefiniteLengthInputStream *)paramDefiniteLengthInputStream;
- (Stream *)getOctetStream;
- (ASN1Primitive *)getLoadedObject;
- (ASN1Primitive *)toASN1Primitive;

@end
