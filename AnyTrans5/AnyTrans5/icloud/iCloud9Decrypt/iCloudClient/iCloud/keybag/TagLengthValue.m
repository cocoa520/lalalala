//
//  TagLengthValue.m
//  
//
//  Created by Pallas on 8/2/16.
//
//  Complete

#import "TagLengthValue.h"
#import "Arrays.h"
#import "CategoryExtend.h"

@interface TagLengthValue ()

@property (nonatomic, readwrite, retain) NSString *tag;
@property (nonatomic, readwrite, retain) NSMutableData *value;

@end

@implementation TagLengthValue
@synthesize tag = _tag;
@synthesize value = _value;

+ (NSMutableArray*)parseWithData:(NSMutableData*)data {
    return [TagLengthValue parseWithDataStream:[DataStream wrapWithData:data]];
}

+ (NSMutableArray*)parseWithDataStream:(DataStream*)buffer {
    NSMutableArray *tagValues = [[[NSMutableArray alloc] init] autorelease];
    NSMutableData *tagBytes = [[NSMutableData alloc] initWithSize:4];
    
    while ([buffer position] + 8 <= [buffer limit]) {
        [buffer getWithMutableData:tagBytes];
        NSString *tag = [[NSString alloc] initWithData:tagBytes encoding:NSUTF8StringEncoding];
        
        // Signed 32 bit length. Limited to 2 GB.
        int length = [buffer getInt];
        if (length < 0 || length > [buffer remaining]) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"Bad TagLengthValue length: %d", length] userInfo:nil];
        }
        
        NSMutableData *value = [[NSMutableData alloc] initWithSize:length];
        [buffer getWithMutableData:value];
        
        TagLengthValue *tagValue = [[TagLengthValue alloc] initWithTag:tag withValue:value];
        [tagValues addObject:tagValue];
#if !__has_feature(objc_arc)
        if (tag != nil) [tag release]; tag = nil;
        if (value != nil) [value release]; value = nil;
        if (tagValue != nil) [tagValue release]; tagValue = nil;
#endif
    }
#if !__has_feature(objc_arc)
    if (tagBytes != nil) [tagBytes release]; tagBytes = nil;
#endif
    return tagValues;
}

- (id)initWithTag:(NSString*)tag withValue:(NSMutableData*)value {
    if (self = [super init]) {
        [self setTag:tag];
        [self setValue:value];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_tag != nil) [_tag release]; _tag = nil;
    if (_value != nil) [_value release]; _value = nil;
    [super dealloc];
#endif
}

- (int)length {
    return (int)([self value].length);
}

- (NSMutableData*)getValue {
    NSMutableData *retData = nil;
    if ([self value]) {
        retData = [Arrays copyOfWithData:[self value] withNewLength:(int)([self value].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

@end
