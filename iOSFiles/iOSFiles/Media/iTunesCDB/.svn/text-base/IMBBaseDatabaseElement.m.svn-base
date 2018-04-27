//
//  IMBBaseDatabaseElement.m
//  MediaTrans
//
//  Created by Pallas on 12/11/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBStringMHOD.h"

@implementation IMBBaseDatabaseElement
@synthesize headerSize = _headerSize;
@synthesize sectionSize = _sectionSize;

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)dealloc{
    free(_unusedHeader);
    [super dealloc];
}

//TODO:bug
-(BOOL)validateHeader:(NSString *)validIdentifier{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* strIndentfier = [[NSString alloc] initWithCString:_identifier encoding:enc];
    if ([strIndentfier isEqual:validIdentifier] == FALSE) {
        @throw [NSException exceptionWithName:@"Ex_Parse_CDBIdentifier_Invalid" reason:[NSString stringWithFormat:@"Parse CDB %@ indentifier invalid!", validIdentifier] userInfo:nil];
    }
    if(_headerSize < _requiredHeaderSize){
        @throw [NSException exceptionWithName:@"ExUnsupportiTunesVersion_CDBHeader_Invalid" reason:@"Parse CDB header invalid!" userInfo:nil];
    }
    [strIndentfier release];
    return TRUE;
}

-(long)readToHeaderEnd:(NSData *)reader currPosition:(long)currPosition{
    unusedHeaderLength = _headerSize - _requiredHeaderSize;
    _unusedHeader = malloc(unusedHeaderLength + 1);
    memset(_unusedHeader, 0, malloc_size(_unusedHeader));
    [reader getBytes:_unusedHeader range:NSMakeRange(currPosition, unusedHeaderLength)];
    return currPosition + unusedHeaderLength;
}

-(long)read:(IMBiPod*)ipod reader:(NSData *)reader currPosition:(long)currPosition{
    iPod = ipod;
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    //子类实现
}

-(int)getSectionSize{
    //子类实现
    return 0;
}

-(IMBStringMHOD*)getChildByType:(NSArray *)children childrentype:(int)type{
    for (IMBStringMHOD * item in children) {
        if([item type] == type){
            return item;
        }
    }
    return nil;
}

-(NSString*)getDataElement:(NSArray *)children clidrentype:(int)type{
    IMBStringMHOD *mhod = [self getChildByType:children childrentype:type];
    if (mhod != nil) {
        return [mhod data];
    }else{
        return nil;
    }
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end
