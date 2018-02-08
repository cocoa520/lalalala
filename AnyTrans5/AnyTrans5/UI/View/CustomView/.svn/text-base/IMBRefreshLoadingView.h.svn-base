//
//  IMBRefreshLoadingVIew.h
//  iMobieTrans
//
//  Created by iMobie on 14-8-8.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBackgroundBorderView.h"


typedef enum
{
    LoadingDelete,
    LoadingRefresh,
    LoadingAddPlaylist,
    LoadingReName,
    LoadingAddBookmark,
    LoadingEditBookmark,
    LoadingDeleteBookmark
}LoadingType;
@interface IMBRefreshLoadingView : IMBBackgroundBorderView
{
    NSImageView *loadingImageView;
    NSTextField *loadingText;
    NSTimer *timer;
    int count;
    BOOL needTimer;
    LoadingType loadingType;
}
@property (nonatomic,assign)BOOL needTimer;
@property (nonatomic,assign)LoadingType loadingType;
- (void)killTimer;
- (id)initWithFrame:(NSRect)frame needTimer:(BOOL)needtimer;
- (id)initWithFrame:(NSRect)frame needTimer:(BOOL)needtimer LoadingType:(LoadingType)_loadingType;
- (void)changeTipText;
@end
