//
//  MediaHelper.m
//  AnyTrans
//
//  Created by iMobie on 7/22/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "MediaHelper.h"
#import "NSString+Category.h"
#import "IMBFileSystem.h"
#import "XMLReader.h"
#import "IMBSession.h"
#import "IMBMediaInfo.h"
#import "IMBNewTrack.h"
#import "IMBVideoImageAcquire.h"
#import "IMBSoftWareInfo.h"
#import "IMBDeviceInfo.h"
#import <openssl/sha.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "IMBTrack.h"
@implementation MediaHelper

+ (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if (string == nil || [string isEqualToString:@""]  ) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString*)getDirectory:(NSString*)filePath {
    NSString *currDirectory = [filePath stringByDeletingLastPathComponent];
//    NSArray *components = [filePath pathComponents];
//    for(int i = 0; i < [components count]; i++)
//    {
//        if (i < [components count] - 1) {
//            currDirectory = [currDirectory stringByAppendingPathComponent:[components objectAtIndex: i]];
//        } else {
//            break;
//        }
//    }
    return currDirectory;
}

+ (NSString*) getFileTypeDescription:(NSString*)extension {
    NSString *str = [extension lowercaseString];
    
    NSLog(@"str: %@",str);
    if ([str rangeOfString:@"mp4"].location != NSNotFound)
        return @"MPEG-4 video file";
    else if ([str rangeOfString:@"m4v"].location != NSNotFound)
        return @"MPEG-4 video file";
    else if ([str rangeOfString:@"mp3"].location != NSNotFound)
        return @"MPEG audio file";
    else if ([str rangeOfString:@"m4a"].location != NSNotFound)
        return @"AAC audio file";
    else if ([str rangeOfString:@"wav"].location != NSNotFound)
        return @"Wav audio file";
    else if ([str rangeOfString:@"m4r"].location != NSNotFound)
        return @"Ringtone";
    else if ([str rangeOfString:@"pdf"].location != NSNotFound)
        return @"PDF Book file";
    else if ([str rangeOfString:@"epub"].location != NSNotFound)
        return @"EPUB Book file";
    else
        return @"";
}

+(NSString*)getiPodPathToStandardPath:(NSString*)path{
    return [[path stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@":" withString:@"/"];
}

+(NSString*)getStandardPathToiPodPath:(NSString*)path{
    return [[path stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"/" withString:@":"];
}

+ (NSData*)intToITunesSDFormat:(int)value {
    Byte bytes[3];
    bytes[0] = (Byte)(value >> 16);
    bytes[1] = (Byte)(value >> 8);
    bytes[2] = (Byte)(value);
    return [NSData dataWithBytes:bytes length:3];
}

+(BOOL)isInternetAvail
{
    return NO;//[self checkSiteAvail:CustomLocalizedString(@"apple.com", nil)];
}

+(BOOL)checkSiteAvail:(NSString*)urlStr
{
    const char *hostName = [urlStr cStringUsingEncoding:NSASCIIStringEncoding];
    SCNetworkReachabilityRef target;
    SCNetworkConnectionFlags flags = 0;
    target = SCNetworkReachabilityCreateWithName(NULL, hostName);
    SCNetworkReachabilityGetFlags(target, &flags);
    NSLog(@"flag %d", flags);
    CFRelease(target);
    return (flags == kSCNetworkFlagsReachable) || (flags == (kSCNetworkFlagsReachable | kSCNetworkFlagsTransientConnection)) ;
}

+ (NSURL *)getHashWebserviceUri {
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    NSString *netPath = [soft.domainNetwork stringByAppendingString:@"HCD6AB6S0H.asmx"];
    NSURL *url = [NSURL URLWithString:netPath];
    return url;
}

+ (NSString *)getHashWebserviceNameSpace {
    NSString *nameSpace = @"http://tempuri.org/";
    return nameSpace;
}

+ (void)getHashByWebservice:(NSURL*)url nameSpace:(NSString*)nameSpace methodName:(NSString*)methodName sha1:(NSString*)sha1 uuid:(NSString*)uuid signature:(uint8_t[])signature isSuccess:(BOOL *)isSuccess {
    //[self getHashByWebserviceA:url nameSpace:nameSpace methodName:methodName sha1:sha1 uuid:uuid signature:signature];
    
    WSMethodInvocationRef mySoapRef = WSMethodInvocationCreate((CFURLRef)url, (CFStringRef)methodName, kWSSOAP2001Protocol);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:sha1, @"fileSha1", uuid, @"uuid", nil];
    NSArray *paramOrder = [NSArray arrayWithObjects:@"fileSha1", @"uuid", nil];
    WSMethodInvocationSetParameters(mySoapRef, (CFDictionaryRef)params, (CFArrayRef)paramOrder);
    /*NSString *userName = [@"ABCBDAB9460B" sha1];
     NSString *password = [@"D8D4A9588F78" sha1];
     NSDictionary *reqHeaders = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"UserName", password, @"PassWord", nil];*/
    NSDictionary *reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@%@", nameSpace, methodName]
                                                           forKey:@"SOAPAction"];
    WSMethodInvocationSetProperty(mySoapRef, kWSSOAPMethodNamespaceURI,
                                  (CFStringRef)nameSpace);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPExtraHeaders,
                                  (CFDictionaryRef)reqHeaders);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPFollowsRedirects,
                                  kCFBooleanTrue);
    // set debug props
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingHeaders,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingHeaders,
                                  kCFBooleanTrue);
    
    NSDictionary *result = (NSDictionary *)WSMethodInvocationInvoke(mySoapRef);
    // get HTTP response from SOAP request so we can see the status code
    CFHTTPMessageRef res = nil;
    res = (CFHTTPMessageRef)[result objectForKey:(id)kWSHTTPResponseMessage];
    NSDictionary *resultDir = [result objectForKey:@"/Result"];
    NSLog(@"hash72 result: %@",[resultDir description]);
    NSArray *keyArr = [resultDir allKeys];
    NSString *hashStr = nil;
    for (NSString *key in keyArr) {
        hashStr = [resultDir valueForKey:key];
    }
    if ([self stringIsNilOrEmpty:hashStr]) {
        *isSuccess = NO;
    } else {
        *isSuccess = YES;
    }
    [[hashStr hexToBytes] getBytes:signature];
}

+ (NSDictionary *)copyRemoteMediaLibrayFromRemote:(NSDictionary *)remote ToLocal:(NSDictionary *)local WithIpod:(IMBiPod *)ipod
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *localLibraryFile = [local objectForKey:@"libraryfile"];
    NSString *localLibrarySHMFile = [local objectForKey:@"libraryshmfile"];
    NSString *localLibraryWALFile = [local objectForKey:@"librarywalfile"];
    
    long long fileSize = 0;
    long long shmFileSize = 0;
    long long walFileSize = 0;
    BOOL ret = false;
    
    NSString *remoteLibraryPath = [remote objectForKey:@"libraryfile"];
    fileSize = [[ipod fileSystem] getFileLength:remoteLibraryPath];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:localLibraryFile] == YES) {
        [fileManager removeItemAtPath:localLibraryFile error:&error];
    }
    
    NSString *newPath = nil;
    if (error != nil) {
        newPath = [localLibraryFile stringByDeletingLastPathComponent];
        newPath = [localLibraryFile stringByAppendingPathComponent:@"1"];
        if (![fileManager fileExistsAtPath:newPath]) {
            NSError *folderErr = nil;
            [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:&folderErr];
            if (folderErr != nil) {
                return nil;
            }
        }
        localLibraryFile = [newPath stringByAppendingPathComponent:[localLibraryFile lastPathComponent]];
        localLibrarySHMFile = [newPath stringByAppendingPathComponent:[localLibrarySHMFile lastPathComponent]];
        localLibraryWALFile = [newPath stringByAppendingPathComponent:[localLibraryWALFile lastPathComponent]];
    }
    
    [[ipod fileSystem] copyRemoteFile:remoteLibraryPath toLocalFile:localLibraryFile];
    if (![fileManager fileExistsAtPath:localLibraryFile] == YES || [[fileManager attributesOfItemAtPath:localLibrarySHMFile error:nil] fileSize] != fileSize) {
        ret = false;
    }
    
    
    NSString *remoteLibrarySHMFile = [remote objectForKey:@"libraryshmfile"];
    error = nil;
    shmFileSize = [[ipod fileSystem] getFileLength:remoteLibrarySHMFile];
    if ([fileManager fileExistsAtPath:localLibrarySHMFile] == YES) {
        [fileManager removeItemAtPath:localLibrarySHMFile error:&error];
        if (error != nil) {
            NSLog(@"remove locallibraryshmfile failed");
        }
    }
    
    [[ipod fileSystem] copyRemoteFile:remoteLibrarySHMFile toLocalFile:localLibrarySHMFile];
    if (![fileManager fileExistsAtPath:localLibrarySHMFile] == YES || [[fileManager attributesOfItemAtPath:localLibrarySHMFile error:nil] fileSize] != shmFileSize) {
        ret = false;
    }
    
    NSString *remoteLibraryWALFile = [remote objectForKey:@"librarywalfile"];
    walFileSize = [[ipod fileSystem] getFileLength:remoteLibraryWALFile];
    error = nil;
    if ([fileManager fileExistsAtPath:localLibraryWALFile] == YES) {
        [fileManager removeItemAtPath:localLibraryWALFile error:&error];
        if (error != nil) {
            NSLog(@"remove locallibrarywalfile failed");
        }
    }
    
    walFileSize = [[ipod fileSystem] getFileLength:localLibraryWALFile];
    [[ipod fileSystem] copyRemoteFile:remoteLibraryWALFile toLocalFile:localLibraryWALFile];
    if (![fileManager fileExistsAtPath:localLibraryWALFile] == YES || [[fileManager attributesOfItemAtPath:localLibraryWALFile error:nil] fileSize] != walFileSize) {
        ret = false;
    }
    
    NSDictionary *resDic = nil;
    
    //    if (ret) {
    resDic = [NSDictionary dictionaryWithObjectsAndKeys:localLibraryFile,@"libraryfile",localLibrarySHMFile,@"libraryshmfile",localLibraryWALFile,@"librarywalfile", nil];
    //    }
    return resDic;
}

+ (NSComparisonResult)compareVersion:(NSString *)oldVersion newVersion:(NSString *)newVersion {
    NSArray *oldArray = [oldVersion componentsSeparatedByString:@"."];
    NSArray *newArray = [newVersion componentsSeparatedByString:@"."];
    NSComparisonResult comparisonResult = NSOrderedDescending;
    for (int i = 0; i < oldArray.count ; i++){
        if (newArray.count > i) {
            int oldnumber = [[oldArray objectAtIndex:i] intValue];
            int newnumber = [[newArray objectAtIndex:i] intValue];
            
            if (oldnumber > newnumber) {
                return NSOrderedDescending;
            }
            else if(oldnumber == newnumber){
                comparisonResult = NSOrderedSame;
                continue;
            }
            else{
                return NSOrderedAscending;
            }
        }
        else{
            int oldnumber = [[oldArray objectAtIndex:i] intValue];
            if (oldnumber > 0) {
                comparisonResult = NSOrderedDescending;
                break;
            }
            else if(oldnumber == 0){
                comparisonResult = NSOrderedSame;
                continue;
            }
        }
    }
    
    if (comparisonResult == NSOrderedSame) {
        if (oldArray.count < newArray.count) {
            for (int i = (int)oldArray.count; i < newArray.count; i++) {
                int newnumber = [[newArray objectAtIndex:i] intValue];
                
                if (newnumber > 0) {
                    comparisonResult = NSOrderedAscending;
                    break;
                }
                else if(newnumber == 0){
                    comparisonResult = NSOrderedSame;
                    continue;
                }
                else{
                    comparisonResult = NSOrderedDescending;
                    break;
                }
                
            }
        }
    }
    
    return comparisonResult;
}

+ (NSString*)getSupportFile:(CategoryNodesEnum)selectNode supportVideo:(BOOL)supportVideo withiPod:(IMBiPod *)ipod {
    NSString *_supportFile = nil;
    switch (selectNode) {
        case Category_Summary:
            if (ipod && [ipod.deviceInfo.productVersion isVersionMajorEqual:@"11"]) {
                _supportFile = @"*.mp3;*.m4a;*.mp4;*.m4v;*.flac;*.wav";
            }else {
                _supportFile = @"*.mp3;*.m4a;*.mp4;*.m4v";
            }
            break;
        case Category_Playlist:
            if (ipod && [ipod.deviceInfo.productVersion isVersionMajorEqual:@"11"]) {
                _supportFile = @"*.mp3;*.m4a;*.flac;*.wav";
            }else {
                _supportFile =@"*.mp3;*.m4a";
            }
            break;
        case Category_PhotoLibrary:
        case Category_MyAlbums:
            _supportFile = @"*.png;*.jpg;*.gif;*.bmp;*.jpeg";
            break;
        case Category_Music:
            if (ipod && [ipod.deviceInfo.productVersion isVersionMajorEqual:@"11"]) {
                _supportFile =@"*.mp3;*.m4a;*.m4b;*.m4r;*.m4p;*.flac;*.wav";
            }else {
                _supportFile =@"*.mp3;*.m4a;*.m4b;*.m4r;*.m4p;";
            }
            break;
            
        case Category_Movies:
            //TODO:添加mov,要删除
            _supportFile = @"*.mp4;*.m4v;*.mov";
            break;
            
        case Category_MusicVideo:
        case Category_HomeVideo:
            _supportFile = @"*.mp4;*.m4v;*.mov";
            break;
            
        case Category_PodCasts:
            if (supportVideo == YES) {
                _supportFile = @"*.mp3;*.m4a;*.m4v";
            } else {
                _supportFile = @"*.mp3";
            }
            break;
            
        case Category_Ringtone:
            _supportFile = @"*.m4r";
            break;
            
        case Category_TVShow:
            _supportFile = @"*.mp4;*.m4v;*.mov";
            break;
            
        case Category_Audiobook:
            _supportFile = @"*.mp3;*.m4b;*.m4a;*.m4p";
            break;
            
        case Category_iTunesU:
            _supportFile = @"*.mp3;*.m4v;*.mp4";
            break;
        case Category_iBookCollections:
        case Category_iBooks:
            _supportFile = @"*.epub;*.pdf";
            break;
        case Category_VoiceMemos:
            _supportFile = @"*.m4a";
            break;
            
        case Category_Applications:
            _supportFile = @"*.ipa;*.pxl";
            break;
            
        default:
            break;
    }
    return _supportFile;
}

+ (NSString*)getSupportFileTypeArray:(CategoryNodesEnum)selectNode supportVideo:(BOOL)isSupportVideo supportConvert:(BOOL)isSupportConvert withiPod:(IMBiPod *)ipod {//isSupportConvert为NO，是设备原本就支持的格式；
    NSString *_supportFile = nil;
    switch (selectNode) {
        case Category_Summary:
            if (isSupportConvert) {
                if (isSupportVideo) {
                    _supportFile = @"mp3;m4a;m4r;m4b;wma;wav;rm;mdi;mp4;m4v;mov;wmv;rmvb;mkv;avi;flv;flac;ogg;amr;3gp;mpg;webm";
                } else {
                    _supportFile = @"mp3;m4a;m4r;m4b;wma;wav;rm;mdi;flac;ogg;amr;ac3;ape;aac;mka";
                }
            } else {
                if (isSupportVideo) {
                    _supportFile = @"mp3;m4a;mp4;m4v";
                } else {
                    if (ipod && [ipod.deviceInfo.productVersion isVersionMajorEqual:@"11"]) {
                        _supportFile = @"mp3;m4a;flac;wav";
                    }else {
                        _supportFile = @"mp3;m4a";
                    }
                }
            }
            break;
            
        case Category_Playlist:
            if (isSupportConvert) {
                _supportFile = @"mp3;m4a;wma;wav;rm;mdi;flac";
            } else {
                if (ipod && [ipod.deviceInfo.productVersion isVersionMajorEqual:@"11"]) {
                    _supportFile = @"mp3;m4a;m4b;m4r;m4p;flac;wav";
                }else {
                    _supportFile =@"mp3;m4a;m4b;m4r;m4p";
                }
            }
            break;
        case Category_Music:
            if (isSupportConvert) {
                _supportFile = @"mp3;m4a;wma;wav;rm;mdi;m4r;m4b;m4p;flac;amr;ogg;ac3;ape;aac;mka";
            } else {
                if (ipod && [ipod.deviceInfo.productVersion isVersionMajorEqual:@"11"]) {
                    _supportFile =@"mp3;m4a;m4r;m4b;m4p;flac;wav";
                }else {
                    _supportFile =@"mp3;m4a;m4r;m4b;m4p";
                }
            }
            break;
            
        case Category_Movies:
            if (isSupportConvert) {
                _supportFile = @"mp4;m4v;mov;wmv;rmvb;mkv;avi;flv;rm;3gp;mpg;webm";
            } else {
                _supportFile = @"mp4;m4v;mov";
            }
            break;
        case Category_MusicVideo:
        case Category_HomeVideo:
            if (isSupportConvert) {
                _supportFile = @"mp4;m4v;mov;wmv;rmvb;mkv;avi;flv;rm;3gp;mpg;webm";
            } else {
                _supportFile = @"mp4;m4v;mov";
            }
            break;
        case Category_PodCasts:
            if (isSupportConvert) {
                if (isSupportVideo) {
                    _supportFile = @"mp3;m4a;rm;wma;wav;mdi;m4v;wmv;mkv;flv";
                } else {
                    _supportFile = @"mp3;m4a;wma;wav;rm;mdi";
                }
            } else {
                if (isSupportVideo) {
                    _supportFile = @"mp3;m4v;mp4";
                } else {
                    _supportFile = @"mp3";
                }
            }
            break;
        case Category_VoiceMemos:
            if (isSupportConvert) {
                _supportFile = @"mp3;m4a;m4r;wma;wav;rm;mdi";
            } else {
                _supportFile = @"m4a";
            }
            break;
        case Category_Ringtone:
            if (isSupportConvert) {
                _supportFile = @"mp3;m4a;m4r;wma;wav;rm;mdi;ogg;flac";
            } else {
                _supportFile = @"m4r";
            }
            break;
        case Category_TVShow:
            if (isSupportConvert) {
                _supportFile = @"mp4;m4v;mov;wmv;rmvb;mkv;avi;flv;rm";
            } else {
                _supportFile = @"mp4;m4v;mov";
            }
            break;
            
        case Category_Audiobook:
            if (isSupportConvert) {
                _supportFile = @"mp3;m4a;m4b;m4p;wma;wav;rm;mdi";
            } else {
                _supportFile = @"mp3;m4b;m4a;m4p";
            }
            break;
        case Category_iTunesU:
            if (isSupportConvert) {
                if (isSupportVideo) {
                    _supportFile = @"mp3;m4a;wma;wav;rm;mdi;mp4;m4v;mov;wmv;rmvb;mkv;avi;flv";
                } else {
                    _supportFile = @"mp3;m4a;wma;wav;rm;mdi";
                }
            } else {
                if (isSupportVideo) {
                    _supportFile = @"mp3;m4v;mp4";
                } else {
                    _supportFile = @"mp3";
                }
            }
            
            break;
        case Category_iBookCollections:
        case Category_iBooks:
            _supportFile = @"epub;pdf";
            break;
            
        case Category_Applications:
            _supportFile = @"ipa;pxl";
            break;
            
        case Category_PhotoLibrary:
        case Category_MyAlbums:
            _supportFile = @"png;jpg;gif;bmp;jpeg;tiff";
            break;
            
        default:
            break;
    }
    return _supportFile;
}

+ (NSMutableArray *)filterSupportArrayWithIpod:(IMBiPod *)ipod isSingleImport:(BOOL)isSingleImport{
    IMBSoftWareInfo *softwareInfo = [IMBSoftWareInfo singleton];
    BOOL isSupportConverter = false;
    BOOL isSupportVideo = ipod.deviceInfo.isSupportVideo;
    NSMutableString *totalString = [[NSMutableString alloc] init];
    if(ipod.deviceInfo.isSupportMusic){
        NSString *music = [MediaHelper getSupportFileTypeArray:Category_Music supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",music]];
    }
    if(ipod.deviceInfo.isSupportMovie){
        NSString *movie = [MediaHelper getSupportFileTypeArray:Category_Movies supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",movie]];
        
    }
    if(ipod.deviceInfo.isSupportMV){
        NSString *mv = [MediaHelper getSupportFileTypeArray:Category_MusicVideo supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",mv]];
        
    }
    if(ipod.deviceInfo.isSupportMovie){
        NSString *podcast = [MediaHelper getSupportFileTypeArray:Category_PodCasts supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",podcast]];
        
    }
    if(ipod.deviceInfo.isSupportPodcast){
        NSString *podcast = [MediaHelper getSupportFileTypeArray:Category_Movies supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",podcast]];
        
    }
    if(ipod.deviceInfo.isSupportVoiceMemo){
        NSString *voicememo = [MediaHelper getSupportFileTypeArray:Category_VoiceMemos supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",voicememo]];
        
    }
    if(ipod.deviceInfo.isSupportRingtone){
        NSString *ringtone = [MediaHelper getSupportFileTypeArray:Category_Ringtone supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",ringtone]];
        
    }
    if(ipod.deviceInfo.isSupportTVShow){
        NSString *tvshow = [MediaHelper getSupportFileTypeArray:Category_TVShow supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",tvshow]];
        
    }
    if(ipod.deviceInfo.isSupportAudioBook){
        NSString *audioBook = [MediaHelper getSupportFileTypeArray:Category_Audiobook supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",audioBook]];
        
    }
    if(ipod.deviceInfo.isSupportiTunesU){
        NSString *itunesu = [MediaHelper getSupportFileTypeArray:Category_iTunesU supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",itunesu]];
        
    }
    if(ipod.deviceInfo.isSupportApplication){
        NSString *application = [MediaHelper getSupportFileTypeArray:Category_Applications supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",application]];
        
    }
    if(ipod.deviceInfo.isSupportiBook){
        NSString *ibooks = [MediaHelper getSupportFileTypeArray:Category_iBooks supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",ibooks]];
        
    }
    if(ipod.deviceInfo.isSupportPhoto){
        NSString *photo = [MediaHelper getSupportFileTypeArray:Category_PhotoLibrary supportVideo:isSupportVideo supportConvert:isSupportConverter withiPod:ipod];
        [totalString appendString:[NSString stringWithFormat:@";%@",photo]];
    }
    if ([totalString hasPrefix:@";"]) {
        NSString *finalString = [totalString substringFromIndex:1];
        [totalString release];
        totalString = nil;
        totalString = [finalString mutableCopy];
    }
    
    NSMutableArray *finalArray = [NSMutableArray array];
    NSArray *extensionArray = [totalString componentsSeparatedByString:@";"];
    for (NSString *extension in extensionArray) {
        if ([finalArray containsObject:extension]) {
            continue;
        }
        else{
            [finalArray addObject:extension];
        }
    }
    [totalString release];
    totalString = nil;
    return finalArray;
}


+ (NSString*)getRandomBookName {
    srandom((unsigned int)time((time_t *)NULL));
    return [NSString stringWithFormat:@"%ld%ld", random(), random()];
}

+ (void)getEpubopfInfo:(NSString *)opfPath inDic:(NSMutableDictionary *)infoDic{
    NSFileManager *fmg = [NSFileManager defaultManager];
    if (![fmg fileExistsAtPath:opfPath]) {
        return;
    }
    
    NSDictionary *fileInfoDic = [fmg attributesOfItemAtPath:opfPath error:nil];
    if (fileInfoDic != nil && [fileInfoDic count] > 0) {
        NSString *fileType = [fileInfoDic objectForKey:NSFileType];
        if ([NSFileTypeRegular isEqualToString:fileType]) {
            if ([[opfPath pathExtension] isEqualToString:@"opf"]) {
                [infoDic setObject:[MediaHelper getFileMd5Hash:opfPath] forKey:@"file-package-hash"];
                NSData *data = [NSData dataWithContentsOfFile:opfPath];
                
                if (data != nil) {
                    NSError *error = nil;
                    NSDictionary *dic = [XMLReader dictionaryForXMLData:data error:&error];
                    if (error != nil) {
                        NSLog(@"%@",error);
                    }
                    
                    NSString *uuid = nil;
                    
                    id identifier = [[[dic objectForKey:@"package"] objectForKey:@"metadata"] objectForKey:@"dc:identifier"];
                    if ([identifier isKindOfClass:[NSDictionary class]]) {
                        uuid = [identifier objectForKey:@"text"];
                    }
                    else if([identifier isKindOfClass:[NSArray class]]){
                        NSArray *array = (NSArray *)identifier;
                        for (NSDictionary *diction in array) {
                            if ([diction.allKeys containsObject:@"opf:scheme"]) {
                                NSString *numStr = [diction objectForKey:@"opf:scheme"];
                                if ([numStr isEqualToString:@"UUID"]) {
                                    uuid = [diction objectForKey:@"text"];
                                }
                            }
                        }
                    }
                    
                    NSDictionary *package = [dic objectForKey:@"package"];
                    NSString *name = [[[package objectForKey:@"metadata"] objectForKey:@"dc:title"] objectForKey:@"text"];
                    NSString *album = name;
                    id dcCreator = [[package objectForKey:@"metadata"] objectForKey:@"dc:creator"];
                    NSString *artist = @"";
                    if ([dcCreator isKindOfClass:[NSDictionary class]]) {
                        artist = [(NSDictionary *)dcCreator objectForKey:@"text"];
                    }else if ([dcCreator isKindOfClass:[NSArray class]]) {
                        NSArray *dcArray = (NSArray *)dcCreator;
                        if (dcArray.count > 0) {
                            NSDictionary *dcDic = [dcArray objectAtIndex:0];
                            if ([dcDic isKindOfClass:[NSDictionary class]] &&
                                [dcDic.allKeys containsObject:@"text"]) {
                                artist = [dcDic objectForKey:@"text"];
                            }
                        }
                    }
                    
                    NSString *genre = name;
                    
                    if (![self stringIsNilOrEmpty:uuid]) {
                        [infoDic setObject:uuid forKey:@"uuid"];
                    }
                    if (![self stringIsNilOrEmpty:name]) {
                        [infoDic setObject:name forKey:@"name"];
                    }
                    if (![self stringIsNilOrEmpty:album]) {
                        [infoDic setObject:album forKey:@"album"];
                    }
                    if (![self stringIsNilOrEmpty:artist]) {
                        [infoDic setObject:artist forKey:@"artist"];
                    }
                    if (![self stringIsNilOrEmpty:genre]) {
                        [infoDic setObject:genre forKey:@"genre"];
                    }
                }
            }
            
        } else if ([NSFileTypeDirectory isEqualToString:fileType]) {
            [MediaHelper getEpubDetailInfo:opfPath inDic:infoDic];
        }
    }
}


+ (void)getEpubDetailInfo:(NSString *)opfPath inDic:(NSMutableDictionary *)infoDic
{
    NSFileManager *fmg = [NSFileManager defaultManager];
    if (![fmg fileExistsAtPath:opfPath]) {
        return;
    }
    NSArray *tempArray = [fmg contentsOfDirectoryAtPath:opfPath error:nil];
    if (tempArray != nil && [tempArray count] > 0) {
        NSString *temPath = @"";
        for (NSString *item in tempArray) {
            temPath = [opfPath stringByAppendingPathComponent:item];
            
            NSDictionary *fileInfoDic = [fmg attributesOfItemAtPath:temPath error:nil];
            if (fileInfoDic != nil && [fileInfoDic count] > 0) {
                NSString *fileType = [fileInfoDic objectForKey:NSFileType];
                if ([NSFileTypeRegular isEqualToString:fileType]) {
                    if ([[temPath pathExtension] isEqualToString:@"opf"]) {
                        [infoDic setObject:[MediaHelper getFileMd5Hash:temPath] forKey:@"file-package-hash"];
                        NSData *data = [NSData dataWithContentsOfFile:temPath];
                        if (data != nil) {
                            NSError *error = nil;
                            NSDictionary *dic = [XMLReader dictionaryForXMLData:data error:&error];
                            if (error != nil) {
                                NSLog(@"%@",error);
                                break;
                            }
                            
                            NSString *uuid = nil;
                            
                            id identifier = [[[dic objectForKey:@"package"] objectForKey:@"metadata"] objectForKey:@"dc:identifier"];
                            if ([identifier isKindOfClass:[NSDictionary class]]) {
                                uuid = [identifier objectForKey:@"text"];
                            }
                            else if([identifier isKindOfClass:[NSArray class]]){
                                NSArray *array = (NSArray *)identifier;
                                for (NSDictionary *diction in array) {
                                    if ([diction.allKeys containsObject:@"opf:scheme"]) {
                                        NSString *numStr = [diction objectForKey:@"opf:scheme"];
                                        if ([numStr isEqualToString:@"UUID"]) {
                                            uuid = [diction objectForKey:@"text"];
                                        }
                                    }
                                }
                            }
                            NSString *name = [[[[dic objectForKey:@"package"] objectForKey:@"metadata"] objectForKey:@"dc:title"] objectForKey:@"text"];
                            NSString *album = name;
                            NSString *artist = nil;
                            id dccreator = [[[dic objectForKey:@"package"] objectForKey:@"metadata"] objectForKey:@"dc:creator"];
                            if ([dccreator isKindOfClass:[NSArray class]]) {
                                if ([dccreator count]>=1) {
                                    artist = [[dccreator objectAtIndex:0] objectForKey:@"text"];
                                }
                            }else if ([dccreator isKindOfClass:[NSDictionary class]]){
                                artist = [dccreator objectForKey:@"text"];
                            }
                            NSString *genre = name;
                            if (![self stringIsNilOrEmpty:uuid]) {
                                [infoDic setObject:uuid forKey:@"uuid"];
                            }
                            if (![self stringIsNilOrEmpty:name]) {
                                [infoDic setObject:name forKey:@"name"];
                            }
                            if (![self stringIsNilOrEmpty:album]) {
                                [infoDic setObject:album forKey:@"album"];
                            }
                            if (![self stringIsNilOrEmpty:artist]) {
                                [infoDic setObject:artist forKey:@"artist"];
                            }
                            if (![self stringIsNilOrEmpty:genre]) {
                                [infoDic setObject:genre forKey:@"genre"];
                            }
                        }
                    }
                    
                } else if ([NSFileTypeDirectory isEqualToString:fileType]) {
                    [self getEpubDetailInfo:temPath inDic:infoDic];
                }
            }
        }
    }
}

+ (NSString *)getFileMd5Hash:(NSString *)path{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        NSLog(@"no file was found");
        return @"";
    }
    else{
        NSData *data = [NSData dataWithContentsOfFile:path];
        //        NSString *fileString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSError *error = nil;
        if (error != nil) {
            NSLog(@"error:%@",error);
            return @"";
        }
        else{
            NSString *md5 = [[NSString MD5FromData:data] uppercaseString];
            return md5;
        }
    }
}

+ (NSString *)createPhotoUUID:(NSString *)UUIDValue {
    NSMutableString *stringUUID = [NSMutableString stringWithCapacity:[UUIDValue length]+4];
    if (UUIDValue.length > 10) {
        NSString *str1 = [UUIDValue substringWithRange:NSMakeRange(0, 8)];
        NSString *str2 = [UUIDValue substringWithRange:NSMakeRange(8, 4)];
        NSString *str3 = [UUIDValue substringWithRange:NSMakeRange(12, 4)];
        NSString *str4 = [UUIDValue substringWithRange:NSMakeRange(16, 4)];
        NSString *str5 = [UUIDValue substringWithRange:NSMakeRange(20, UUIDValue.length - 20)];
        [stringUUID appendFormat:@"%@-%@-%@-%@-%@",str1,str2,str3,str4,str5];
    }else{
        NSString *string = @"00000000-0000-0000-0000-000000000000";
        string = [string substringWithRange:NSMakeRange(0, string.length - UUIDValue.length)];
        [stringUUID appendFormat:@"%@%@",string,UUIDValue];
    }
    NSString *string = [stringUUID uppercaseString];
    return string;
}

//16进制的NSString转换成NSData
+(NSData *)My16NSStringToNSData:(NSString *)string{
    int j=0;
    Byte bytes[string.length];  ///3ds key的Byte 数组， 128位
    for(int i=0;i<[string length];i++)
    {
        
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [string characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9'){
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        }else if(hex_char1 >= 'A' && hex_char1 <='F'){
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        }else{
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        }
        i++;
        unichar hex_char2 = [string characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9'){
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        }else if(hex_char2 >= 'A' && hex_char2 <='F'){
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        }else{
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        }
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    NSData *newData = [[[NSData alloc] initWithBytes:bytes length:string.length/2]autorelease];
    return newData;
}

+ (NSString *)getAppCachePathInIpod:(IMBiPod *)ipod{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tmpPath = @"";
    if (ipod != nil) {
        tmpPath = ipod.session.sessionFolderPath;
        if (![fileManager fileExistsAtPath:tmpPath]) {
            [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *appTmpPath = [tmpPath stringByAppendingPathComponent:@"Application"];
        if (![fileManager fileExistsAtPath:appTmpPath]) {
            [fileManager createDirectoryAtPath:appTmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return appTmpPath;
    }
    return tmpPath;
}

//分析并创建曲目在制定的目录下;
+ (IMBNewTrack*)analyCreateTrack:(NSString*)filePath selectCategory:(CategoryNodesEnum)selectCategory {
    
    BOOL isvideo = [MediaHelper isVideoFile:filePath];
    IMBMediaInfo *mediaInfo = [IMBMediaInfo singleton];
    mediaInfo.isVideo = isvideo;
    [mediaInfo openWithFilePath:filePath];
    if (!mediaInfo.isGotMetaData) {
        return nil;
    }
    IMBNewTrack *newTrack = [[IMBNewTrack alloc]init];
    [newTrack setFilePath:filePath];
    [newTrack setFileExtension:[filePath pathExtension]];
    newTrack.fileSize = [mediaInfo.fileSize unsignedIntValue];
    [newTrack setBitrate:[mediaInfo.bitRate intValue]];
    [newTrack setLength:[mediaInfo.length intValue]];
    [newTrack setTrackNumber:[mediaInfo.track intValue]];
    [newTrack setYear:[mediaInfo.year intValue]];
    [newTrack setDiscNumber:0];
    [newTrack setAlbumTrackCount:0];
    [newTrack setTitle:mediaInfo.title];
    
    if (selectCategory == Category_VoiceMemos) {
        [newTrack setArtist:@"Voice Memos"];
        [newTrack setAlbum:@"Voice Memos"];
        [newTrack setAlbumArtist:@"Voice Memos"];
        [newTrack setIsVideo:NO];
    }
    else{
        //不为空
        if ([mediaInfo artist].length == 0) {
            [newTrack setArtist:@"Unknown Artist"];
        }
        else{
            [newTrack setArtist:[mediaInfo artist]];
        }
        if([mediaInfo album].length == 0){
            [newTrack setAlbum:@"Unknown Album"];
        }
        else{
            [newTrack setAlbum:[mediaInfo album]];
        }
        
        if([mediaInfo albumArtist].length == 0){
            [newTrack setAlbumArtist:newTrack.artist];
        }
        else{
            [newTrack setAlbumArtist:[mediaInfo albumArtist]];
        }
        [newTrack setIsVideo:isvideo];
    }
    [newTrack setGenre:[mediaInfo genre]];
    [newTrack setSampleRate:[[mediaInfo sampleRate] intValue]];
    [newTrack setAudioChannels:[[mediaInfo channels] intValue]];
    [MediaHelper getMediaType:newTrack selectCategory:selectCategory];
    if([newTrack isVideo])
    {
        IMBVideoImageAcquire *videoAC = [[IMBVideoImageAcquire alloc] initwithLocalPath:filePath];
        if (selectCategory == Category_HomeVideo || selectCategory == Category_MusicVideo|| selectCategory == Category_TVShow) {
            videoAC.isMovies = NO;
        }else{
            videoAC.isMovies = YES;
        }
        NSString *artworkPath = [videoAC getVideoArtWork];
        [newTrack setArtworkFile:artworkPath];
    }else
    {
        [newTrack setArtworkFile:mediaInfo.artworkPath];
    }
    return [newTrack autorelease];
}

+ (IMBNewTrack*)createBlankTrack:(NSString*)filePath selectCategory:(CategoryNodesEnum)selectCategory {
    IMBNewTrack *newTrack = [[IMBNewTrack alloc] init];
    [newTrack setFilePath:filePath];
    [newTrack setFileExtension:[filePath pathExtension]];
    NSFileManager *fm = [NSFileManager defaultManager];
    newTrack.fileSize= (uint)[[fm attributesOfItemAtPath:filePath error:nil] fileSize];
    [newTrack setAlbum:@"Unknown Album"];
    [newTrack setArtist:@"Unknown Artist"];
    [newTrack setBitrate:0];
    [newTrack setGenre:@""];
    [newTrack setLength:0];
    [newTrack setTrackNumber:0];
    [newTrack setAlbumArtist:@"Unknown Artist"];
    [newTrack setComposer:@""];
    [newTrack setYear:0];
    [newTrack setComments:@""];
    [newTrack setDiscNumber:0];
    [newTrack setTotalDiscCount:0];
    [newTrack setAlbumTrackCount:0];
    [newTrack setIsVideo:[MediaHelper isVideoFile:filePath]];
    [newTrack setTitle:[[[filePath pathComponents] lastObject] stringByDeletingPathExtension]];
    [newTrack setSampleRate:0];
    [newTrack setAudioChannels:0];
    
    [MediaHelper getMediaType:newTrack selectCategory:selectCategory];
    return [newTrack autorelease];
}

//从IMBTrack得到一个新的Track。
+ (IMBNewTrack*)createTrackByIMBTrack:(IMBTrack*)track containRatingAndPlayCount:(BOOL)containRatingAndPlayCount {
    IMBNewTrack *newTrack = [[[IMBNewTrack alloc] init] autorelease];
    newTrack.filePath = track.filePath;
    [newTrack setFileExtension:[track.filePath pathExtension]];
    newTrack.fileSize= track.fileSize;
    if ([track artist].length == 0) {
        [newTrack setArtist:@"Unknown Artist"];
    }
    else{
        [newTrack setArtist:[track artist]];
    }
    if([track album].length == 0){
        [newTrack setAlbum:@"Unknown Album"];
    }
    else{
        [newTrack setAlbum:[track album]];
    }
    if ([track albumArtist].length == 0) {
        [newTrack setAlbumArtist:@"Unknown Album"];
    }
    else{
        [newTrack setAlbumArtist:[track albumArtist]];
    }
    
    newTrack.album = track.album;
    newTrack.artist = track.artist;
    newTrack.bitrate = track.bitrate;
    newTrack.genre = track.genre;
    newTrack.length = track.length;
    newTrack.trackNumber = track.trackNumber;
    newTrack.albumArtist = track.albumArtist;
    newTrack.composer = track.composer;
    newTrack.year = track.year;
    newTrack.comments = track.comment;
    newTrack.discNumber = track.discNumber;
    newTrack.totalDiscCount = track.totalDiscCount;
    newTrack.albumTrackCount = track.albumTrackCount;
    newTrack.title = track.title;
    newTrack.isVideo = track.isVideo;
    newTrack.sampleRate = track.sampleRate;
    if (containRatingAndPlayCount)
    {
        newTrack.playCount = track.playCount;
        newTrack.rating = track.ratingInt;
        newTrack.lastPalyed = track.dateLastPalyed;
    }
    else
    {
        newTrack.playCount = 0;
        newTrack.rating = 0;
        newTrack.lastPalyed = 0;
    }
    newTrack.audioChannels = track.audioChannels;
    newTrack.dBMediaType = track.mediaType;
    newTrack.artworkFile = @"";
    return newTrack;
}

+ (NSString *)getMediaArtwork:(NSString *)filePath {
    NSString *artworkPath = nil;
    IMBMediaInfo *mediaInfo = [IMBMediaInfo singleton];
    [mediaInfo openWithFilePath:filePath];
    if (mediaInfo.artworkPath != nil) {
        artworkPath = [NSString stringWithString:mediaInfo.artworkPath];
    }
    return artworkPath;
}

+ (BOOL)isVideoFile:(NSString*)filePath {
    if (filePath != nil && [[filePath.pathExtension lowercaseString] containsString:@"m4v" options:NSCaseInsensitiveSearch] == YES) {
        return YES;
    }
    if (filePath != nil && [[filePath.pathExtension lowercaseString] containsString:@"mp4" options:NSCaseInsensitiveSearch] == YES) {
        return YES;
    }
    if (filePath != nil && [[filePath.pathExtension lowercaseString] containsString:@"mov" options:NSCaseInsensitiveSearch] == YES) {
        return YES;
    }
    if (filePath != nil && [[filePath.pathExtension lowercaseString] containsString:@"wmv" options:NSCaseInsensitiveSearch] == YES) {
        return YES;
    }
    return NO;
}

+ (void)getMediaType:(IMBNewTrack*)newTrack selectCategory:(CategoryNodesEnum)selectCategory {
    switch (selectCategory) {
        case Category_Movies:
            [newTrack setDBMediaType:Video];
            break;
            
        case Category_Music:
            [newTrack setDBMediaType:Audio];
            break;
            
        case Category_MusicVideo:
            [newTrack setDBMediaType:MusicVideo];
            break;
            
        case Category_PodCasts:
            if ([newTrack isVideo] == YES) {
                [newTrack setDBMediaType:VideoPodcast];
            } else {
                [newTrack setDBMediaType:Podcast];
            }
            break;
            
        case Category_Ringtone:
            [newTrack setDBMediaType:Ringtone];
            break;
            
        case Category_TVShow:
            [newTrack setDBMediaType:TVShow];
            break;
            
        case Category_VoiceMemos:
            [newTrack setDBMediaType:VoiceMemo];
            break;
            
        case Category_Audiobook:
            [newTrack setDBMediaType:Audiobook];
            break;
            
        case Category_FileSystem:
            break;
            
        case Category_Applications:
            break;
            
        case Category_iTunesU:
            if ([newTrack isVideo] == YES) {
                [newTrack setDBMediaType:iTunesUVideo];
            } else {
                [newTrack setDBMediaType:iTunesU];
            }
            break;
            
        case Category_Summary:
            [MediaHelper checkMediaType:newTrack];
            break;
            
        case Category_HomeVideo:
            [newTrack setDBMediaType:HomeVideo];//对比一下wins
            break;
        default:
            [MediaHelper checkMediaType:newTrack];
            break;
    }
}

+ (void)checkMediaType:(IMBNewTrack*)newTrack {
    if ([newTrack isVideo] == YES) {
        [newTrack setDBMediaType:Video];
    } else {
        [newTrack setDBMediaType:Audio];
    }
    if ([[[newTrack filePath] lowercaseString] isEqualToString:@".m4b"] == YES) {
        [newTrack setDBMediaType:Audiobook];
    }
}

+ (NSData*)cigFromWebserviceWithPath:(NSString*)plistPath withUUID:(NSString*)UUID withGrappaData:(NSData*)grappaData isSuccess:(BOOL *)isSuccess {
    int bufferSize = 10240;
    int offset = 0;
    NSDate *now = [[NSDate alloc] init];
    NSString *plistId = [NSString stringWithFormat:@"%@%f",UUID,[now timeIntervalSince1970]];
    NSLog(@"plistID%@", plistId);
    [now release];
    NSData *plistData = [[NSData alloc] initWithContentsOfFile:plistPath];
    //Todo 这个地方需要放到某个地方
    NSLog(@"grappaData:%@",[grappaData description]);
    bool webResult = false;
    if (plistData != nil && plistData.length > 0) {
        while (true) {
            if (offset + bufferSize <= plistData.length - 1 ) {
                NSLog(@"offset1: %d", offset);
                NSRange range = NSMakeRange(offset, bufferSize);
                NSData *bufferData = [plistData subdataWithRange:range];
                //反复调用3次
                for (int i= 0; i < 3; i++) {
                    webResult = [MediaHelper uploadFileContentsWithPlistIdentify:plistId WithData:bufferData Offset:offset];
                    if (webResult == true) break;
                }
                offset += bufferSize;
                NSLog(@"offset2: %d", offset);
                
            } else {
                NSLog(@"offset3: %d", offset);
                NSRange range = NSMakeRange(offset, plistData.length - offset);
                NSData *bufferData = [plistData subdataWithRange:range];
                //反复调用3次
                for (int i= 0; i < 3; i++) {
                    webResult = [MediaHelper uploadFileContentsWithPlistIdentify:plistId WithData:bufferData Offset:offset];
                    if (webResult == true) break;
                }
                NSLog(@"offset4: %d", offset);
                
                break;
            }
        }
    } else {
        NSLog(@"plistData is nil");
        NSLog(@"plistPath %@",plistPath);
    }
    
    
    if (webResult) {
        uint8_t hash[20] = { 0x00 };
        uint8_t *buf = (uint8_t*)[plistData bytes];
        SHA_CTX content;
        SHA1_Init(&content);
        SHA1_Update(&content, buf, plistData.length);
        SHA1_Final(hash, &content);
        NSData *hashSha1 = [NSData dataWithBytes:hash length:20];
        NSLog(@"hash:%@", [hashSha1 description]);
        NSLog(@"length:%d", plistData.length);
        
        for (int i= 0; i < 3; i++) {
            webResult = [MediaHelper uploadPlistCompleteWithPlistIdentify:plistId WithHashSha1:hashSha1 FileLength:plistData.length];
            if (webResult == true) break;
        }
    }
    if (webResult) {
        NSData* cigData = [MediaHelper caclCIGWithPlistIdentify:plistId WithGrappaData:grappaData isSuccess:isSuccess];
        return cigData;
    } else {
        *isSuccess = NO;
    }
    
    return nil;
}

+ (bool) uploadFileContentsWithPlistIdentify:(NSString*) plistIdentify WithData:(NSData*) plistData Offset:(int) offset {
    //NSURL *url = [NSURL URLWithString:@"http://pallas.com.sumdumbo.com/WebService3.asmx"];
    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.112/WebApplication1/WebService3.asmx"];
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    NSString *netPath = [soft.domainNetwork stringByAppendingString:@"CF8FIE29DG.asmx"];
    NSURL *url = [NSURL URLWithString:netPath];
    NSString *nameSpace = @"http://tempuri.org/";
    
    WSMethodInvocationRef mySoapRef = WSMethodInvocationCreate((CFURLRef)url, (CFStringRef)@"U3B81FBDEA90F4C", kWSSOAP2001Protocol);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:plistIdentify, @"plistIdentify", plistData, @"data",[NSNumber numberWithInt:offset] , @"offset",nil];
    
    NSArray *paramOrder = [NSArray arrayWithObjects:@"plistIdentify", @"offset", @"data", nil];
    WSMethodInvocationSetParameters(mySoapRef, (CFDictionaryRef)params, (CFArrayRef)paramOrder);
    
    /*NSString *userName = [@"ABCBDAB9460B" sha1];
     NSString *password = [@"D8D4A9588F78" sha1];
     NSDictionary *reqHeaders = [NSDictionary dictionaryWithObjectsAndKeys:nameSpace, @"MySoapHeader", userName, @"UserName", password, @"PassWord", nil];*/
    NSDictionary *reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@%@", nameSpace, @"U3B81FBDEA90F4C"] forKey:@"SOAPAction"];
    WSMethodInvocationSetProperty(mySoapRef, kWSSOAPMethodNamespaceURI,
                                  (CFStringRef)nameSpace);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPExtraHeaders,
                                  (CFDictionaryRef)reqHeaders);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPFollowsRedirects,
                                  kCFBooleanTrue);
    // set debug props
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingHeaders,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingHeaders,
                                  kCFBooleanTrue);
    NSDictionary *result = nil;
    @try {
        result = (NSDictionary *)WSMethodInvocationInvoke(mySoapRef);
        NSLog(@"resultDir:%@", [result description]);
    }
    @catch (NSException *exception) {
        NSLog(@"NSException %@", exception.description);
    }
    if (result != nil) {
        // get HTTP response from SOAP request so we can see the status code
        CFHTTPMessageRef res = nil;
        res = (CFHTTPMessageRef)[result objectForKey:(id)kWSHTTPResponseMessage];
        NSDictionary *resultDir = [result objectForKey:@"/Result"];
        
        NSArray *keyArr = [resultDir allKeys];
        NSString *resStr = nil;
        for (NSString *key in keyArr) {
            resStr = [resultDir valueForKey:key];
        }
        NSLog(@"resStr:%@",resStr);
        bool ret = [resStr boolValue];
        NSLog(@"ret:%d",ret);
        [result release];
        return ret;
    }
    return false;
}

+ (bool) uploadPlistCompleteWithPlistIdentify:(NSString*) plistIdentify WithHashSha1:(NSData*) hashSha1 FileLength:(long) fileLength {
    //NSURL *url = [NSURL URLWithString:@"http://pallas.com.sumdumbo.com/WebService3.asmx"];
    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.112/WebApplication1/WebService3.asmx"];
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    NSString *netPath = [soft.domainNetwork stringByAppendingString:@"CF8FIE29DG.asmx"];
    NSURL *url = [NSURL URLWithString:netPath];
    
    NSString *nameSpace = @"http://tempuri.org/";
    
    WSMethodInvocationRef mySoapRef = WSMethodInvocationCreate((CFURLRef)url, (CFStringRef)@"U4ADC50PC61599C", kWSSOAP2001Protocol);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:nameSpace, @"MySoapHeader", plistIdentify, @"plistIdentify", hashSha1, @"hash",[NSNumber numberWithLong:fileLength] , @"plistFileLength",nil];
    
    NSArray *paramOrder = [NSArray arrayWithObjects:@"plistIdentify", @"plistFileLength",  @"hash", nil];
    WSMethodInvocationSetParameters(mySoapRef, (CFDictionaryRef)params, (CFArrayRef)paramOrder);
    
    NSDictionary *reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@%@", nameSpace, @"U4ADC50PC61599C"] forKey:@"SOAPAction"];
    WSMethodInvocationSetProperty(mySoapRef, kWSSOAPMethodNamespaceURI,
                                  (CFStringRef)nameSpace);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPExtraHeaders,
                                  (CFDictionaryRef)reqHeaders);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPFollowsRedirects,
                                  kCFBooleanTrue);
    // set debug props
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingHeaders,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingHeaders,
                                  kCFBooleanTrue);
    
    NSDictionary *result = (NSDictionary *)WSMethodInvocationInvoke(mySoapRef);
    NSLog(@"resultDir:%@", [result description]);
    // get HTTP response from SOAP request so we can see the status code
    CFHTTPMessageRef res = nil;
    res = (CFHTTPMessageRef)[result objectForKey:(id)kWSHTTPResponseMessage];
    NSDictionary *resultDir = [result objectForKey:@"/Result"];
    
    NSArray *keyArr = [resultDir allKeys];
    NSString *resStr = nil;
    for (NSString *key in keyArr) {
        resStr = [resultDir valueForKey:key];
    }
    bool ret = [resStr boolValue];
    NSLog(@"ret:%d",ret);
    [result release];
    return ret;
    
}

/*
 // 注册服务
 $soap->register('caclCIG',
 array("plistIdentify"=>"xsd:string","GrappaData"=>"xsd:base64Binary"), // 输入参数的定义
 array("return"=>"xsd:string") // 返回参数的定义
 );
 */
+ (NSData*)caclCIGWithPlistIdentify:(NSString*) plistIdentify WithGrappaData:(NSData*) grappa isSuccess:(BOOL *)isSuccess {
    //NSURL *url = [NSURL URLWithString:@"http://pallas.com.sumdumbo.com/WebService3.asmx"];
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    NSString *netPath = [soft.domainNetwork stringByAppendingString:@"CF8FIE29DG.asmx"];
    NSURL *url = [NSURL URLWithString:netPath];
    NSString *nameSpace = @"http://tempuri.org/";
    
    WSMethodInvocationRef mySoapRef = WSMethodInvocationCreate((CFURLRef)url, (CFStringRef)@"C4822IBA196D46G", kWSSOAP2001Protocol);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:plistIdentify, @"plistIdentify", grappa, @"GrappaData",nil];
    
    NSArray *paramOrder = [NSArray arrayWithObjects:@"plistIdentify", @"GrappaData", nil];
    WSMethodInvocationSetParameters(mySoapRef, (CFDictionaryRef)params, (CFArrayRef)paramOrder);
    
    /*NSString *userName = [@"ABCBDAB9460B" sha1];
     NSString *password = [@"D8D4A9588F78" sha1];
     NSDictionary *reqHeaders = [NSDictionary dictionaryWithObjectsAndKeys:nameSpace, @"MySoapHeader", userName, @"UserName", password, @"PassWord", nil];*/
    NSDictionary *reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@%@", nameSpace, @"C4822IBA196D46G"] forKey:@"SOAPAction"];
    WSMethodInvocationSetProperty(mySoapRef, kWSSOAPMethodNamespaceURI,
                                  (CFStringRef)nameSpace);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPExtraHeaders,
                                  (CFDictionaryRef)reqHeaders);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPFollowsRedirects,
                                  kCFBooleanTrue);
    // set debug props
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingHeaders,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingHeaders,
                                  kCFBooleanTrue);
    
    NSDictionary *result = (NSDictionary *)WSMethodInvocationInvoke(mySoapRef);
    NSLog(@"resultDir:%@", [result description]);
    // get HTTP response from SOAP request so we can see the status code
    CFHTTPMessageRef res = nil;
    res = (CFHTTPMessageRef)[result objectForKey:(id)kWSHTTPResponseMessage];
    NSDictionary *resultDir = [result objectForKey:@"/Result"];
    NSArray *keyArr = [resultDir allKeys];
    NSString *hashStr = nil;
    for (NSString *key in keyArr) {
        hashStr = [resultDir valueForKey:key];
    }
    if (hashStr.length == 0) {
        *isSuccess = NO;
    } else {
        *isSuccess = YES;
    }
    NSData *data = [hashStr hexToBytes];
    [result release];
    return data;
}

+ (NSString *)getFileDataMd5Hash:(NSData *)data
{
    if (data == nil) {
        return @"";
    }
    else{
        NSString *md5 = [[NSString MD5FromData:data] uppercaseString];
        return md5;
    }
}

+ (void)killiTunes
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:[NSArray arrayWithObjects:@"iTunes",nil]];
    [task launch];
    [task release];
}

//获取文件大小
+ (long long)getFileLength:(NSString*)filePath {
    long fileSize = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *fileInfo = [fm attributesOfItemAtPath:filePath error:nil];
    if (fileInfo != nil) {
        fileSize = [[fileInfo valueForKey:NSFileSize] longLongValue];
    }
    return fileSize;
}

@end
