//
//  IMBCloudCollectionView.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/5/7.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBCloudCollectionView : NSCollectionView {
    id _collDelegate;
    NSTrackingArea *_trackingArea;
}
@property (nonatomic, assign) id collDelegate;

@end
