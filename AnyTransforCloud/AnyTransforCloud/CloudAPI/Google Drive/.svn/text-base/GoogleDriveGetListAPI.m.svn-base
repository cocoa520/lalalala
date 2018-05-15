//
//  GoogleDriveGetListAPI.m
//  DriveSync
//
//  Created by Sean on 1/3/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "GoogleDriveGetListAPI.h"

@implementation GoogleDriveGetListAPI

- (NSString *)baseUrl
{
    return GoogleDriveAPIBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = GoogleDriveGetListPath;
    return url;
}

- (id)requestArgument
{
    if ([_folderOrfileID isEqualToString:@"0"]) {
        return @{@"q":@"'root' in parents and trashed != true",@"fields":@"kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed,size,parents,modifiedTime)"};
    }else{
        id argument = @{@"q":[NSString stringWithFormat:@"\'%@\' in parents and trashed != true",_folderOrfileID],@"fields":@"kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed,size,parents,modifiedTime)"};
        return argument;
    }
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end
