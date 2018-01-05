//
//  IMBRefreshButton.h
//  iMobieTrans
//
//  Created by iMobie on 7/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    EnteredButton = 1,
    ExitButton = 2,
    UpButton = 3,
    DownButton = 4,
} ButtonType;

@interface IMBRefreshButton : NSButton{
    NSTrackingArea *trackingArea;
    NSString *titleName;
}

@property (retain, nonatomic) NSString *titleName;

- (id)initWithFrame:(NSRect)frame withName:(NSString *)name;

@end
