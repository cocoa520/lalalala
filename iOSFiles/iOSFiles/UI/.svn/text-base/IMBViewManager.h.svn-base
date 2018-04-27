//
//  IMBViewManager.h
//  iOSFiles
//
//  Created by iMobie on 3/20/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBDeviceViewController.h"
#import "IMBMainWindowController.h"

@interface IMBViewManager : NSObject {
    NSMutableDictionary *_allMainControllerDic;
    NSMutableDictionary *_windowDic;
    IMBDeviceViewController *_mainViewController;
    IMBMainWindowController *_mainWindowController;
}
@property(nonatomic, retain, readonly) NSMutableDictionary *windowDic;
@property(nonatomic, retain, readonly) NSMutableDictionary *allMainControllerDic;
@property(nonatomic, retain) IMBDeviceViewController *mainViewController;
@property(nonatomic, retain) IMBMainWindowController *mainWindowController;

+ (instancetype)singleton;

@end
