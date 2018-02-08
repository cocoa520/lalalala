//
//  Blob.h
//  
//
//  Created by Pallas on 4/11/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class BlobHeader;
@class DataStream;
@class BlobLists;

@interface BlobBase : NSObject {
@private
    BlobHeader *                    _header;
}

- (id)init:(DataStream*)blob;

- (int)type;
- (int)length;

@end

@interface BlobHeader : NSObject {
@private
    int                             _length;
    int                             _type;
}

- (id)init:(DataStream*)blob;

- (int)length;
- (int)type;

@end

@interface BlobA0 : BlobBase {
@private
    int                             _x;
    int                             _iterations;
    int                             _y;
    BlobLists *                     _list;
    NSString *                      _label;
    NSString *                      _timestamp;
}

@property (nonatomic, readwrite, assign) int iterations;
@property (nonatomic, readwrite, retain) NSString *label;
@property (nonatomic, readwrite, retain) NSString *timestamp;

- (id)init:(DataStream *)blob;

- (NSMutableData*)dsid;
- (NSMutableData*)salt;
- (NSMutableData*)key;
- (NSMutableData*)data;

@end

@interface BlobA4 : NSObject {
@private
    int                             _x;
    NSMutableData *                 _tag;
    NSMutableData *                 _uid;
    NSMutableData *                 _salt;
    NSMutableData *                 _ephemeralKey;
}

- (id)init:(int)x_ withTag:(NSMutableData*)tag_ withUid:(NSMutableData*)uid_ withSalt:(NSMutableData*)salt_ withEphemeralKey:(NSMutableData*)ephemeralKey_;
- (id)init:(NSMutableData*)tag_ withUid:(NSMutableData*)uid_ withSalt:(NSMutableData*)salt_ withEphemeralKey:(NSMutableData*)ephemeralKey_;
- (id)init:(DataStream *)blob;

- (NSMutableData*)getTag;
- (NSMutableData*)getUid;
- (NSMutableData*)getSalt;
- (NSMutableData*)getEphemeralKey;

@end

@interface BlobA5 : NSObject {
@private
    int                             _x;
    NSMutableData *                 _tag;
    NSMutableData *                 _uid;
    NSMutableData *                 _message;
}

- (id)init:(int)x_ withTag:(NSMutableData*)tag_ withUid:(NSMutableData *)uid_ withMessage:(NSMutableData *)message_;
- (id)init:(NSMutableData *)tag_ withUid:(NSMutableData *)uid_ withMessage:(NSMutableData *)message_;
- (id)init:(DataStream *)blob;

- (NSMutableData*)getTag;
- (NSMutableData*)getUid;
- (NSMutableData*)getMessage;

- (DataStream*)exportDataStream;

@end

@interface BlobA6 : BlobBase {
@private
    int                             _x;
    NSMutableData *                 _tag;
    BlobLists *                     _list;
}

- (id)init:(DataStream *)blob;

- (NSMutableData*)getTag;
- (NSMutableData*)m2;
- (NSMutableData*)iv;
- (NSMutableData*)data;

@end