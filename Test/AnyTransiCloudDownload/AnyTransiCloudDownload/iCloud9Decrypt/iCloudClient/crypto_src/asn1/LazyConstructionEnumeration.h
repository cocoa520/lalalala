//
//  LazyConstructionEnumeration.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASN1InputStream.h"

@interface LazyConstructionEnumeration : NSEnumerator {
@private
    ASN1InputStream *_aIn;
    id _nextObj;
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (BOOL)hasMoreElements;
- (id)nextElement;
- (id)readObject;

@end
