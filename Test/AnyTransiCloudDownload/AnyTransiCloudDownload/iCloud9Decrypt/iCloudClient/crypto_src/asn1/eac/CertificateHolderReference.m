//
//  CertificateHolderReference.m
//  crypto
//
//  Created by JGehry on 7/4/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "CertificateHolderReference.h"

@interface CertificateHolderReference ()

@property (nonatomic, readwrite, retain) NSString *countryCode;
@property (nonatomic, readwrite, retain) NSString *holderMnemonic;
@property (nonatomic, readwrite, retain) NSString *sequenceNumber;

@end

@implementation CertificateHolderReference
@synthesize countryCode = _countryCode;
@synthesize holderMnemonic = _holderMnemonic;
@synthesize sequenceNumber = _sequenceNumber;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_countryCode) {
        [_countryCode release];
        _countryCode = nil;
    }
    if (_holderMnemonic) {
        [_holderMnemonic release];
        _holderMnemonic = nil;
    }
    if (_sequenceNumber) {
        [_sequenceNumber release];
        _sequenceNumber = nil;
    }
    [super dealloc];
#endif
}

+ (NSString *)ReferenceEncoding {
    static NSString *_ReferenceEncoding = nil;
    @synchronized(self) {
        if (!_ReferenceEncoding) {
            _ReferenceEncoding = @"ISO-8859-1";
        }
    }
    return _ReferenceEncoding;
}

- (instancetype)initParamString1:(NSString *)paramString1 paramString2:(NSString *)paramString2 paramString3:(NSString *)paramString3
{
    if (self = [super init]) {
        self.countryCode = paramString1;
        self.holderMnemonic = paramString2;
        self.sequenceNumber = paramString3;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamArrayOfByte:(NSMutableData *)paramArrayOfByte
{
    if (self = [super init]) {
        @try {
            NSString *str = [[NSString alloc] initWithData:paramArrayOfByte encoding:NSISOLatin1StringEncoding];
            self.countryCode = [str substringToIndex:2];
            self.holderMnemonic = [str substringWithRange:NSMakeRange(2, str.length - 5)];
            self.sequenceNumber = [str substringFromIndex:str.length - 5];
#if !__has_feature(objc_arc)
    if (str) [str release]; str = nil;
#endif
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:exception.description userInfo:nil];
        }
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (NSString *)getCountryCode {
    return self.countryCode;
}

- (NSString *)getHolderMnemonic {
    return self.holderMnemonic;
}

- (NSString *)getSequenceNumber {
    return self.sequenceNumber;
}

- (NSMutableData *)getEncoded {
    NSString *str = [NSString stringWithFormat:@"%@%@%@", self.countryCode, self.holderMnemonic, self.sequenceNumber];
    @try {
        return [[str dataUsingEncoding:NSISOLatin1StringEncoding] mutableCopy];
    }
    @catch (NSException *exception) {
        @throw [NSException exceptionWithName:NSGenericException reason:exception.description userInfo:nil];
    }
}

@end