//
//  ECKeyExportAssistant.m
//  
//
//  Created by Pallas on 8/3/16.
//
//  Complete

#import "ECKeyExportAssistant.h"
#import "CategoryExtend.h"

@implementation ECKeyExportAssistant

+ (NSMutableData*)concatenate:(NSMutableData*)data,... {
    int length = 0;
    NSMutableArray *argArray = [[NSMutableArray alloc] init];
    va_list argList;
    NSMutableData *arg = nil;
    if (data != nil) {
        va_start(argList, data);
        [argArray addObject:data];
        length += (int)(data.length);
        while((arg = va_arg(argList, NSMutableData*))) {
            [argArray addObject:arg];
            length += (int)(arg.length);
        }
        va_end(argList);
    }
    
    NSMutableData *bytes = [[[NSMutableData alloc] initWithSize:length] autorelease];
    if (argArray.count > 0) {
        NSEnumerator *iterator = [argArray objectEnumerator];
        NSMutableData *value = nil;
        int offset = 0;
        while (value = [iterator nextObject]) {
            int valueLen = (int)(value.length);
            [bytes copyFromIndex:offset withSource:value withSourceIndex:0 withLength:valueLen];
            offset += valueLen;
        }
    }
#if !__has_feature(objc_arc)
    if (argArray != nil) [argArray release]; argArray = nil;
#endif
    return bytes;
}

@end
