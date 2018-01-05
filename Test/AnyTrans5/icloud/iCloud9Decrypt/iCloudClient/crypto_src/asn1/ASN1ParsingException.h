//
//  ASN1ParsingException.h
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/26/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASN1ParsingException : NSException {
@private
    NSException *_cause;
}

- (instancetype)initParamString:(NSString *)paramString;
- (instancetype)initParamString:(NSString *)paramString paramThrowable:(NSException *)paramThrowable;
- (NSException *)getCause;

@end
