//
//  IMBTransferError.m
//  AnyTrans
//
//  Created by m on 17/9/26.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBTransferError.h"
#import "IMBHelper.h"
@implementation IMBTransferError
@synthesize errorArrayM = _errorArrayM;
+ (IMBTransferError*)singleton {
    static IMBTransferError *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBTransferError alloc] init];
        }
    }
    return _singleton;
}

- (id)init {
    if (self = [super init]) {
        _errorArrayM = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeAllError {
    [_errorArrayM removeAllObjects];
}

- (void)addAnErrorWithErrorName:(NSString *)errorName WithErrorReson:(NSString *)errorReson {
    IMBError *error = [[IMBError alloc] init];
    if ([IMBHelper stringIsNilOrEmpty:errorName]) {
        errorName = @"";
    }
    error.name = errorName;
    if ([IMBHelper stringIsNilOrEmpty:errorReson]) {
        errorReson = @"";
    }
    error.reson = errorReson;
    [_errorArrayM addObject:error];
    [error release], error = nil;
}

- (void)dealloc {
    if (_errorArrayM != nil) {
        [_errorArrayM release];
        _errorArrayM = nil;
    }
    [super dealloc];
}

@end


@implementation IMBError
@synthesize name = _name;
@synthesize reson = _reason;

-(id)init {
    if (self = [super init]) {
        _name = @"";
        _reason = @"";
    }
    return self;
}

@end
