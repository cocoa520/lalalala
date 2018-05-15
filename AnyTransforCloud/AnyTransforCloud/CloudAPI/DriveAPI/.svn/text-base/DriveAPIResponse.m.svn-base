//
//  DriveAPIResult.m
//  DriveSync
//
//  Created by 罗磊 on 2017/11/29.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "DriveAPIResponse.h"

@implementation DriveAPIResponse
@synthesize responseCode = _responseCode;
@synthesize responseData = _responseData;
@synthesize content = _content;

- (instancetype)initWithResponseData:(NSData *)responseData  status:(ResponseCode)responsecode
{
    self = [super init];
    if (self) {
        _responseCode = responsecode;
        _responseData = [responseData retain];
        if (responseData) {
            _content = [[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL] retain];
            if (!_content) {
                _content = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            }
            if (!_content) {
                id tmpObj = [NSKeyedUnarchiver unarchiveObjectWithData:responseData];
                if (tmpObj && [tmpObj isKindOfClass:[NSArray class]]) {
                    NSArray *contentArray = (NSArray *)tmpObj;
                    NSMutableArray *mutAry = [[NSMutableArray alloc] init];
                    for (NSData *obj in contentArray) {
                        _content = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingMutableContainers error:NULL];
                        [mutAry addObject:_content];
                    }
                    _content = [mutAry retain];
                    [mutAry release];
                    mutAry = nil;
                }
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [_responseData release],_responseData = nil;
    [_content release],_content = nil;
    [super dealloc];
}
@end
