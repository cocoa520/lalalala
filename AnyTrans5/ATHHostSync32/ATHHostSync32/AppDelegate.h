//
//  AppDelegate.h
//  ATHHostSync32
//
//  Created by LuoLei on 2017-03-24.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ATHHostSync32.h"
@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    ATHHostSync32 *_ath;
}

@property (assign) IBOutlet NSWindow *window;

@end
