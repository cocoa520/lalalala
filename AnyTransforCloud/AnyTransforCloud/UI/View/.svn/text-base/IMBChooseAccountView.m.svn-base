//
//  IMBChooseAccountView.m
//  AnyTransforCloud
//
//  Created by hym on 16/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBChooseAccountView.h"
#import "IMBAccountItemView.h"
@implementation IMBChooseAccountView
@synthesize action = _action;
@synthesize target = _target;
@synthesize removeAction = _removeAction;

- (BOOL)isFlipped {
    return YES;
}

- (void)setAccountAryM:(NSMutableArray *)acountAryM {
    for (int i = 0; i < acountAryM.count; i ++) {
        IMBAccountItemView *itemView = [[IMBAccountItemView alloc] initWithFrame:NSMakeRect(5, i * 40 + 5, self.bounds.size.width - 10, 40)];
        [itemView setTarget:self.target];
        [itemView setAction:self.action];
        [itemView setRemoveAction:self.removeAction];
        [itemView setAccountEntity:[acountAryM objectAtIndex:i]];
        [self addSubview:itemView];
        [itemView release];
    }
}

@end
