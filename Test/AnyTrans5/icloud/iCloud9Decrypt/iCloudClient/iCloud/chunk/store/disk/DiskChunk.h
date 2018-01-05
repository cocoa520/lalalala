//
//  DiskChunk.h
//  
//
//  Created by Pallas on 8/8/16.
//
//  Complete

#import "Chunk.h"
#import "ChunkBuilder.h"

@interface DiskChunk : Chunk {
@private
    NSMutableData *                 _checksum;
    NSString *                      _file;
}

- (id)initWithChecksum:(NSMutableData*)checksum withFile:(NSString*)file;

@end

@interface Builder : ChunkBuilder {
@private
    NSMutableData *                 _checksum;
    NSString *                      _file;
    NSFileHandle *                  _outputStream;
}

- (id)initWithChecksum:(NSMutableData*)checksum withFile:(NSString*)file;

@end
