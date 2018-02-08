//
//  AssetDownloader.h
//  
//
//  Created by Pallas on 7/25/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class AuthorizedAssets;
@class ChunkEngine;

@interface AssetDownloader : NSObject {
@private
    ChunkEngine *                           _chunkEngine;
    uint64_t                                _completeSize;
    
    id                                      _progressTarget;
    SEL                                     _progressSelector;
    IMP                                     _progressImp;
@public
    uint64_t                                _totalSize;
}

@property (nonatomic, readwrite, assign) uint64_t totalSize;

- (void)setProgressTarget:(id)progressTarget;
- (void)setProgressSelector:(SEL)progressSelector;
- (void)setProgressImp:(IMP)progressImp;

- (void)setTotalSize:(uint64_t)totalSize;

- (id)initWithChunkEngine:(ChunkEngine*)chunkEngine;

- (void)get:(AuthorizedAssets*)assets withTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withCancel:(BOOL*)cancel;

@end