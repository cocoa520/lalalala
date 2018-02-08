//
//  ChunkClient.m
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "ChunkClient.h"
#import "ChunkListRequest.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"
#import "HttpClient.h"
#import "CommonDefine.h"

@implementation ChunkClient

- (id)init {
#if !__has_feature(objc_arc)
    [self release];
#endif
    return nil;
}

+ (NSMutableData*)fetch:(StorageHostChunkList*)chunkList {
    ChunkListRequest *chunkListRequest = [ChunkListRequest instance];
    return [ChunkClient fetch:chunkList withChunkListRequest:chunkListRequest];
}

+ (NSMutableData*)fetch:(StorageHostChunkList*)chunkList withChunkListRequest:(ChunkListRequest*)chunkListRequest {
    @try {
        NSMutableURLRequest *request = [chunkListRequest apply:chunkList];
        NSMutableData *tmpData = [HttpClient execute:request];
        if (!tmpData) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
        }
        return tmpData;
    }
    @catch (NSException *exception) {
        NSLog(@"-- fetch() - Exception: %@", [exception reason]);
        return nil;
    }
}

@end
