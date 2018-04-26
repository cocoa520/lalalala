//
//  IMBDownWhiteView.h
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBDownWhiteView : NSView
{
    BOOL _haveBottomLine;
    id  _delegate;
}
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) BOOL haveBottomLine;
@end
