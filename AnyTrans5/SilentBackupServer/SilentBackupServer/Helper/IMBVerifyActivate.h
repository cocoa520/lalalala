//
//  IMBVerifyActivate.h
//  PhoneClean3.0
//
//  Created by Pallas on 6/21/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct KeyState {
    int activiate;
    int license;
    int quota;
    int duration;
    int timelimitation;
    int versiolimitation;
    int version1;
    int version2;
    int version3;
    int year;
    int month;
    int day;
    bool valid;
	int reserved1;
	int reserved2;
	int reserved3;
} KeyStateStruct;

@interface IMBVerifyActivate : NSObject {
    
}

+ (KeyStateStruct *)activate:(NSString *)key id1:(char)id1 id2:(char)id2;

+ (KeyStateStruct *)verify:(NSString *)key id1:(char)id1 id2:(char)id2;

@end
