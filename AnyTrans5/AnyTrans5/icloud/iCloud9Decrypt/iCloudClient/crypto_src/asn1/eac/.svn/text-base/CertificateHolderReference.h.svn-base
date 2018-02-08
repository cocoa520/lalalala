//
//  CertificateHolderReference.h
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CertificateHolderReference : NSObject {
@private
    NSString *_countryCode;
    NSString *_holderMnemonic;
    NSString *_sequenceNumber;
}

+ (NSString *)ReferenceEncoding;
- (instancetype)initParamString1:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramString3:(NSString *)paramString3;
- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte;
- (NSString *)getCountryCode;
- (NSString *)getHolderMnemonic;
- (NSString *)getSequenceNumber;
- (NSMutableData *)getEncoded;

@end
