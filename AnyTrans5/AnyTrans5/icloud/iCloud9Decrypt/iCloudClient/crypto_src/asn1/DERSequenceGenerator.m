//
//  DERSequenceGenerator.m
//  iCloudiOS9Demo
//
//  Created by JGehry on 7/28/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "DERSequenceGenerator.h"
#import "DEROutputStream.h"
#import "Arrays.h"

@interface DERSequenceGenerator ()

@property (nonatomic, readwrite, retain) Stream *bOut;

@end

@implementation DERSequenceGenerator
@synthesize bOut = _bOut;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_bOut) {
        [_bOut release];
        _bOut = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream
{
    if (self = [super initParamOutputStream:paramOutputStream]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamOutputStream:(Stream *)paramOutputStream paramInt:(int)paramInt paramBoolean:(BOOL)paramBoolean
{
    if (self = [super initParamOutputStream:paramOutputStream paramInt:paramInt paramBoolean:paramBoolean]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;        
    }
}

- (void)addObject:(ASN1Encodable *)paramASN1Encodable {
    ASN1OutputStream *output = [[DEROutputStream alloc] initDERParamOutputStream:self.bOut];
    [[paramASN1Encodable toASN1Primitive] encode:output];
#if !__has_feature(objc_arc)
    if (output) [output release]; output = nil;
#endif
}

- (Stream *)getRawOutputStream {
    return self.bOut;
}

//- (void)close {
//    NSMutableData *tmpData = [Arrays copyOfWithData:[self.bOut toMutableData] withNewLength:(int)[[self.bOut toMutableData] length]];
//    [self writeDEREncoded:48 paramArrayOfByte:tmpData];
//#if !__has_feature(objc_arc)
//    if (tmpData) [tmpData release]; tmpData = nil;
//#endif
//}

@end
