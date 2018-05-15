//
//  IMBCloudCollectionViewItem.h
//  AnyTransforCloud
//
//  Created by hym on 18/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCloudEntity.h"
@interface IMBCloudCollectionViewItem : NSCollectionViewItem
{
    IMBCloudEntity* _cloud;
    NSTrackingArea *_trackingArea;
     MouseStatusEnum _buttonType;
    id _delegate;
}
@property (assign) IBOutlet NSTextField *personsNumber;
@property (nonatomic, retain) IMBCloudEntity* cloud;
@property (nonatomic, assign) id delegate;
@end
