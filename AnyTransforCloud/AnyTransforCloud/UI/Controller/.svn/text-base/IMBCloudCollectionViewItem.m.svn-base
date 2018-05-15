//
//  IMBCloudCollectionViewItem.m
//  AnyTransforCloud
//
//  Created by hym on 18/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBCloudCollectionViewItem.h"
#import "StringHelper.h"
#import "IMBAddCloudAnimationView.h"
#import "IMBAddCloudViewController.h"
@implementation IMBCloudCollectionViewItem
@synthesize cloud = _cloud;
@synthesize delegate = _delegate;
- (void)awakeFromNib {
    [[self textField] setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_personsNumber setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
}

- (void)setCloud:(IMBCloudEntity *)cloud {
    if (_cloud) {
        [_cloud release];
        _cloud = nil;
    }
    _cloud = [cloud retain];
    if(cloud){
        [self imageView].image = cloud.image;
        [self textField].stringValue = cloud.name;
        if (cloud.usersNumber == 0) {
            [_personsNumber setHidden:YES];
        }else {
            [_personsNumber setHidden:NO];
        }
        _personsNumber.stringValue = [NSString stringWithFormat:CustomLocalizedString(@"AddCloud_people", nil),cloud.usersNumber];
    }else{
        [self imageView].image = nil;
        [self textField].stringValue = @"";
    }
    IMBAddCloudAnimationView *addView = (IMBAddCloudAnimationView *)self.view;
    [addView setTarget:self];
    [addView setAction:@selector(chooseCloud)];
}

- (void)chooseCloud {
    if (_delegate && [_delegate respondsToSelector:@selector(chooseCloud:)]) {
        [_delegate chooseCloud:_cloud];
    }
}

- (void)dealloc {
    if (_cloud) {
        [_cloud release];
        _cloud = nil;
    }
    [super dealloc];
}

@end
