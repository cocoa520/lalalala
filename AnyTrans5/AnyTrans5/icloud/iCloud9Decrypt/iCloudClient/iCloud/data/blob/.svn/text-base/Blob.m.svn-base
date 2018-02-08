//
//  Blob.m
//  
//
//  Created by Pallas on 4/11/16.
//
//  Complete

#import "Blob.h"
#import "Arrays.h"
#import "CategoryExtend.h"
#import "BlobLists.h"
#import "BlobUtils.h"

@interface BlobBase ()

@property (nonatomic, readwrite, retain) BlobHeader *header;

@end

@implementation BlobBase
@synthesize header = _header;

- (id)init:(DataStream*)blob {
    if (self = [super init]) {
        BlobHeader *tmpHeader = [[BlobHeader alloc] init:blob];
        if (tmpHeader == nil) {
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setHeader:tmpHeader];
#if !__has_feature(objc_arc)
        if (tmpHeader) [tmpHeader release]; tmpHeader = nil;
#endif
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setHeader:nil];
    [super dealloc];
#endif
}

- (int)type {
    return [self.header type];
}

- (int)length {
    return [self.header length];
}

@end

@implementation BlobHeader

- (id)init:(DataStream*)blob {
    if (self = [super init]) {
        [blob rewind];
        
        _length = [blob getInt];
        if (_length != blob.limit) {
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        _type = [blob getInt];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (int)length {
    return _length;
}

- (int)type {
    return _type;
}

@end

@interface BlobA0 ()
@property (nonatomic, readwrite, assign) int x;
@property (nonatomic, readwrite, assign) int y;
@property (nonatomic, readwrite, retain) BlobLists *list;

@end

@implementation BlobA0
@synthesize x = _x;
@synthesize iterations = _iterations;
@synthesize y = _y;
@synthesize list = _list;
@synthesize label = _label;
@synthesize timestamp = _timestamp;

- (id)init:(DataStream *)blob {
    if (self = [super init:blob]) {
        if (self.type != 0x000000A0) {
            NSLog(@"BlobA0() - unexpected type: 0x%X", self.type);
        }
        
        self.x = [blob getInt];
        self.iterations = [blob getInt];
        self.y = [blob getInt];
        BlobLists *tmpLists =  [[BlobLists alloc] init:blob];
        if (tmpLists == nil) {
            [self release];
            return nil;
        }
        [self setList:tmpLists];
        if ([self.list size] < 5) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"too few blob fields: %d", [self.list size]] userInfo:nil];
        }
        NSData *tmpData = [self.list get:4];
        if (tmpData != nil) {
            NSString *tmpStr = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
            if (tmpStr != nil) {
                [self setLabel:tmpStr];
#if !__has_feature(objc_arc)
                if (tmpStr) [tmpStr release]; tmpStr = nil;
#endif
            }
        }
        tmpData = [self.list get:5];
        if (tmpData != nil) {
            NSString *tmpStr = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
            if (tmpStr != nil) {
                [self setTimestamp:tmpStr];
#if !__has_feature(objc_arc)
                if (tmpStr) [tmpStr release]; tmpStr = nil;
#endif
            }
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setList:nil];
    [self setLabel:nil];
    [self setTimestamp:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)dsid {
    return [self.list get:0];
}

- (NSMutableData*)salt {
    return [self.list get:1];
}

- (NSMutableData*)key {
    return [self.list get:2];
}

- (NSMutableData*)data {
    return [self.list get:3];
}

@end

@interface BlobA4 ()

@property (nonatomic, readwrite, assign) int x;
@property (nonatomic, readwrite, retain) NSMutableData *tag;
@property (nonatomic, readwrite, retain) NSMutableData *uid;
@property (nonatomic, readwrite, retain) NSMutableData *salt;
@property (nonatomic, readwrite, retain) NSMutableData *ephemeralKey;

@end

@implementation BlobA4
@synthesize x = _x;
@synthesize tag = _tag;
@synthesize uid = _uid;
@synthesize salt = _salt;
@synthesize ephemeralKey = _ephemeralKey;

- (id)init:(int)x_ withTag:(NSMutableData*)tag_ withUid:(NSMutableData*)uid_ withSalt:(NSMutableData*)salt_ withEphemeralKey:(NSMutableData*)ephemeralKey_ {
    if (self = [super init]) {
        if (tag_.length != 0x10) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"bad tag 0x%@", [tag_ dataToHex]] userInfo:nil];
        }
        self.x = x_;
        
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:0x10];
        if (tmpData != nil) {
            [tmpData copyFromIndex:0 withSource:tag_ withSourceIndex:0 withLength:(int)(tmpData.length)];
            [self setTag:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        tmpData = [[NSMutableData alloc] initWithSize:(int)(uid_.length)];
        if (tmpData != nil) {
            [tmpData copyFromIndex:0 withSource:uid_ withSourceIndex:0 withLength:(int)(tmpData.length)];
            [self setUid:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        tmpData = [[NSMutableData alloc] initWithSize:(int)(salt_.length)];
        if (tmpData != nil) {
            [tmpData copyFromIndex:0 withSource:salt_ withSourceIndex:0 withLength:(int)(tmpData.length)];
            [self setSalt:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        tmpData = [[NSMutableData alloc] initWithSize:(int)(ephemeralKey_.length)];
        if (tmpData != nil) {
            [tmpData copyFromIndex:0 withSource:ephemeralKey_ withSourceIndex:0 withLength:(int)(tmpData.length)];
            [self setEphemeralKey:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        return self;
    } else {
        return nil;
    }
}

- (id)init:(NSMutableData*)tag_ withUid:(NSMutableData*)uid_ withSalt:(NSMutableData*)salt_ withEphemeralKey:(NSMutableData*)ephemeralKey_ {
    if (self = [self init:0 withTag:tag_ withUid:uid_ withSalt:salt_ withEphemeralKey:ephemeralKey_]) {
        return self;
    } else {
        return nil;
    }
}

- (id)init:(DataStream *)blob {
    if (self = [super init]) {
        int length = [blob getInt];
        if (length != blob.limit) {
            NSLog(@"BlobA4() - bad length: 0x%X", length);
        }
        
        int type = [blob getInt];
        if (type != 0x000000A4) {
            NSLog(@"BlobA4() - unexpected type: 0x%X", type);
        }
        
        self.x = [blob getInt];
        if (self.x != 0) {
            // Unsure of x, possibly offset. Only ever noted 0 value.
            NSLog(@"BlobA4() - non-zero x: 0x%X", self.x);
        }
        
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:0x10];
        if (tmpData != nil) {
            [self setTag:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        [blob getWithMutableData:self.tag];
        
        NSMutableArray *list = [BlobLists importList:blob];
        if (list.count < 3) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"too few blob fields: %ld", (unsigned long)list.count] userInfo:nil];
        }
        [self setUid:[list objectAtIndex:0]];
        [self setSalt:[list objectAtIndex:1]];
        [self setEphemeralKey:[list objectAtIndex:2]];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_tag != nil) [_tag release]; _tag = nil;
    if (_uid != nil) [_uid release]; _uid = nil;
    if (_salt != nil) [_salt release]; _salt = nil;
    if (_ephemeralKey != nil) [_ephemeralKey release]; _ephemeralKey = nil;
    [super dealloc];
#endif
}

- (NSMutableData*)getTag {
    NSMutableData *retData  = nil;
    if ([self tag]) {
        retData = [Arrays copyOfWithData:[self tag] withNewLength:(int)([self tag].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getUid {
    NSMutableData *retData  = nil;
    if ([self uid]) {
        retData = [Arrays copyOfWithData:[self uid] withNewLength:(int)([self uid].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getSalt {
    NSMutableData *retData  = nil;
    if ([self salt]) {
        retData = [Arrays copyOfWithData:[self salt] withNewLength:(int)([self salt].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getEphemeralKey {
    NSMutableData *retData  = nil;
    if ([self ephemeralKey]) {
        retData = [Arrays copyOfWithData:[self ephemeralKey] withNewLength:(int)([self ephemeralKey].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

@end

@interface BlobA5 ()

@property (nonatomic, readwrite, assign) int x;
@property (nonatomic, readwrite, retain) NSMutableData *tag;
@property (nonatomic, readwrite, retain) NSMutableData *uid;
@property (nonatomic, readwrite, retain) NSMutableData *message;

@end

@implementation BlobA5
@synthesize x = _x;
@synthesize tag = _tag;
@synthesize uid = _uid;
@synthesize message = _message;

- (id)init:(int)x_ withTag:(NSMutableData*)tag_ withUid:(NSMutableData *)uid_ withMessage:(NSMutableData *)message_ {
    if (self = [self init]) {
        if (tag_.length != 0x10) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"bad tag 0x%@", [tag_ dataToHex]] userInfo:nil];
        }
        
        self.x = x_;
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:0x10];
        if (tmpData != nil) {
            [tmpData copyFromIndex:0 withSource:tag_ withSourceIndex:0 withLength:(int)tmpData.length];
            [self setTag:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        [NSObject checkNotNull:uid_ withName:@"uid"];
        [self setUid:uid_];
        [NSObject checkNotNull:message_ withName:@"message"];
        [self setMessage:message_];
        return self;
    } else {
        return nil;
    }
}

- (id)init:(NSMutableData *)tag_ withUid:(NSMutableData *)uid_ withMessage:(NSMutableData *)message_ {
    if (self = [self init:0 withTag:tag_ withUid:uid_ withMessage:message_]) {
        return self;
    } else {
        return nil;
    }
}

- (id)init:(DataStream *)blob {
    if (self = [super init]) {
        int length = [blob getInt];
        if (length != blob.limit) {
            NSLog(@"BlobA5() - bad length: 0x%X", length);
        }
        
        int type = [blob getInt];
        if (type != 0x000000A5) {
            NSLog(@"BlobA5() - unexpected type: 0x%X", type);
        }
        self.x = [blob getInt];
        if (self.x != 0) {
            // Unsure of x, possibly offset. Only ever noted 0 value.
            NSLog(@"BlobA5() - non-zero x: 0x%X", self.x);
        }
        
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:0x10];
        if (tmpData != nil) {
            [self setTag:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        [blob getWithMutableData:self.tag];
        
        NSMutableArray *list = [BlobLists importList:blob];
        if (list.count < 2) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"too few blob fields: %ld", (unsigned long)list.count] userInfo:nil];
        }
        [self setUid:[list objectAtIndex:0]];
        [self setMessage:[list objectAtIndex:1]];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setTag:nil];
    [self setUid:nil];
    [self setMessage:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)getTag {
    NSMutableData *retData = nil;
    if ([self tag]) {
        retData = [Arrays copyOfWithData:[self tag] withNewLength:(int)([self tag].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getUid {
    NSMutableData *retData = nil;
    if ([self uid]) {
        retData = [Arrays copyOfWithData:[self uid] withNewLength:(int)([self uid].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)getMessage {
    NSMutableData *retData = nil;
    if ([self message]) {
        retData = [Arrays copyOfWithData:[self message] withNewLength:(int)([self message].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (DataStream*)exportDataStream {
    NSMutableArray *list = [NSMutableArray arrayWithObjects:self.uid, self.message, nil];
    int size = 0x1C + [BlobLists exportListSize:list];
    
    DataStream *blob = [[[DataStream alloc] initWithAllocateSize:size] autorelease];
    
    [blob putInt:size];
    [blob putInt:0x000000A5];
    [blob putInt:self.x];
    [blob putWithData:self.tag];
    
    [BlobLists exportList:blob withDataList:list];
    if (blob.position != size) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"error creating blob" userInfo:nil];
    }
    
    [blob rewind];
    
    return blob;
}

@end

@interface BlobA6 ()

@property (nonatomic, readwrite, assign) int x;
@property (nonatomic, readwrite, retain) NSMutableData *tag;
@property (nonatomic, readwrite, retain) BlobLists *list;

@end

@implementation BlobA6
@synthesize x = _x;
@synthesize tag = _tag;
@synthesize list = _list;

- (id)init:(DataStream *)blob {
    if (self = [super init:blob]) {
        if ([self type] != 0x000000A6) {
            NSLog(@"BlobA6() - unexpected type: 0x%X", [self type]);
        }
        
        self.x = [blob getInt];
        NSMutableData *tmpData = [[NSMutableData alloc] initWithSize:0x10];
        if (tmpData != nil) {
            [self setTag:tmpData];
#if !__has_feature(objc_arc)
            if (tmpData) [tmpData release]; tmpData = nil;
#endif
        }
        [blob getWithMutableData:self.tag];
        [BlobUtils alignWithDataStream:blob];
        
        BlobLists *tmpList =  [[BlobLists alloc] init:blob];
        if (tmpList != nil) {
            [self setList:tmpList];
#if !__has_feature(objc_arc)
            if (tmpList) [tmpList release]; tmpList = nil;
#endif
        }
        if (self.list == nil || [self.list size] < 3) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:[NSString stringWithFormat:@"too few blob fields: %d", [self.list size]] userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setTag:nil];
    [self setList:nil];
    [super dealloc];
#endif
}

- (NSMutableData*)getTag {
    NSMutableData *retData = nil;
    if ([self tag]) {
        retData = [Arrays copyOfWithData:[self tag] withNewLength:(int)([self tag].length)];
    }
    return (retData ? [retData autorelease] : nil);
}

- (NSMutableData*)m2 {
    return [self.list get:0];
}

- (NSMutableData*)iv {
    return [self.list get:1];
}

- (NSMutableData*)data {
    return [self.list get:2];
}

@end