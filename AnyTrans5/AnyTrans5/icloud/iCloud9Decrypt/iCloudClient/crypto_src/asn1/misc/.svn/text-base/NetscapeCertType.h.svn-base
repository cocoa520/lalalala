//
//  NetscapeCertType.h
//  crypto
//
//  Created by JGehry on 6/15/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERBitString.h"

@interface NetscapeCertType : DERBitString

+ (int)sslClient;
+ (int)sslServer;
+ (int)smime;
+ (int)objectSigning;
+ (int)reserved;
+ (int)sslCA;
+ (int)smimeCA;
+ (int)objectSigningCA;

- (instancetype)initParamInt:(int)paramInt;
- (instancetype)initParamDERBitString:(DERBitString *)paramDERBitString;
- (NSString *)toString;

@end
