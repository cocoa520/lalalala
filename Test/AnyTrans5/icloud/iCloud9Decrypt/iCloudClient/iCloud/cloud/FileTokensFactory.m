//
//  FileTokensFactory.m
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import "FileTokensFactory.h"
#import "CloudKit.pb.h"

@implementation FileTokensFactory

+ (FileTokens*)from:(Asset*)asset,... {
    NSMutableArray *argArray = [[NSMutableArray alloc] init];
    va_list argList;
    Asset *arg = nil;
    if (asset != nil) {
        va_start(argList, asset);
        [argArray addObject:asset];
        while((arg = va_arg(argList, Asset*))) {
            [argArray addObject:arg];
        }
        va_end(argList);
    }
    FileTokens *retObj = [FileTokensFactory fromWithArray:argArray];
#if !__has_feature(objc_arc)
    if (argArray != nil) [argArray release]; argArray = nil;
#endif
    return retObj;
}

+ (FileTokens*)fromWithArray:(NSArray*)assets {
    if (assets != nil && assets.count > 0) {
        NSEnumerator *iterator = [assets objectEnumerator];
        Asset *asset = nil;
        FileTokens_Builder *builder = [FileTokens builder];
        while (asset = [iterator nextObject]) {
            [builder addFileTokens:[FileTokensFactory fileToken:asset]];
        }
        return [builder build];
    }
    return nil;
}

+ (FileToken*)fileToken:(Asset*)asset {
    return [FileTokensFactory fileToken:[asset fileChecksum] withFileSignature:[asset fileSignature] withDownloadToken:[asset downloadToken]];
}

+ (FileToken*)fileToken:(NSData*)fileChecksum withFileSignature:(NSData*)fileSignature withDownloadToken:(NSString*)downloadToken {
    FileToken_Builder *builder = [FileToken builder];
    [builder setFileChecksum:fileChecksum];
    [builder setFileSignature:fileSignature];
    [builder setToken:downloadToken];
    return [builder build];
}

@end
