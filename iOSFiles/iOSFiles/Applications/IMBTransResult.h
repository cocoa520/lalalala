//
//  IMBTransResultEntry.h
//  iMobieTrans
//
//  Created by Pallas on 1/18/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*@"MSG_Convert_Success"
 @"MSG_TranResult_Success_Converted_Transfered"
 @"MSG_TranResult_Success_Converted_Transfered"
 @"MSG_TranResult_Success_Converted_Transfered"*/

typedef enum TransResultState{
    TransSuccess = 1,
    TransFailed = 2,
    TransError = 3,
    TransIgnore = 4,
    TransExist = 5,
    TransNotExist = 6,
    TransNotSupport = 7
} TransResultStateEnum;

@class IMBTransResultEntry;

@interface IMBResultSingleton : NSObject {
@private
    NSMutableArray *_mediaResultInfoArray;
    NSMutableArray *_playlistResultInfoArray;
    
    int _mediaSuccessCount;
    int _mediaExsitCount;
    int _mediaFaildCount;
    int _mediaIgnoreCount;
    
    int _playlistSuccessCount;
    int _playlistExsitCount;
    int _playlistFaildCount;
    int _playlistIgnoreCount;
    
    NSNotificationCenter *nc;
}

@property (nonatomic, readwrite, retain) NSMutableArray *mediaResultInfoArray;
@property (nonatomic, readwrite, retain) NSMutableArray *playlistResultInfoArray;

@property (nonatomic, readwrite) int mediaSuccessCount;
@property (nonatomic, readwrite) int mediaExsitCount;
@property (nonatomic, readwrite) int mediaFaildCount;
@property (nonatomic, readwrite) int mediaIgnoreCount;

@property (nonatomic, readwrite) int playlistSuccessCount;
@property (nonatomic, readwrite) int playlistExsitCount;
@property (nonatomic, readwrite) int playlistFaildCount;
@property (nonatomic, readwrite) int playlistIgnoreCount;

+ (IMBResultSingleton*)singleton;
- (void)reInit;

- (void)recordMediaResult:(NSString*)fileName resultStatus:(TransResultStateEnum)resultStatus messageID:(NSString*)messageID;
- (void)recordMediaReult:(NSString*)fileName resultStatus:(TransResultStateEnum)resultStatus messageID:(NSString*)messageID reason:(NSString*)reason;

- (void)recordPlaylistReult:(NSString*)playlistName resultStatus:(TransResultStateEnum)resultStatus messageID:(NSString*)messageID;
- (BOOL)changeItemStatus:(NSString*)itemName resultStatus:(TransResultStateEnum)resultStatus messageID:(NSString*)messageID;

- (NSArray*) mediaTransSucceedArray;
- (NSArray*) mediaTransSkippedArray;
- (NSArray*) playlistTransSucceedArray;
- (NSArray*) playlistTransSkippedArray;

@end

@interface IMBTransResultEntry : NSObject {
@private
    NSString *_itemName;
    TransResultStateEnum _resultState;
    NSString *_reason;
    NSString *_messageID;
}

@property (nonatomic, readwrite, retain) NSString *itemName;
@property (nonatomic, readwrite) TransResultStateEnum resultState;
@property (nonatomic, readwrite, retain) NSString *reason;
@property (nonatomic, readwrite, retain) NSString *messageID;
- (NSString*) resultStateString;

@end
