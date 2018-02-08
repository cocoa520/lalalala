//
//  AdditionalInformationSyntax.m
//  crypto
//
//  Created by JGehry on 6/24/16.
//  Copyright (c) 2016 pallas. All rights reserved.
//

#import "AdditionalInformationSyntax.h"

@interface AdditionalInformationSyntax ()

@property (nonatomic, readwrite, retain) DirectoryString *infomation;

@end

@implementation AdditionalInformationSyntax
@synthesize infomation = _infomation;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_infomation) {
        [_infomation release];
        _infomation = nil;
    }
    [super dealloc];
#endif
}

+ (AdditionalInformationSyntax *)getInstance:(id)paramObject {
    if ([paramObject isKindOfClass:[AdditionalInformationSyntax class]]) {
        return (AdditionalInformationSyntax *)paramObject;
    }
    if (paramObject) {
        return [[[AdditionalInformationSyntax alloc] initParamDirectoryString:[DirectoryString getInstance:paramObject]] autorelease];
    }
    return nil;
}

- (instancetype)initParamDirectoryString:(DirectoryString *)paramDirectoryString
{
    if (self = [super init]) {
        self.infomation = paramDirectoryString;
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (instancetype)initParamString:(NSString *)paramString
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (DirectoryString *)getInfomation {
    return self.infomation;
}

- (ASN1Primitive *)toASN1Primitive {
    return [self.infomation toASN1Primitive];
}

@end
