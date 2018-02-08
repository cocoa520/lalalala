//
//  FileAssembler.m
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import "FileAssembler.h"
#import "AssetEx.h"
#import "Chunk.h"
#import "DigestInputStream.h"
#import "InputReferenceStream.h"
#import "FilePath.h"
#import "FileSignatures.h"
#import "FileTruncater.h"
#import "FileDecrypterInputStreams.h"
#import "CategoryExtend.h"
#import "XFileKey.h"
#import "FileStreamWriter.h"
#import "IOSequenceStream.h"

@interface FileAssembler ()

@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite, assign) SEL selector;
@property (nonatomic, readwrite, assign) IMP imp;
@property (nonatomic, readwrite, retain) FilePath *filePath;

@end

@implementation FileAssembler
@synthesize target = _target;
@synthesize selector = _selector;
@synthesize imp = _imp;
@synthesize filePath = _filePath;

+ (int)BUFFER_SIZE {
    return 16384;
}

- (id)initWithTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withFilePath:(FilePath*)filePath {
    if (self = [super init]) {
        if (target == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"target" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        if (filePath == nil) {
            @throw [NSException exceptionWithName:@"NullPointer" reason:@"filePath" userInfo:nil];
#if !__has_feature(objc_arc)
            [self release];
#endif
            return nil;
        }
        [self setTarget:target];
        [self setSelector:selector];
        [self setImp:imp];
        [self setFilePath:filePath];
        return self;
    } else {
        return nil;
    }
}

- (id)initWithTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withOutputFolder:(NSString*)outputFolder {
    FilePath *tmpFP = [[FilePath alloc] initWithOutputFolder:outputFolder];
    if (self = [self initWithTarget:target withSelector:selector withImp:imp withFilePath:tmpFP]) {
#if !__has_feature(objc_arc)
        if (tmpFP != nil) [tmpFP release]; tmpFP = nil;
#endif
        return self;
    } else {
#if !__has_feature(objc_arc)
        if (tmpFP != nil) [tmpFP release]; tmpFP = nil;
        [self release];
#endif
        return nil;
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [self setFilePath:nil];
    [super dealloc];
#endif
}

- (void)accept:(AssetEx*)asset withChunks:(NSMutableArray*)chunks withCompleteSize:(uint64_t*)completeSize withCancel:(BOOL*)cancel {
    if (*cancel) {
        return;
    }
    
    @autoreleasepool {
        BOOL test = [self test:asset withChunks:chunks withCancel:cancel];
        if (!test) {
            NSLog(@"-- accept() - failed to write asset: %@", [asset relativePath]);
        }
    }
    *completeSize += asset.size;
}

- (BOOL)test:(AssetEx*)asset withChunks:(NSMutableArray*)chunks withCancel:(BOOL*)cancel {
//    NSString *filePath = [[self filePath] apply:asset];
//    NSString *parentDir = [filePath getParentDirectory];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    BOOL createRet = YES;
//    if (![fm fileExistsAtPath:parentDir]) {
//        createRet = [fm createDirectoryAtPath:parentDir withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    BOOL success = NO;
//    if (createRet) {
//        success = [self encryptionkeyOp:filePath asset:asset chunks:chunks];
//    }
    if (*cancel) {
        return NO;
    }
    BOOL success = (chunks && chunks.count > 0) ? [self assemble:asset withChunks:chunks withCancel:cancel] : [self fail:asset];
    return success;
}

- (BOOL)fail:(AssetEx*)asset {
    NSLog(@"-- %@ failed", [self info:asset]);
    return NO;
}

- (BOOL)assemble:(AssetEx*)asset withChunks:(NSMutableArray*)chunks withCancel:(BOOL*)cancel {
    if (*cancel) {
        return NO;
    }
    NSString *filePath = [[self filePath] apply:asset];
    NSString *parentDir = [filePath getParentDirectory];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL ret = YES;
    if (![fm fileExistsAtPath:parentDir]) {
        ret = [fm createDirectoryAtPath:parentDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (ret) {
        ret = [self assemble:filePath withAsset:asset withChunks:chunks withCancel:cancel];
        if (ret) {
            ret = [FileTruncater truncate:filePath withAsset:asset];
        }
    }
    return ret;
}

- (BOOL)assemble:(NSString*)path withAsset:(AssetEx*)asset withChunks:(NSMutableArray*)chunks withCancel:(BOOL*)cancel {
    if (*cancel) {
        return NO;
    }
    NSString *info = [self info:asset];
    BOOL retVal = NO;
    NSMutableData *u = [asset getEncryptionKey];
    if (u) {
        retVal = [self decrypt:path withInfo:info withChunks:chunks withEncryptionKey:u withSignature:[asset getFileChecksum] withCancel:cancel];
    } else {
        retVal = [self write:path withInfo:info withChunks:chunks withKeyCipher:nil withSignature:[asset getFileChecksum] withCancel:cancel];
    }
    return retVal;
}

- (BOOL)decrypt:(NSString*)path withInfo:(NSString*)info withChunks:(NSMutableArray*)chunks withEncryptionKey:(NSMutableData*)encryptionKey withSignature:(NSMutableData*)signature withCancel:(BOOL*)cancel {
    if (*cancel) {
        return NO;
    }
    BOOL retVal = NO;
    typedef XFileKey* (*MethodName)(id, SEL, NSMutableData*);
    MethodName methodName = (MethodName)[self imp];
    XFileKey *xfk = methodName([self target], [self selector], encryptionKey);
    if (xfk) {
        retVal = [self write:path withInfo:info withChunks:chunks withKeyCipher:xfk withSignature:signature withCancel:cancel];
    } else {
        retVal = NO;
    }
    return retVal;
}

- (BOOL)write:(NSString*)path withInfo:(NSString*)info withChunks:(NSMutableArray*)chunks withKeyCipher:(XFileKey*)keyCipher withSignature:(NSMutableData*)signature withCancel:(BOOL*)cancel {
    if (*cancel) {
        return NO;
    }
    @try {
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:path]) {
            [fm removeItemAtPath:path error:nil];
        }
        BOOL ret = [fm createFileAtPath:path contents:nil attributes:nil];
        BOOL status = NO;
        if (ret) {
            NSFileHandle *outputStream =[NSFileHandle openPath:path withAccess:OpenWrite];
            Stream *inputStream = [self chunkStream:chunks withCancel:cancel];
            
            status = [FileStreamWriter copy:inputStream withOutStream:outputStream withKeyCipher:keyCipher withSignature:signature withCancel:cancel];
            [outputStream closeFile];
        }
        return status;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

- (Stream*)chunkStream:(NSMutableArray*)chunks withCancel:(BOOL*)cancel {
    // Changed from java.io.SequenceInputStream which required open InputStreams as this was causing 'Too many open
    // files' exceptions on assets with huge numbers of chunks.
    if (*cancel) {
        return nil;
    }
    NSMutableArray *suppliers = [[NSMutableArray alloc] init];
    NSEnumerator *iterator = [chunks objectEnumerator];
    Chunk *chunk = nil;
    while (chunk = [iterator nextObject]) {
        if (*cancel) {
            break;
        }
        [suppliers addObject:[chunk inputStream]];
    }
    IOSequenceStream *retStream = nil;
    if (!(*cancel)) {
        retStream = [[[IOSequenceStream alloc] initWithStreams:suppliers] autorelease];
    }
#if !__has_feature(objc_arc)
    if (suppliers) [suppliers release]; suppliers = nil;
#endif
    return retStream;
}

- (NSString*)info:(AssetEx*)asset {
    return [NSString stringWithFormat:@"%@ %@", ([NSString isNilOrEmpty:[asset domain]] ? @"" : [asset domain]), ([NSString isNilOrEmpty:[asset relativePath]] ? @"" : [asset relativePath])];
}

- (BOOL)encryptionkeyOp:(NSString*)path asset:(AssetEx*)asset chunks:(NSMutableArray*)chunks withCancel:(BOOL*)cancel {
    BOOL result = false;
    NSMutableData *wrappedKey = [asset getEncryptionKey];
    if (wrappedKey) {
        result = [self unwrapKeyOp:path asset:asset chunks:chunks wrappedKey:wrappedKey withCancel:cancel];
    }else {
        result = [self assemble:path chunks:chunks decryptKey:nil fileChecksum:[asset getFileChecksum] withCancel:cancel];
    }
    return result;
}

- (BOOL)unwrapKeyOp:(NSString*)path asset:(AssetEx*)asset chunks:(NSMutableArray*)chunks wrappedKey:(NSMutableData*)wrappedKey withCancel:(BOOL*)cancel {
    BOOL orElse = NO;
    typedef NSMutableData* (*MethodName)(id, SEL, NSMutableData*, int);
    MethodName methodName = (MethodName)[self imp];
    NSMutableData *key = methodName([self target], [self selector], wrappedKey, [asset protectionClass]);
    if (key != nil) {
        orElse = [self assemble:path chunks:chunks decryptKey:key fileChecksum:[asset getFileChecksum] withCancel:cancel];
    } else {
        orElse = NO;
    }
    return orElse;
}

- (BOOL)assemble:(NSString*)path chunks:(NSMutableArray*)chunks decryptKey:(NSMutableData*)decryptKey fileChecksum:(NSMutableData*)fileChecksum withCancel:(BOOL*)cancel {
    @autoreleasepool {
        @try {
            InputReferenceStream *inStream = [self chain:chunks decryptKey:decryptKey fileChecksum:fileChecksum withCancel:cancel];
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:path]) {
                [fm removeItemAtPath:path error:nil];
            }
            BOOL ret = [fm createFileAtPath:path contents:nil attributes:nil];
            if (ret) {
                NSFileHandle *outputStream =[NSFileHandle openPath:path withAccess:OpenWrite];
                NSMutableData *buffer = [[NSMutableData alloc] initWithSize:[FileAssembler BUFFER_SIZE]];
                while (YES) {
                    if (*cancel) {
                        break;
                    }
                    int length = [inStream read:buffer withOff:0 withLen:(int)(buffer.length)];
                    if (length <= 0) {
                        break;
                    }
                    [outputStream write:buffer withOffset:0 withCount:length];
                    [outputStream flush];
                }
                [outputStream closeFile];
#if !__has_feature(objc_arc)
                if (buffer) [buffer release]; buffer = nil;
#endif
            }
            
            BOOL status = NO;
            if ([fileChecksum length] > 0) {
                status = [self testFileChecksum:fileChecksum digestInputStream:[inStream reference]];
                return status;
            }else {
                return YES;
            }
            
        }
        @catch (NSException *exception) {
            return NO;
        }
    }
}

- (InputReferenceStream*)chain:(NSMutableArray*)chunks decryptKey:(NSMutableData*)decryptKey fileChecksum:(NSMutableData*)fileChecksum withCancel:(BOOL*)cancel {
    Stream *one = [self fileData:chunks withCancel:cancel];
    
    DigestInputStream *digestInputStream = nil;
    if (fileChecksum) {
        digestInputStream = [FileSignatures like:one fileSignature:fileChecksum];
    }
    Stream *two = nil;
    if (digestInputStream) {
        two = (Stream*)digestInputStream;
    }else {
        two = one;
    }
    
    Stream *three = nil;
    if (decryptKey) {
        three = (Stream*)[FileDecrypterInputStreams create:two key:decryptKey];
    }else {
        three = two;
    }
    return [[[InputReferenceStream alloc] initWithInputStream:three reference:digestInputStream] autorelease];
}

- (Stream*)fileData:(NSMutableArray*)chunks withCancel:(BOOL*)cancel {
    MemoryStreamEx *bufferStream = [MemoryStreamEx memoryStreamEx];
    NSEnumerator *iterator = [chunks objectEnumerator];
    Chunk *chunk = nil;
    NSMutableData *copyBuffer = [[NSMutableData alloc] initWithSize:8192];
    while (chunk = [iterator nextObject]) {
        if (*cancel) {
            break;
        }
       NSFileHandle *input = [chunk inputStream];
        while (YES) {
            if (*cancel) {
                break;
            }
            int length = [input read:copyBuffer withOffset:0 withCount:(int)(copyBuffer.length)];
            if (length <= 0) {
                break;
            }
            [bufferStream write:copyBuffer withOffset:0 withCount:length];
        }
        [input closeFile];
    }
    [bufferStream seek:0 withOrigin:Begin];
    return bufferStream;
}

- (BOOL)testFileChecksum:(NSMutableData*)fileChecksum digestInputStream:(DigestInputStream*)digestInputStream {
    BOOL result = YES;
    if (digestInputStream) {
        result = [FileSignatures compare:digestInputStream fileSignature:fileChecksum];
    }
    return result;
}

@end
