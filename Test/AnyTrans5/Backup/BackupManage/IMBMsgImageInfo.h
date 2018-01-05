//
//  IMBMsgImageInfo.h
//  iMobieTrans
//
//  Created by iMobie on 8/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMBMsgImageInfo : NSObject {
    NSImage *_msgImage;
    NSRect _msgRect;
}

@property (nonatomic,retain) NSImage *msgImage;
@property (assign, nonatomic) NSRect msgRect;

@end
