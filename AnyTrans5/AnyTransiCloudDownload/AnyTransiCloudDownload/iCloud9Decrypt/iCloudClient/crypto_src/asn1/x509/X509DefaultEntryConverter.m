//
//  X509DefaultEntryConverter.m
//  crypto
//
//  Created by JGehry on 7/14/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "X509DefaultEntryConverter.h"
#import "X509Name.h"
#import "DERIA5String.h"
#import "DERGeneralizedTime.h"
#import "DERPrintableString.h"
#import "DERUTF8String.h"
#import "CategoryExtend.h"

@implementation X509DefaultEntryConverter

- (ASN1Primitive *)getConvertedValue:(ASN1ObjectIdentifier *)paramASN1ObjectIdentifier paramString:(NSString *)paramString {
    if (([paramString length] != 0) && ([paramString characterAtIndex:0] == '#')) {
        @try {
            return [self convertHexEncoded:paramString paramInt:1];
        }
        @catch (NSException *exception) {
            @throw [NSException exceptionWithName:NSGenericException reason:[NSString stringWithFormat:@"can't recode value for oid %@", [paramASN1ObjectIdentifier getId]] userInfo:nil];
        }
    }
    if (([paramString length] != 0) && ([paramString characterAtIndex:0] == '\\')) {
        paramString = [paramString substringToIndex:1];
    }
    if (([paramASN1ObjectIdentifier isEqual:[X509Name EmailAddress]]) || ([paramASN1ObjectIdentifier isEqual:[X509Name DC]])) {
        return [[[DERIA5String alloc] initParamString:paramString] autorelease];
    }
    if ([paramASN1ObjectIdentifier isEqual:[X509Name DATE_OF_BIRTH]]) {
        return [[[DERGeneralizedTime alloc] initParamString:paramString] autorelease];
    }
    if (([paramASN1ObjectIdentifier isEqual:[X509Name C]]) || ([paramASN1ObjectIdentifier isEqual:[X509Name SN]]) || ([paramASN1ObjectIdentifier isEqual:[X509Name DN_QUALIFIER]]) || ([paramASN1ObjectIdentifier isEqual:[X509Name TELEPHONE_NUMBER]])) {
        return [[[DERPrintableString alloc] initParamString:paramString] autorelease];
    }
    return [[[DERUTF8String alloc] initParamString:paramString] autorelease];
}

@end
