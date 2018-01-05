//
//  ASN1Exception.h
//  crypto
//
//  Created by JGehry on 7/25/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASN1Exception : NSObject {
@private
    NSException *_cause;
}

- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamString:(NSString *)paramString paramThrowable:(NSException *)paramThrowable;

@end
