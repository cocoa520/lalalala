//
//  ASN1Generator.h
//  crypto
//
//  Created by JGehry on 7/25/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryExtend.h"

@interface ASN1Generator : NSObject {
@protected
    Stream *_oUT;
}

@property (nonatomic, readwrite, retain) Stream *oUT;

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream;
- (Stream *)getRawOutputStream;

@end
