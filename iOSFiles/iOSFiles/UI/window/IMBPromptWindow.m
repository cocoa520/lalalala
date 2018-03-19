//
//  IMBPromptWindow.m
//  iOSFiles
//
//  Created by JGehry on 3/14/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBPromptWindow.h"

@interface IMBPromptWindow ()

@end

@implementation IMBPromptWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)closeSelfWindow:(id)sender {
    [self.window close];
}

@end
