//
//  IMBCustomButton.h
//  PhoneClean3.0
//
//  Created by Pallas on 8/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBCustomButton : NSButton {
    NSTrackingArea *trackingArea;
    NSString* _currUniqueKey;
    float _buttonWight;
    float _minWight;
    int mouseDownCount;
}

@property (nonatomic, readwrite, retain) NSString* currUniqueKey;
@property (nonatomic, readwrite) float buttonWight;
@property (nonatomic, getter = minWight, setter = setMinWight:, readwrite) float minWight;

- (void)setMinWight:(float)minWight;
- (float)minWight;

@end
