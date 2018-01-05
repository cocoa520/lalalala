//
//  IMBEditButton.h
//  iMobieTrans
//
//  Created by iMobie on 7/1/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBEditButton : NSButton{
    NSString *_drawString;
    NSRect originRect;
}

@property (nonatomic,retain,readwrite) NSString *drawString;

- (void)setDrawString:(NSString *)drawString;

@end
