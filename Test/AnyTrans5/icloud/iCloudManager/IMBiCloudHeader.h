//
//  IMBiCloudHeader.h
//  iCloudPanel
//
//  Created by iMobie on 12/27/16.
//  Copyright (c) 2016 iMobie. All rights reserved.
//

#ifndef iCloudPanel_Header_h
#define iCloudPanel_Header_h

#define ICLOUD_HOME_URL @"https://www.icloud.com"
#define ICLOUD_LOGIN_URL @"https://setup.icloud.com"

/*
    iCloud Driver UPDATE Post Data Content
*/
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n"
#define MULTIPART @"------WebKitFormBoundary1IR5qsBwtCYcLQaJ"
#define CONTENT_TYPE @"multipart/form-data; boundary=----WebKitFormBoundary1IR5qsBwtCYcLQaJ"

/*
    photos UPDATE Post Data Content
*/
#define PHOTO_END @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n"
#define PHOTO_FENG @"-----------------------------7e02b72d104ac"
#define PHOTO_CONTENT_TYPE @"multipart/form-data; boundary=---------------------------7e02b72d104ac"

#endif
