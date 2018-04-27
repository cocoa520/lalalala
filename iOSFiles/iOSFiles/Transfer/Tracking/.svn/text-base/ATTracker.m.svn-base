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

+ (void)event:(EventCategory)category action:(EventAction)action label:(EventLabel)label labelParameters:(NSString *)labelParameters transferCount:(long)transferCount screenView:(NSString *)screenName userLanguageName:(NSString *)userLanguageName customParameters:(NSDictionary *)parameters {
    /*
     An event hit with category, action, label
     */
    NSString *categoryName = nil;
    switch (category) {
        case CiCloud:
            categoryName = @"iCloud";
            break;
        case CDropbox:
            categoryName = @"Dropbox";
            break;
        case CDevice:
            categoryName = @"Device";
            break;
        case COpenOrClose:
            categoryName = @"OpenOrClose";
            break;
        case CSupport:
            categoryName = @"Support";
            break;
        case CNone:
            categoryName = @"UndefineEvent";
            break;
        default:
            categoryName = @"UndefineEvent";
            break;
    }
    
    NSString *actionName = nil;
    switch (action) {
        case AOpen:
            actionName = @"Open";
            break;
        case AClose:
            actionName = @"Close";
            break;
        case AFirstLaunch:
            actionName = @"First Launch";
            break;
        case ALogin:
            actionName = @"Login";
            break;
        case ALogout:
            actionName = @"Logout";
            break;
        case AAddAccount:
            actionName = @"AddAccount";
            break;
        case AJump:
            actionName = @"Jump";
            break;
        case AHelp:
            actionName = @"Help";
            break;
        case ACreateFolder:
            actionName = @"Create Folder";
            break;
        case ADelete:
            actionName = @"Delete";
            break;
        case AUpload:
            actionName = @"Upload";
            break;
        case ADownload:
            actionName = @"Download";
            break;
        case ARename:
            actionName = @"Rename";
            break;
        case AMove:
            actionName = @"Move";
            break;
        case AToDevice:
            actionName = @"ToDevice";
            break;
        case AToiCloudDrive:
            actionName = @"ToiCloudDrive";
            break;
        case AToDropbox:
            actionName = @"ToDropbox";
            break;
        case ARefresh:
            actionName = @"Refresh";
            break;
        case ADetail:
            actionName = @"Detail";
            break;
        case APreview:
            actionName = @"Preview";
            break;
        case ABuy:
            actionName = @"Buy";
            break;
        case ARegister:
            actionName = @"Register";
            break;
        case ACancel:
            actionName = @"Cancel";
            break;
        case AClearRecord:
            actionName = @"Clear Record";
            break;
        case AViewRecord:
            actionName = @"View Record";
            break;
        case AClearAll:
            actionName = @"Clear All";
            break;
        case ASearch:
            actionName = @"Search";
            break;
        case ARightClick:
            actionName = @"Right Click";
            break;
        case ANone:
            actionName = @"UndefineAction";
            break;
        default:
            actionName = @"UndefineAction";
            break;
    }
    
    NSString *labelName = nil;
    switch (label) {
        case LSuccess:
            labelName = @"Success";
            break;
        case LFailed:
            labelName = @"Failed";
            break;
        case LNone: {
            if ([[labelParameters lowercaseString] isEqualToString:@"icloud"]) {
                labelName = @"iCloud";
            }else if ([[labelParameters lowercaseString] isEqualToString:@"dropbox"]) {
                labelName = @"Dropbox";
            }else if ([[labelParameters lowercaseString] isEqualToString:@"device"]) {
                labelName = @"Device";
            }else {
                labelName = @"1";
            }
        }
            break;
        default:
            labelName = @"UndefineLabel";
            break;
    }
    @autoreleasepool {
        NSMutableDictionary *params = [[[NSMutableDictionary alloc] initWithDictionary:@{@"ec": [NSString stringWithFormat:@"%@", categoryName], @"ea": [NSString stringWithFormat:@"%@", actionName], @"el": [NSString stringWithFormat:@"%@", labelName], @"cd": [NSString stringWithFormat:@"%@", screenName], @"ul": [NSString stringWithFormat:@"%@", userLanguageName]}] autorelease];
        if (parameters != nil) {
            for (NSString *key in parameters) {
                [params setObject:[parameters valueForKey:key] forKey:key];
            }
        }
        [self send:@"event" andParams:params];
    }
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
                }
            }
        }];
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
