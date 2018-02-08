//
//  numberTextField.m
//  AnyTrans
//
//  Created by m on 17/2/11.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "numberTextField.h"
#import "StringHelper.h"

NSEvent * (^monitorHandler)(NSEvent *);
@implementation numberTextField
@synthesize isHourNumber = _isHourNumber;
@synthesize isMinuteNumber = _isMinuteNumber;
- (void)awakeFromNib {
    
    monitorHandler = ^NSEvent * (NSEvent * theEvent){
        
    _inputNumber = theEvent.keyCode;
    return theEvent;

    };
    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:monitorHandler];
}

- (void)textDidChange:(NSNotification *)notification{
    if (((_inputNumber >= 18 && _inputNumber <=29 && _inputNumber !=24 && _inputNumber != 27) ||(_inputNumber >= 82 && _inputNumber <= 92 && _inputNumber != 90) || _inputNumber == 51)) {
        if (_isHourNumber) {
            if ([StringHelper stringIsNilOrEmpty:self.stringValue] || self.stringValue.length >= 3 ) {
                [self setStringValue:@"00"];
            }else {
                if ([self.stringValue intValue] > 12 ) {
                    [self setStringValue:@"00"];
                }
            }
            
        }else if (_isMinuteNumber ) {
            if ([StringHelper stringIsNilOrEmpty:self.stringValue] || self.stringValue.length >= 3) {
                [self setStringValue:@"00"];
            }else {
                if ([self.stringValue intValue] > 12 ) {
                    [self setStringValue:@"00"];
                }
            }
        }
    }else {
        [self setStringValue:@"00"];
    }
}

@end
