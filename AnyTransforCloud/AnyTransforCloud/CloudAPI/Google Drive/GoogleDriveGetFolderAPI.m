//
//  GoogleDriveGetFolderAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/5/11.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "GoogleDriveGetFolderAPI.h"

@implementation GoogleDriveGetFolderAPI

- (NSString *)baseUrl
{
    return GoogleDriveAPIBaseURL;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:GoogleDriveGetFolderPath, _folderOrfileID];
}

- (id)requestArgument
{
    if ([_folderOrfileID isEqualToString:@"0"]) {
        return @{@"fields":@"kind,nextPageToken,files(mimeType,id,kind,name,webViewLink,thumbnailLink,trashed,size,parents,modifiedTime)"};
    }else{
        id argument = @{@"fields":@"*"};
        return argument;
    }
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

@end
