//
//  IOSequenceStream.h
//  
//
//  Created by Pallas on 8/30/16.
//
//  Complete

#import "CategoryExtend.h"

@interface IOSequenceStream : Stream {
@private
    NSMutableArray *                        _streams;
    NSEnumerator *                          _it;
    NSFileHandle *                          _is;
}

- (id)initWithEnumerator:(NSEnumerator*)streams;
- (id)initWithStreams:(NSMutableArray*)streams;

@end
