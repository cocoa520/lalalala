//
//  IMBHoverChangeImageBtn.h
//  iOSFiles
//
//  Created by iMobie on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBHoverChangeImageBtn : NSButton
{
    @private
    NSImage *_normalImage;
    NSImage *_hoverImage;
    
}
- (void)setHoverImage:(NSString *)hoverImage;


@end
