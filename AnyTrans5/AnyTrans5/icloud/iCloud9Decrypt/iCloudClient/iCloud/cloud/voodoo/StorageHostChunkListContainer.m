//
//  StorageHostChunkListContainer.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "StorageHostChunkListContainer.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"

@interface StorageHostChunkListContainer ()

@property (nonatomic, readwrite, retain) StorageHostChunkList *storageHostChunkList;
@property (nonatomic, readwrite, assign) int container;

@end

@implementation StorageHostChunkListContainer
@synthesize storageHostChunkList = _storageHostChunkList;
@synthesize container = _container;

- (id)initWithStorageHostChunkList:(StorageHostChunkList*)storageHostChunkList withContainer:(int)container {
    if (self = [super init]) {
        if (storageHostChunkList == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"storageHostChunkList" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setStorageHostChunkList:storageHostChunkList];
        [self setContainer:container];
        return self;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return [self retain];
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_storageHostChunkList != nil) [_storageHostChunkList release]; _storageHostChunkList = nil;
    [super dealloc];
#endif
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (object == nil) {
        return NO;
    }
    if ([self class] != [object class]) {
        return NO;
    }
    StorageHostChunkListContainer *other = (StorageHostChunkListContainer*)object;
    if (self.container != other.container) {
        return NO;
    }
    if (![[self storageHostChunkList] isEqual:[other storageHostChunkList]]) {
        return NO;
    }
    return YES;
}

@end
