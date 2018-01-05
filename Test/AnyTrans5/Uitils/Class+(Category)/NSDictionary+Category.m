//
//  NSDictionary+Category.m
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "NSDictionary+Category.h"

@implementation NSDictionary (Category)

+ (NSDictionary *)dictionaryFromData:(NSData *)data
{
    NSString *error;
    NSPropertyListFormat format;
    NSMutableDictionary *dict = [NSPropertyListSerialization
                                 propertyListFromData:data
                                 mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                 format:&format
                                 errorDescription:&error];
    if(!dict){
        [error release];
    }
    return dict;

}
- (NSData *)toData
{
    NSString *error;
    NSData *data = [NSPropertyListSerialization dataFromPropertyList:self format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if(!data){
        [error release];
    }
    return data;
}
- (NSMutableDictionary *)mutableDeepCopy {
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:[self count]];
    NSArray *keys=[self allKeys];
    for(id key in keys)
    {
        id value=[self objectForKey:key];
        id copyValue = nil;
        if ([value isKindOfClass:[NSDate class]]) {
            copyValue = [value copy];
            [dict setObject:copyValue forKey:key];
            continue;
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            copyValue = [value copy];
            [dict setObject:copyValue forKey:key];
            continue;
        }
        if ([value respondsToSelector:@selector(mutableDeepCopy)]) {
            copyValue = [value mutableDeepCopy];
        } else if([value respondsToSelector:@selector(mutableCopy)]) {
            copyValue=[value mutableCopy];
        }
        if(copyValue == nil)
        { copyValue = [value copy];}
        [dict setObject:copyValue forKey:key];
        if ([copyValue isKindOfClass:[NSMutableDictionary class]]) {
            [copyValue release];
            copyValue = nil;
        }
    }
    return dict;
}
@end
