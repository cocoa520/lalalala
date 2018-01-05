//
//  FileAssembler.h
//  
//
//  Created by Pallas on 4/26/16.
//
//  Complete

#import <Foundation/Foundation.h>

@class FilePath;
@class AssetEx;

@interface FileAssembler : NSObject {
@private
    id                                  _target;
    SEL                                 _selector;
    IMP                                 _imp;
    FilePath *                          _filePath;
}

- (id)initWithTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withFilePath:(FilePath*)filePath;
- (id)initWithTarget:(id)target withSelector:(SEL)selector withImp:(IMP)imp withOutputFolder:(NSString*)outputFolder;

- (void)accept:(AssetEx*)asset withChunks:(NSMutableArray*)chunks withCompleteSize:(uint64_t*)completeSize withCancel:(BOOL*)cancel;
- (BOOL)test:(AssetEx*)asset withChunks:(NSMutableArray*)chunks withCancel:(BOOL*)cancel;
- (BOOL)encryptionkeyOp:(NSString*)path asset:(AssetEx*)asset chunks:(NSMutableArray*)chunks withCancel:(BOOL*)cancel;
- (BOOL)unwrapKeyOp:(NSString*)path asset:(AssetEx*)asset chunks:(NSMutableArray*)chunks wrappedKey:(NSMutableData*)wrappedKey withCancel:(BOOL*)cancel;
- (BOOL)assemble:(NSString*)path chunks:(NSMutableArray*)chunks decryptKey:(NSMutableData*)decryptKey fileChecksum:(NSMutableData*)fileChecksum withCancel:(BOOL*)cancel;

@end
