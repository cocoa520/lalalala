//
//  IMBTransResultEntry.m
//  iMobieTrans
//
//  Created by Pallas on 1/18/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBTransResult.h"

@implementation IMBResultSingleton
@synthesize mediaResultInfoArray = _mediaResultInfoArray;
@synthesize playlistResultInfoArray = _playlistResultInfoArray;

@synthesize mediaSuccessCount = _mediaSuccessCount;
@synthesize mediaExsitCount = _mediaExsitCount;
@synthesize mediaFaildCount = _mediaFaildCount;
@synthesize mediaIgnoreCount = _mediaIgnoreCount;

@synthesize playlistSuccessCount = _playlistSuccessCount;
@synthesize playlistExsitCount = _playlistExsitCount;
@synthesize playlistFaildCount = _playlistFaildCount;
@synthesize playlistIgnoreCount = _playlistIgnoreCount;

- (id)init {
    self = [super init];
    if (self) {
        _mediaResultInfoArray = [[NSMutableArray alloc] init];
        _playlistResultInfoArray = [[NSMutableArray alloc] init];
        nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)applicationWillTerminate:(NSNotification*)notification
{
    [self release];
}

+ (IMBResultSingleton*)singleton {
    static IMBResultSingleton *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBResultSingleton alloc] init];
		}
	}
	return _singleton;
}

- (void)reInit {
    _mediaSuccessCount = 0;
    _mediaExsitCount = 0;
    _mediaFaildCount = 0;
    _mediaIgnoreCount = 0;
    _playlistSuccessCount = 0;
    _playlistExsitCount = 0;
    _playlistFaildCount = 0;
    _playlistIgnoreCount = 0;
    [_mediaResultInfoArray removeAllObjects];
    [_playlistResultInfoArray removeAllObjects];
}

- (void)setMediaSuccessCount:(int)mediaSuccessCount{
    _mediaSuccessCount = mediaSuccessCount;
}

- (void)dealloc {
    if (nc != nil) {
        [nc removeObserver:self];
        nc = nil;
    }
    if (_mediaResultInfoArray != nil) {
        [_mediaResultInfoArray release];
        _mediaResultInfoArray = nil;
    }
    if (_playlistResultInfoArray != nil) {
        [_playlistResultInfoArray release];
        _playlistResultInfoArray = nil;
    }
    [super dealloc];
}

//- (void)recordMediaResult:(NSString*)fileName resultStatus:(TransResultStateEnum)resultStatus messageID:(NSString *)messageID {
//    NSString *reason = CustomLocalizedString(messageID, nil);
//    [self recordMediaReult:fileName resultStatus:resultStatus messageID:messageID reason:reason];
//}

- (void)recordMediaReult:(NSString*)fileName resultStatus:(TransResultStateEnum)resultStatus messageID:(NSString *)messageID reason:(NSString *)reason {
    IMBTransResultEntry *resultInfo = nil;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if (evaluatedObject != nil) {
            IMBTransResultEntry *resultInfoItem = (IMBTransResultEntry*)evaluatedObject;
            return ([[resultInfoItem itemName] isEqualToString:fileName] &&
                    [[resultInfoItem messageID] isEqualToString:@"MSG_PlaylistResult_Success"]);
        } else {
            return NO;
        }
    }];
    NSArray *preArray = [_mediaResultInfoArray filteredArrayUsingPredicate:pre];
    if (preArray != nil && [preArray count] > 0) {
        resultInfo = [preArray objectAtIndex:0];
    }
    
    if (resultInfo == nil) {
        resultInfo = [[IMBTransResultEntry alloc] init];
        [resultInfo setItemName:fileName];
        [resultInfo setResultState:resultStatus];
        [resultInfo setMessageID:messageID];
        [resultInfo setReason:reason];
        [_mediaResultInfoArray addObject:resultInfo];
        [resultInfo release];
        resultInfo = nil;
    } else {
        [resultInfo setItemName:fileName];
        [resultInfo setResultState:resultStatus];
        if ([[resultInfo messageID] isEqualToString:@"MSG_PlaylistResult_Success"] == YES) {
            [resultInfo setResultState:TransSuccess];
            [resultInfo setMessageID:@"MSG_PlaylistResult_Success"];
            [resultInfo setReason:@"Succeed"];
        } else {
            [resultInfo setResultState:TransSuccess];
            [resultInfo setMessageID:@"MSG_PlaylistResult_Success"];
            [resultInfo setReason:reason];
        }
        
    }
}

- (void)recordPlaylistReult:(NSString*)playlistName resultStatus:(TransResultStateEnum)resultStatus messageID:(NSString*)messageID  {
//    NSString *reason = CustomLocalizedString(messageID,nil);
    IMBTransResultEntry *resultInfo = nil;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if (evaluatedObject != nil) {
            IMBTransResultEntry *resultInfoItem = (IMBTransResultEntry*)evaluatedObject;
            return [[resultInfoItem itemName] isEqualToString:playlistName];
        } else {
            return NO;
        }
    }];
    NSArray *preArray = [_playlistResultInfoArray filteredArrayUsingPredicate:pre];
    if (preArray != nil && [preArray count] > 0) {
        resultInfo = [preArray objectAtIndex:0];
    }
    
    if (resultInfo == nil) {
        resultInfo = [[IMBTransResultEntry alloc] init];
        [resultInfo setItemName:playlistName];
        [resultInfo setResultState:resultStatus];
        [resultInfo setMessageID:messageID];
//        [resultInfo setReason:reason];
        [_playlistResultInfoArray addObject:resultInfo];
        [resultInfo release];
        resultInfo = nil;
    } else {
        [resultInfo setItemName:playlistName];
        [resultInfo setResultState:resultStatus];
        [resultInfo setMessageID:messageID];
//        [resultInfo setReason:reason];
    }
}

- (BOOL)changeItemStatus:(NSString*)itemName resultStatus:(TransResultStateEnum)resultStatus messageID:(NSString*)messageID {
    BOOL ret = NO;
    IMBTransResultEntry *resultInfo = nil;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if (evaluatedObject != nil) {
            IMBTransResultEntry *resultInfoItem = (IMBTransResultEntry*)evaluatedObject;
            return [[resultInfoItem itemName] isEqualToString:itemName];
        } else {
            return NO;
        }
    }];
    NSArray *preArray = [_mediaResultInfoArray filteredArrayUsingPredicate:pre];
    if (preArray != nil && [preArray count] > 0) {
        resultInfo = [preArray objectAtIndex:0];
    }
    
    
    
    if (resultInfo != nil) {
        [resultInfo setResultState:resultStatus];
//        [resultInfo setReason:CustomLocalizedString(messageID,nil)];
        [resultInfo setMessageID:messageID];
        ret = YES;
    }
    return ret;
}

- (void)changeCounter:(IMBTransResultEntry*)resultInfo resultStatus:(TransResultStateEnum)resultStatus messageID:(NSString*)messageID {
    if (resultStatus != [resultInfo resultState]) {
        switch (resultStatus) {
            case TransSuccess:
                if ([[resultInfo reason] rangeOfString:@"Playlist"].location != NSNotFound) {
                    _playlistSuccessCount -= 1;
                    [self changeChildCounter:resultStatus messageID:messageID];
                } else {
                    _mediaSuccessCount -= 1;
                    [self changeChildCounter:resultStatus messageID:messageID];
                }
                break;
            
            case TransExist:
                if ([[resultInfo reason] rangeOfString:@"Playlist"].location != NSNotFound) {
                    _playlistExsitCount -= 1;
                    [self changeChildCounter:resultStatus messageID:messageID];
                } else {
                    _mediaExsitCount -= 1;
                    [self changeChildCounter:resultStatus messageID:messageID];
                }
                break;
                
            case TransFailed:
                if ([[resultInfo reason] rangeOfString:@"Playlist"].location != NSNotFound) {
                    _playlistFaildCount -= 1;
                    [self changeChildCounter:resultStatus messageID:messageID];
                } else {
                    _mediaFaildCount -= 1;
                    [self changeChildCounter:resultStatus messageID:messageID];
                }
                break;
            
            case TransIgnore:
                if ([[resultInfo reason] rangeOfString:@"Playlist"].location != NSNotFound) {
                    _playlistIgnoreCount -= 1;
                    [self changeChildCounter:resultStatus messageID:messageID];
                } else {
                    _mediaIgnoreCount -= 1;
                    [self changeChildCounter:resultStatus messageID:messageID];
                }
                break;
                
            default:
                break;
        }
    }
}

// 内部修改计数的函数
- (void)changeChildCounter:(TransResultStateEnum)resultStatus messageID:(NSString*)messageID {
    switch (resultStatus) {
        case TransSuccess:
            if ([messageID rangeOfString:@"Playlist"].location != NSNotFound) {
                _playlistSuccessCount += 1;
            } else {
                _mediaSuccessCount += 1;
            }
            break;
            
        case TransExist:
            if ([messageID rangeOfString:@"Playlist"].location != NSNotFound) {
                _playlistExsitCount += 1;
            } else {
                _mediaExsitCount += 1;
            }
            break;
            
        case TransFailed:
            if ([messageID rangeOfString:@"Playlist"].location != NSNotFound) {
                _playlistFaildCount += 1;
            } else {
                _mediaFaildCount += 1;
            }
            break;
            
        case TransIgnore:
            if ([messageID rangeOfString:@"Playlist"].location != NSNotFound) {
                _playlistIgnoreCount += 1;
            } else {
                _playlistIgnoreCount += 1;
            }
            break;
            
        default:
            break;
    }
}

- (NSArray*) mediaTransSucceedArray {
    if (_mediaResultInfoArray != nil && _mediaResultInfoArray.count > 0) {
        NSArray *succeed = [_mediaResultInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"resultState == %d",TransSuccess]];
        return succeed;
    }
    return nil;
}

- (NSArray*) mediaTransSkippedArray {
    if (_mediaResultInfoArray != nil && _mediaResultInfoArray.count > 0) {
        NSArray *succeed = [_mediaResultInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"resultState != %d",TransSuccess]];
        return succeed;
    }
    return nil;
}

- (NSArray*) playlistTransSucceedArray {
    if (_playlistResultInfoArray != nil && _playlistResultInfoArray.count > 0) {
        NSArray *succeed = [_playlistResultInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"resultState == %d",TransSuccess]];
        return succeed;
    }
    return nil;
}

- (NSArray*) playlistTransSkippedArray {
    if (_playlistResultInfoArray != nil && _playlistResultInfoArray.count > 0) {
        NSArray *succeed = [_playlistResultInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"resultState != %d",TransSuccess]];
        return succeed;
    }
    return nil;
}

@end

@implementation IMBTransResultEntry
@synthesize itemName = _itemName;
@synthesize resultState = _resultState;
@synthesize reason = _reason;
@synthesize messageID = _messageID;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString*) resultStateString {
    //Todo需要加入到message中。
    switch (_resultState) {
//        case TransSuccess:
//            return CustomLocalizedString(@"TransResDetail_State_Success", @"Success");
//            break;
//        case TransFailed:
//            return CustomLocalizedString(@"TransResDetail_State_Failed", @"Failed");
//            break;
//        case TransError:
//            return CustomLocalizedString(@"TransResDetail_State_Error", @"Error");
//            break;
//        case TransIgnore:
//            return CustomLocalizedString(@"TransResDetail_State_Ignore", @"Ignore");
//            break;
//        case TransExist:
//            return CustomLocalizedString(@"TransResDetail_State_Exist", @"Exist");
//            break;
//        case TransNotExist:
//            return CustomLocalizedString(@"TransResDetail_State_NotExist", @"NotExist");
//            break;
//        case TransNotSupport:
//            return CustomLocalizedString(@"TransResDetail_State_TransNotSupport", @"TransNotSupport");
//            break;
        default:
            return @"";
            break;
    }
}

- (void)dealloc {
    if (_itemName != nil) {
        [_itemName release];
    }
    if (_reason != nil) {
        [_reason release];
    }
    if (_messageID != nil) {
        [_messageID release];
    }
    [super dealloc];
}

@end
