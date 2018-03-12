//
//  ATTracker.m
//  AnytransTracking
//
//  Created by JGehry on 10/13/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "ATTracker.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "IMBNotificationDefine.h"

static ATTracker *_instance = nil;

@interface ATTracker ()

@property (nonatomic, readwrite, retain) NSString *cid;
@property (nonatomic, readwrite, retain) NSString *appName;
@property (nonatomic, readwrite, retain) NSString *appVersion;
@property (nonatomic, readwrite, retain) NSString *MPVersion;
@property (nonatomic, readwrite, retain) NSString *ua;
@property (nonatomic, readwrite, retain) NSString *tid;

@end

@implementation ATTracker
@synthesize cid = _cid;
@synthesize appName = _appName;
@synthesize appVersion = _appVersion;
@synthesize MPVersion = _MPVersion;
@synthesize ua = _ua;
@synthesize tid = _tid;

- (void)dealloc
{
    [self setCid:nil];
    [self setAppName:nil];
    [self setAppVersion:nil];
    [self setMPVersion:nil];
    [self setUa:nil];
    [self setTid:nil];
    [super dealloc];
}

+ (ATTracker *)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[ATTracker alloc] init];
        }
    });
    return _instance;
}

/*
 * 覆盖该方法主要确保当用户通过[[ATTracker alloc] init]创建对象时对象的唯一性，
 * alloc方法会调用该方法，只不过zone参数默认为nil，
 * 因该类覆盖了allocWithZone方法，所以只能通过其父类分配内存，
 * 即[super allocWithZone:zone]
 */
+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
- (id)copy {
    return self;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
- (id)mutableCopy {
    return self;
}

+ (void)setupWithTrackingID:(NSString *)tid {
    NSString *macOS = [ATTracker getMacOSVersion];
    [ATTracker getInstance].tid = tid;
    [ATTracker getInstance].appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    [ATTracker getInstance].appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [ATTracker getInstance].ua = [NSString stringWithFormat:@"Mozilla/5.0 (Macintosh; Intel Mac OS X %@; rv:49.0) Gecko/20100101 Firefox/49.0", macOS];
    [ATTracker getInstance].MPVersion = @"1";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cid = [defaults stringForKey:@"cid"];
    if (cid) {
        [ATTracker getInstance].cid = cid;
    } else {
        [ATTracker getInstance].cid = [ATTracker getMacAddress];
        [[NSUserDefaults standardUserDefaults] setObject:[ATTracker getInstance].cid forKey:@"cid"];
    }
}

//获取系统版本
+ (NSString *)getMacOSVersion{
    SInt32 versMaj, versMin, versBugFix;
    Gestalt(gestaltSystemVersionMajor, &versMaj);
    Gestalt(gestaltSystemVersionMinor, &versMin);
    Gestalt(gestaltSystemVersionBugFix, &versBugFix);
    NSString *version = [NSString stringWithFormat:@"%d.%d.%d",versMaj,versMin,versBugFix];
    return version;
}

//获取Mac地址
+ (NSString *)getMacAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (void)event:(EventCategory)category action:(EventAction)action actionParams:(NSString *)actionParams label:(EventLabel)label transferCount:(long)transferCount screenView:(NSString *)screenName userLanguageName:(NSString *)userLanguageName customParameters:(NSDictionary *)parameters {
    /*
     An event hit with category, action, label
     */
    NSString *categoryName = nil;
    switch (category) {
        case iTunes_Library:
            categoryName = @"iTunes Library";
            break;
        case iTunes_Backup:
            categoryName = @"iTunes Backup";
            break;
        case Air_Backup:
            categoryName = @"Air Backup";
            break;
        case iCloud_Content:
            categoryName = @"iCloud Content";
            break;
        case Device_Content:
            categoryName = @"Device Content";
            break;
        case Move_To_iOS:
            categoryName = @"iOS Mover";
            break;
        case Android_Connect:
            categoryName = @"Android Connect";
            if (transferCount == 0) {
                @autoreleasepool {
                    NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Matched Connection", @"el": [NSString stringWithFormat:@"%@", actionParams], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];;
                    if (parameters != nil) {
                        for (NSString *key in parameters) {
                            [params setObject:[parameters valueForKey:key] forKey:key];
                        }
                    }
                    [self send:@"event" andParams:params];
                }
            }else if (transferCount == 1) {
                @autoreleasepool {
                    NSArray *otherError = [actionParams componentsSeparatedByString:@"#"];
                    NSString *label = [[otherError objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Other Error", @"el": [NSString stringWithFormat:@"%@: %@", label, [otherError lastObject]], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                    if (parameters != nil) {
                        for (NSString *key in parameters) {
                            [params setObject:[parameters valueForKey:key] forKey:key];
                        }
                    }
                    [self send:@"event" andParams:params];
                }
            }else if (transferCount == 2) {
                @autoreleasepool {
                    NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Connecting", @"el": [NSString stringWithFormat:@"%@", actionParams], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                    if (parameters != nil) {
                        for (NSString *key in parameters) {
                            [params setObject:[parameters valueForKey:key] forKey:key];
                        }
                    }
                    [self send:@"event" andParams:params];
                }
            }else if (transferCount == 3) {
                @autoreleasepool {
                    NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Install APK", @"el": [NSString stringWithFormat:@"%@", actionParams], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                    if (parameters != nil) {
                        for (NSString *key in parameters) {
                            [params setObject:[parameters valueForKey:key] forKey:key];
                        }
                    }
                    [self send:@"event" andParams:params];
                }
            }
            return;
        case Video_Download:
            categoryName = @"Video Download";
            break;
        case Fast_Drive:
            categoryName = @"Fast Drive";
            break;
        case Skin_Theme:
            categoryName = @"Skin Theme";
            switch (action) {
                case SkinApply: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ Start", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case ActionNone: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Switch", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                default:
                    break;
            }
            return;
        case AnyTrans_Activation:
            categoryName = @"AnyTrans Activation";
            break;
        case AnyTrans_OpenOrClose:
            categoryName = @"AnyTrans OpenOrClose";
            break;
        case Merge_Device:
            categoryName = @"Merge Device";
            break;
        case Content_To_iTunes:
            categoryName = @"Content To iTunes";
            break;
        case Content_To_Computer:
            categoryName = @"Content To Computer";
            break;
        case Content_To_Device:
            categoryName = @"Content To Device";
            break;
        case Add_Content:
            categoryName = @"Add Content";
            break;
        case Clone_Device:
            categoryName = @"Clone Device";
            break;
        case None:
            categoryName = @"undefinition event";
            break;
        default:
            categoryName = @"undefinition event";
            break;
    }
    switch (label) {
        case Open: {
            @autoreleasepool {
                NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@", actionParams], @"el": @"Open AnyTrans for Mac", @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                if (parameters != nil) {
                    for (NSString *key in parameters) {
                        [params setObject:[parameters valueForKey:key] forKey:key];
                    }
                }
                [self send:@"event" andParams:params];
            }
        }
            break;
        case Exit: {
            @autoreleasepool {
                NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@", actionParams], @"el": @"Exit AnyTrans for Mac", @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                if (parameters != nil) {
                    for (NSString *key in parameters) {
                        [params setObject:[parameters valueForKey:key] forKey:key];
                    }
                }
                [self send:@"event" andParams:params];
            }
        }
            break;
        case FirstLaunch: {
            @autoreleasepool {
                NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@", actionParams], @"el": @"1", @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                if (parameters != nil) {
                    for (NSString *key in parameters) {
                        [params setObject:[parameters valueForKey:key] forKey:key];
                    }
                }
                [self send:@"event" andParams:params];
            }
        }
            break;
        case Buy: {
            @autoreleasepool {
                NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Click to buy AnyTrans for Mac", @"el": [NSString stringWithFormat:@"Software language: %@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                if (parameters != nil) {
                    for (NSString *key in parameters) {
                        [params setObject:[parameters valueForKey:key] forKey:key];
                    }
                }
                [self send:@"event" andParams:params];
            }
        }
            break;
        case Register: {
            @autoreleasepool {
                NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Click to register AnyTrans for Mac", @"el": [NSString stringWithFormat:@"Registration result: %@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                if (parameters != nil) {
                    for (NSString *key in parameters) {
                        [params setObject:[parameters valueForKey:key] forKey:key];
                    }
                }
                [self send:@"event" andParams:params];
            }
        }
            break;
        case Switch: {
            @autoreleasepool {
                NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Switch", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                if (parameters != nil) {
                    for (NSString *key in parameters) {
                        [params setObject:[parameters valueForKey:key] forKey:key];
                    }
                }
                [self send:@"event" andParams:params];
            }
        }
            break;
        case Click: {
            if (transferCount == 0) {
                @autoreleasepool {
                    NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Click", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                    if (parameters != nil) {
                        for (NSString *key in parameters) {
                            [params setObject:[parameters valueForKey:key] forKey:key];
                        }
                    }
                    [self send:@"event" andParams:params];
                }
            }else {
                switch (action) {
                    case ToDevice: {
                        @autoreleasepool {
                            NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"1 Click To Device", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                            if (parameters != nil) {
                                for (NSString *key in parameters) {
                                    [params setObject:[parameters valueForKey:key] forKey:key];
                                }
                            }
                            [self send:@"event" andParams:params];
                        }
                    }
                        break;
                    case ToiTunes: {
                        @autoreleasepool {
                            NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"1 Click To iTunes", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                            if (parameters != nil) {
                                for (NSString *key in parameters) {
                                    [params setObject:[parameters valueForKey:key] forKey:key];
                                }
                            }
                            [self send:@"event" andParams:params];
                        }
                    }
                        break;
                    case ToiCloud: {
                        @autoreleasepool {
                            NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"1 Click To iCloud", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                            if (parameters != nil) {
                                for (NSString *key in parameters) {
                                    [params setObject:[parameters valueForKey:key] forKey:key];
                                }
                            }
                            [self send:@"event" andParams:params];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case Start: {
            switch (action) {
                case ToDevice: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ To Device Start", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case ToiTunes: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ To iTunes Start", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case Import: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ Import Start", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case Delete: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ Delete Start", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case ContentToMac: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ to Mac Start", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
//                case ToiTunes: {
//                    @autoreleasepool {
//                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ to iTunes Start", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"cc": [NSString stringWithFormat:@"%@", screenColor], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
//                        if (parameters != nil) {
//                            for (NSString *key in parameters) {
//                                [params setObject:[parameters valueForKey:key] forKey:key];
//                            }
//                        }
//                        [self send:@"event" andParams:params];
//                    }
//                }
//                    break;
//                case AddContent: {
//                    @autoreleasepool {
//                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ Add Content Start", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"cc": [NSString stringWithFormat:@"%@", screenColor], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
//                        if (parameters != nil) {
//                            for (NSString *key in parameters) {
//                                [params setObject:[parameters valueForKey:key] forKey:key];
//                            }
//                        }
//                        [self send:@"event" andParams:params];
//                    }
//                }
//                    break;
                case ActionNone: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ Start", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case ToiCloud: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ to iCloud Start", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case AirBackup: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Start", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case Finish: {
            switch (action) {
                case ToDevice: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ To Device Finish", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case ToiTunes: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ To iTunes Finish", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case Import: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ Import Finish", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case Delete: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ Delete Finish", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case ContentToMac: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ to Mac Finish", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
//                case ContentToiTunes: {
//                    @autoreleasepool {
//                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ to iTunes Finish", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"cc": [NSString stringWithFormat:@"%@", screenColor], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
//                        if (parameters != nil) {
//                            for (NSString *key in parameters) {
//                                [params setObject:[parameters valueForKey:key] forKey:key];
//                            }
//                        }
//                        [self send:@"event" andParams:params];
//                    }
//                }
//                    break;
//                case AddContent: {
//                    @autoreleasepool {
//                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ Add Content Finish", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"cc": [NSString stringWithFormat:@"%@", screenColor], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
//                        if (parameters != nil) {
//                            for (NSString *key in parameters) {
//                                [params setObject:[parameters valueForKey:key] forKey:key];
//                            }
//                        }
//                        [self send:@"event" andParams:params];
//                    }
//                }
//                    break;
                case ActionNone: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ Finish", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case ToiCloud: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@ to iCloud Finish", actionParams], @"el": [NSString stringWithFormat:@"%ld", transferCount], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                case AirBackup: {
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Finish", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case Stop: {
            if ([actionParams isEqualToString:@"Backup"]) {
                @autoreleasepool {
                    NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Stop", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                    if (parameters != nil) {
                        for (NSString *key in parameters) {
                            [params setObject:[parameters valueForKey:key] forKey:key];
                        }
                    }
                    [self send:@"event" andParams:params];
                }
            }else {
                @autoreleasepool {
                    NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Stop", @"el": [NSString stringWithFormat:@"%@ Stop", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                    if (parameters != nil) {
                        for (NSString *key in parameters) {
                            [params setObject:[parameters valueForKey:key] forKey:key];
                        }
                    }
                    [self send:@"event" andParams:params];
                }
            }
        }
            break;
        case Error: {
            @autoreleasepool {
                NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Error", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                if (parameters != nil) {
                    for (NSString *key in parameters) {
                        [params setObject:[parameters valueForKey:key] forKey:key];
                    }
                }
                [self send:@"event" andParams:params];
            }
        }
            break;
        case LabelNone: {
            switch (action) {
                case iCloud_Export:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"iCloud Export", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case iCloud_Import:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"iCloud Import", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case iCloud_Sync:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"iCloud Sync", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case iCloud_Backup:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"iCloud Backup", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;

                case Analyze:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Analyze", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Automatic_Download:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Automatic Download", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Manual_Download:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Manual Download", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case ReDownload:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"ReDownload", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Remove:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Remove", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Find:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Find", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Login:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Login", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;

                case CleanList:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"CleanList", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Automatic_Import:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Automatic Import", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Manual_Import:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Manual Import", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Analyze_Success:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Analyze Success", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Analyze_Error:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Analyze Error", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Download_Success:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Download Success", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Download_Error:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Download Error", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Stop_Analysis:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Stop Analysis", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Stop_Download:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Stop Download", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;
                case Stop_Transfer:
                    @autoreleasepool {
                        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": @"Stop Transfer", @"el": [NSString stringWithFormat:@"%@", actionParams], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
                        if (parameters != nil) {
                            for (NSString *key in parameters) {
                                [params setObject:[parameters valueForKey:key] forKey:key];
                            }
                        }
                        [self send:@"event" andParams:params];
                    }
                    break;

                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

/**
 *  构建屏幕跟踪
 *
 *  @param screenName       屏幕名称
 *  @param customArray      自定义维度
 *  @param parameters       默认为nil
 */
+ (void)screen:(Screen)screen customArray:(NSArray *)customArray customParameters:(NSDictionary *)parameters {
    //待以后扩充
}

+ (void)send:(NSString *)type andParams:(NSDictionary *)params {
    /*
     Generic hit sender to Measurement Protocol
     Consists out of hit type and a dictionary of other parameters
     */
    NSString *endpoint = @"https://www.google-analytics.com/collect?";
    NSMutableString *parameters = [NSMutableString stringWithFormat:@"v=%@&an=%@&tid=%@&av=%@&cid=%@&t=%@&ua=%@", [ATTracker getInstance].MPVersion, [ATTracker getInstance].appName, [ATTracker getInstance].tid, [ATTracker getInstance].appVersion, [ATTracker getInstance].cid, type, [ATTracker getInstance].ua];
    for (NSString *key in params) {
        [parameters appendString:[NSString stringWithFormat:@"&%@=%@", key, [params valueForKey:key]]];
    }
    
    //Encoding
    NSString *encodedString = [parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (encodedString) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", endpoint, encodedString];
        NSURL *url = [[[NSURL alloc] initWithString:urlString] autorelease];
#if DEBUG
//        NSLog(@"%@", urlString);
#endif
        
        //以下方式支持i386、x86_64
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            //请求成功
            if ([urlString rangeOfString:@"ea=First%20Launch"].location != NSNotFound) {
                if (data) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
                        if (httpResponse.statusCode == 200) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_FIRST_LAUNCH object:nil];
                        }
                    }
//                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                    NSString *error = [dict objectForKey:@"error"];
//                    if (error) {
//#if DEBUG
//                        NSLog(@"error description:%@", error.description);
//#endif
//                    }
                }
            }
        }];
        
        //以下方式仅支持x86_64
//        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//            if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
//                NSLog(@"%ld", (long)[httpResponse statusCode]);
//            } else {
//                if (error) {
//#if DEBUG
//                    NSLog(@"%@", error.description);
//#endif
//                }
//            }
//        }];
//        [task resume];
    }
}

+ (void)screenView:(NSString *)screenName customParameters:(NSDictionary *)parameters {
    /*
     A screenview hit, use screenname
     */
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"cd": screenName}];
    if (parameters != nil) {
        for (NSString *key in parameters) {
            [params setObject:[parameters valueForKey:key] forKey:key];
        }
    }
    [ATTracker send:@"screenview" andParams:params];
}

+ (void)excpetionWithDescription:(NSString *)description isFatal:(BOOL)isFatal customParameters:(NSDictionary *)parameters {
    /*
     An exception hit with exception description (exd) and "fatality"  (Crashed or not) (exf)
     */
    NSString *fatal = @"0";
    if (isFatal) {
        fatal = @"1";
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"exd": description, @"exf": fatal}];
    if (parameters != nil) {
        for (NSString *key in parameters) {
            [params setObject:[parameters valueForKey:key] forKey:key];
        }
    }
    [self send:@"exception" andParams:params];
}

@end
