//
//  OneDCreateSessionAPI.m
//  DriveSync
//
//  Created by JGehry on 1/9/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "OneDCreateSessionAPI.h"

@implementation OneDCreateSessionAPI

- (NSString *)baseUrl {
    return OneDriveEndPointURL;
}

- (NSString *)requestUrl {
    if ([_parent isEqualToString:@"0"]) {
        NSString *root = @"root";
        return [NSString stringWithFormat:OneDriveUploadBigFileCreateSession, root, [_fileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else {
        return [NSString stringWithFormat:OneDriveUploadBigFileCreateSession, _parent, [_fileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{@"item": @{@"@microsoft.graph.conflictBehavior":@"rename"}};
}

@end
