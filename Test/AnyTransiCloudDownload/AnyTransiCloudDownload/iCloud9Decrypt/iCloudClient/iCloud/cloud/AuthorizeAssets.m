//
//  AuthorizeAssets.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "AuthorizeAssets.h"
#import "AssetEx.h"
#import "AuthorizedAssets.h"
#import "AuthorizeGetRequest.h"
#import "CategoryExtend.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"
#import "CloudKit.pb.h"
#import "FileTokensFactory.h"
#import "HttpClient.h"
#import "CommonDefine.h"

@interface AuthorizeAssets ()

@property (nonatomic, readwrite, retain) NSString *container;
@property (nonatomic, readwrite, retain) NSString *zone;

@end

@implementation AuthorizeAssets
@synthesize container = _container;
@synthesize zone = _zone;

+ (AuthorizeAssets*)backupd {
    static AuthorizeAssets *_backupd = nil;
    @synchronized(self) {
        if (_backupd == nil) {
            _backupd = [[AuthorizeAssets alloc] initWithContainer:@"com.apple.backup.ios"];
        }
    }
    return _backupd;
}

- (id)initWithContainer:(NSString*)container withZone:(NSString*)zone {
    if (self = [super init]) {
        if (container == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"container" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (zone == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"zone" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setContainer:container];
        [self setZone:zone];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithContainer:(NSString*)container {
    if (self = [self initWithContainer:container withZone:@"_defaultZone"]) {
        return self;
    } else {
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_container != nil) [_container release]; _container = nil;
    if (_zone != nil) [_zone release]; _zone = nil;
    [super dealloc];
#endif
}

- (AuthorizedAssets*)authorize:(NSArray*)assets {
    NSDictionary *downloadables = [self downloadables:assets];
    
    // Duplicate file signatures indicate duplicate files.
    // Primary asset is downloaded, others are copied.
    // Voodoo will is undefined for duplicate file signatures.
    NSArray *primaryAssets = [self primaryAsset:downloadables];
    
    NSArray *ckAssets = [self ckAssets:primaryAssets];
    
    if (ckAssets == nil || ckAssets.count == 0) {
        return [AuthorizedAssets empty];
    }
    
    // Should be the same for all assets. Assumption not tested.
    NSString *dsPrsID = [(Asset*)[ckAssets objectAtIndex:0] dsPrsId];
    NSString *contentBaseUrl = [(Asset*)[ckAssets objectAtIndex:0] contentBaseUrl];
    
    FileTokens *fileTokens = [FileTokensFactory fromWithArray:ckAssets];
    
    FileGroups *fileGroups = nil;
    @try {
        fileGroups = [self authorizeGet:dsPrsID withContentBaseUrl:contentBaseUrl withFileTokens:fileTokens];
    }
    @catch (NSException *exception) {
        return nil;
    }
    return [[[AuthorizedAssets alloc] initWithFileGroups:fileGroups withAssets:downloadables] autorelease];
}

- (FileGroups*)authorizeGet:(NSString*)dsPrsID withContentBaseUrl:(NSString*)contentBaseUrl withFileTokens:(FileTokens*)fileTokens {
    NSMutableURLRequest *fileGroups =  [[AuthorizeGetRequest instance] newRequest:dsPrsID withContentBaseUrl:contentBaseUrl withContainer:[self container] withZone:[self zone] withFileTokens:fileTokens];
    if (fileGroups == nil) {
        NSLog(@"-- authorizeGet() - no file groups");
        return [[FileGroups builder] build];
    }
    
    NSData *responsedData = [HttpClient execute:fileGroups];
    if (responsedData == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
        return nil;
    }
    
    return [FileGroups parseFromData:responsedData];
}

- (NSArray*)ckAssets:(NSArray*)assets {
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    NSEnumerator *iterator = [assets objectEnumerator];
    AssetEx *asset = nil;
    while (asset = [iterator nextObject]) {
        Asset *tmpAssert = [asset asset];
        if (tmpAssert != nil) {
            [retArray addObject:tmpAssert];
        }
    }
    return retArray;
}

- (NSArray*)primaryAsset:(NSDictionary*)fileSignaturetoAssetList {
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    NSEnumerator *iterator = [fileSignaturetoAssetList keyEnumerator];
    NSString *byteString = nil;
    while (byteString = [iterator nextObject]) {
        NSArray *value = [fileSignaturetoAssetList objectForKey:byteString];
        if (value != nil && value.count > 0) {
            [retArray addObject:[value objectAtIndex:0]];
        }
    }
    return retArray;
}

- (NSDictionary*)downloadables:(NSArray*)assets {
    NSMutableDictionary *retDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSEnumerator *iterator = [assets objectEnumerator];
    AssetEx *asset = nil;
    NSMutableArray *tmpArray = nil;
    while (asset = [iterator nextObject]) {
        if ([self isDownloadable:asset]) {
            NSString *byteString = [NSString dataToHex:[asset getFileSignature]];
            if (![retDict.allKeys containsObject:byteString]) {
                tmpArray = [[NSMutableArray alloc] init];
                [retDict setObject:tmpArray forKey:byteString];
#if !__has_feature(objc_arc)
                if (tmpArray != nil) [tmpArray release]; tmpArray = nil;
#endif
            }
            tmpArray = [retDict objectForKey:byteString];
            [tmpArray addObject:asset];
        }
    }
    return retDict;
}

- (BOOL)isDownloadable:(AssetEx*)asset {
    // TODO verify then simplify/ remove logging statements
    if (asset.size == 0) {
        return NO;
    }
    if ([asset getFileSignature] == nil) {
        return NO;
    }
    if ([asset getKeyEncryptionKey] == nil) {
        return NO;
    }
    if ([asset domain] == nil) {
        return NO;
    }
    if ([asset relativePath] == nil) {
        return NO;
    }
    return YES;
}

@end
