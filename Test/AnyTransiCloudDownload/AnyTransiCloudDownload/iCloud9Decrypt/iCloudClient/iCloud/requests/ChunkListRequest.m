//
//  ChunkListRequest.m
//  
//
//  Created by iMobie on 8/8/16.
//
//  Complete

#import "ChunkListRequest.h"
#import "ChunkServer.pb.h"
//#import "ChunkServer.h"

@implementation ChunkListRequest

+ (ChunkListRequest*)instance {
    static ChunkListRequest *_instance = nil;
    @synchronized(self) {
        _instance = [[ChunkListRequest alloc] init];
    }
    return _instance;
}

- (NSMutableURLRequest*)apply:(StorageHostChunkList*)storageHostChunkList {
    HostInfo *hostInfo = [storageHostChunkList hostInfo];
    NSString *uri = [NSString stringWithFormat:@"%@://%@%@", [hostInfo scheme], [hostInfo hostname], [hostInfo uri]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uri]];
    [urlRequest setHTTPMethod:[hostInfo method]];
    
    NSArray *headers = [hostInfo headersList];
    NSEnumerator *iterator = [headers objectEnumerator];
    NameValuePair *header = nil;
    while (header = [iterator nextObject]) {
        [urlRequest addValue:[header value] forHTTPHeaderField:[header name]];
    }
    return urlRequest;
}

@end
