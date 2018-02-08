//
//  AuthorizedAssets.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "AuthorizedAssets.h"
#import "AssetEx.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"

@interface AuthorizedAssets ()

@property (nonatomic, readwrite, retain) FileGroups *fileGroups;
@property (nonatomic, readwrite, retain) NSDictionary *assets;

@end

@implementation AuthorizedAssets
@synthesize fileGroups = _fileGroups;
@synthesize assets = _assets;

+ (AuthorizedAssets*)empty {
    static AuthorizedAssets *_empty = nil;
    @synchronized(self) {
        if (_empty == nil) {
            FileGroups_Builder *builder = [FileGroups builder];
            NSDictionary *emptyDict = [[NSDictionary alloc] init];
            _empty = [[AuthorizedAssets alloc] initWithFileGroups:[builder build] withAssets:emptyDict];
#if !__has_feature(objc_arc)
            if (emptyDict != nil) [emptyDict release]; emptyDict = nil;
#endif
        }
    }
    return _empty;
}

+ (NSDictionary*)copyWithDictionary:(NSDictionary*)assets {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSEnumerator *iterator = [assets keyEnumerator];
    NSData *key = nil;
    while (key = [iterator nextObject]) {
        NSArray *value = [assets objectForKey:key];
        if (value != nil && value.count > 0) {
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            [tmpArray addObjectsFromArray:value];
            [retDict setObject:tmpArray forKey:key];
#if !__has_feature(objc_arc)
            if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
        }
    }
    return retDict;
}

- (id)initWithFileGroups:(FileGroups*)fileGroups withAssets:(NSDictionary*)assets {
    if (self = [super init]) {
        if (fileGroups == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"fileGroups" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setFileGroups:fileGroups];
        [self setAssets:[AuthorizedAssets copyWithDictionary:assets]];
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_fileGroups != nil) [_fileGroups release]; _fileGroups = nil;
    if (_assets != nil) [_assets release]; _assets = nil;
    [super dealloc];
#endif
}

- (AssetEx*)asset:(NSString*)fileSignature {
    if ([[self assets].allKeys containsObject:fileSignature]) {
        id obj = [[self assets] objectForKey:fileSignature];
        if (obj != nil && [obj isKindOfClass:[NSArray class]]) {
            return [(NSArray*)obj objectAtIndex:0];
        }
    }
    return nil;
}

- (NSMutableArray*)assets:(NSString*)fileSignature {
    if ([[self assets].allKeys containsObject:fileSignature]) {
        id obj = [[self assets] objectForKey:fileSignature];
        if (obj != nil && [obj isKindOfClass:[NSArray class]]) {
            return [[[NSMutableArray alloc] initWithArray:(NSArray*)obj] autorelease];
        }
    }
    return nil;
}

- (NSMutableArray*)getAssets {
    return [[[NSMutableArray alloc] initWithArray:[[self assets] allValues]] autorelease];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"AuthorizedAssets{ fileGroups = %@, assets = %@}", [[self fileGroups] description], [[self assets] description]];
}

@end
