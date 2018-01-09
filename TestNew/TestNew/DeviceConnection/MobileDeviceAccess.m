//
//  MobileDeviceAccess.m
//  MobileDeviceAccess
//
//  Created by Jeff Laing on 6/08/09.
//  Copyright 2009 Tristero Computer Systems. All rights reserved.
//
#import "MobileDeviceAccess.h"
#include <unistd.h>
#include <stdlib.h>
#include <syslog.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/statvfs.h>
#include <sys/dirent.h>
#include <mach/error.h>
#include <AppKit/NSApplication.h>
#include "NSString+Category.h"
//#include "NSData+Base64.h"
#include "NSData+Category.h"
#include "NSDictionary+Category.h"
#import <CommonCrypto/CommonDigest.h>
#import "IMBNotificationDefine.h"
#import <AppKit/AppKit.h>
#pragma mark MobileDevice.framework internals
// opaque structures
typedef struct _afc_directory			*afc_directory;
typedef struct _afc_dictionary			*afc_dictionary;
typedef struct _afc_operation			*afc_operation;

// Messages passed to device notification callbacks: passed as part of
// am_device_notification_callback_info.
typedef enum {
	ADNCI_MSG_CONNECTED		= 1,
	ADNCI_MSG_DISCONNECTED	= 2,
	ADNCI_MSG_UNSUBSCRIBED	= 3
} adnci_msg;

struct am_device_notification_callback_info {
	am_device	dev;				// 0    device
	uint32_t	msg;				// 4    one of adnci_msg
} __attribute__ ((packed));

// The type of the device notification callback function.
typedef void (*am_device_notification_callback)(struct am_device_notification_callback_info *,void* callback_data);

// notification related functions
mach_error_t AMDeviceNotificationSubscribe(
	am_device_notification_callback callback,
	uint32_t unused0,
	uint32_t unused1,
	void *callback_data,
	am_device_notification *notification);

mach_error_t AMDeviceNotificationUnsubscribe(
	am_device_notification subscription);

// device related functions
mach_error_t	AMDeviceConnect(am_device device);
mach_error_t	AMDeviceDisconnect(am_device device);
uint32_t		AMDeviceGetInterfaceType(am_device device);
//uint32_t		AMDeviceGetInterfaceSpeed(am_device device);
//uint32_t		AMDeviceGetConnectionID(am_device device);
//CFStringRef		AMDeviceCopyDeviceIdentifier(am_device device);
CFStringRef		AMDeviceCopyValue(am_device device, CFStringRef domain,CFStringRef key);
mach_error_t    AMDeviceSetValue(am_device device, CFStringRef domain, CFStringRef name, CFTypeRef value);
mach_error_t	AMDeviceRetain(am_device device);
mach_error_t	AMDeviceRelease(am_device device);

// I can see these in the framework, but they don't seem to be exported
// in a way that lets us link directly against them
//?notexp? CFStringRef AMDeviceCopyDeviceLocation(am_device device);
//		looks to just return dword[device+28]
//?notexp? uint32_t AMDeviceUSBDeviceID(am_device device);
//?notexp? uint32_t AMDeviceUSBLocationID(am_device device);
//?notexp? uint32_t AMDeviceUSBProductID(am_device device);

int AMDevicePair(am_device device);
int AMDeviceIsPaired(am_device device);
// 000039f5 T _AMDevicePair (am_device)
mach_error_t AMDeviceValidatePairing(am_device device);
// 000037e6 T _AMDeviceUnpair (am_device)

mach_error_t AMDeviceLookupApplications(am_device device, CFStringRef apptype, CFDictionaryRef *result);

// 0000251f T _AMDeviceActivate (am_device, int32 )
// 000088ad T _AMDeviceArchiveApplication (am_device, int32, int32, int32, int32)
// 0000891e T _AMDeviceBrowseApplications (am_device, int32)
// 00008ecd T _AMDeviceCheckCapabilitiesMatch
// 0000179b T _AMDeviceConvertError
// 00009063 T _AMDeviceCopyProvisioningProfiles
// 00004133 T _AMDeviceCreate
// 000041d7 T _AMDeviceCreateFromProperties
// 0000243d T _AMDeviceDeactivate (am_device)
// 0000235b T _AMDeviceEnterRecovery (am_device)
// 00008c74 T _AMDeviceInstallApplication
// 0000a598 T _AMDeviceInstallPackage
// 00008f59 T _AMDeviceInstallProvisioningProfile
// 0000159a T _AMDeviceIsValid
// 00008710 T _AMDeviceLookupApplicationArchives
// 00008990 T _AMDeviceLookupApplications (am_device, int32, int32)
// 00009353 T _AMDeviceMountImage
// 000087cb T _AMDeviceRemoveApplicationArchive
// 00008fde T _AMDeviceRemoveProvisioningProfile
// 00002608 T _AMDeviceRemoveValue
// 0000883c T _AMDeviceRestoreApplication
// 0000121a T _AMDeviceSerialize
// 0000280f T _AMDeviceSetValue(am_device, CFStringRef, CFStringRef, CFTypeRef)
// 00005ec5 T _AMDeviceSoftwareUpdate
// 0000794b T _AMDeviceTransferApplication
// 00008a91 T _AMDeviceUninstallApplication
// 0000a232 T _AMDeviceUninstallPackage
// 00003e21 T _AMDeviceUnserialize
// 00008b02 T _AMDeviceUpgradeApplication
// 000035d3 T _AMDeviceValidatePairing

// session related functions

mach_error_t AMDeviceStartSession(am_device device);
mach_error_t AMDeviceStopSession(am_device device);
// service related functions
mach_error_t AMDeviceStartService(am_device device,CFStringRef service_name,am_service *handle,uint32_t *unknown);
mach_error_t AMDeviceSecureStartService(am_device device, CFStringRef service_name, uint32_t *unknown, am_service *handle);
uint32 AMDServiceConnectionGetSocket(am_service handle);
mach_error_t AMDServiceConnectionInvalidate(am_service service);
// 00002f48 T _AMDeviceStartServiceWithOptions
// 000067f9 T _AMDeviceStartHouseArrestService

uint32_t AMDeviceSetWirelessBuddyFlags(am_device device, uint32_t wifi);
uint32_t AMDeviceGetWirelessBuddyFlags(am_device device, uint32_t *wifi);

//  stop backuprestore
mach_error_t AMSCancelBackupRestore(CFStringRef lpudid);

// AFC connection functions
afc_error_t AFCConnectionOpen(am_service handle,uint32_t io_timeout,afc_connection *conn);
afc_error_t AFCConnectionClose(afc_connection conn);
// int _AFCConnectionIsValid(afc_connection *conn)
uint32_t AFCConnectionGetContext(afc_connection conn);
uint32_t AFCConnectionSetContext(afc_connection conn, uint32_t ctx);
uint32_t AFCConnectionGetFSBlockSize(afc_connection conn);
uint32_t AFCConnectionSetFSBlockSize(afc_connection conn, uint32_t size);
uint32_t AFCConnectionGetIOTimeout(afc_connection conn);
uint32_t AFCConnectionSetIOTimeout(afc_connection conn, uint32_t timeout);
uint32_t AFCConnectionGetSocketBlockSize(afc_connection conn);
uint32_t AFCConnectionSetSocketBlockSize(afc_connection conn, uint32_t size);

CFStringRef AFCCopyErrorString(afc_connection a);
CFTypeRef AFCConnectionCopyLastErrorInfo(afc_connection a);

// 0001b8e6 T _AFCConnectionCopyLastErrorInfo
// 0001a8b6 T _AFCConnectionCreate
// 0001b8ca T _AFCConnectionGetStatus
// 0001a867 T _AFCConnectionGetTypeID
// 0001ae99 T _AFCConnectionInvalidate
// 0001b8c1 T _AFCConnectionProcessOperations
// 0001abdc T _AFCConnectionScheduleWithRunLoop
// 0001b623 T _AFCConnectionSubmitOperation
// 0001ad5a T _AFCConnectionUnscheduleFromRunLoop

// 000000000000603e T _AFCConnectionProcessOperations
// 0000000000005df8 T _AFCConnectionSetCallBack
// 00000000000064cc T _AFCConnectionSubmitOperation

// 0000000000008512 t _AFCLockCreate
// 0000000000007a83 t _AFCLockFree
// 00000000000084db t _AFCLockGetTypeID
// 0000000000007e69 t _AFCLockLock
// 00000000000083f2 t _AFCLockTryLock
// 000000000000810c t _AFCLockUnlock

const char * AFCGetClientVersionString(void);		// "@(#)PROGRAM:afc  PROJECT:afc-80"

// directory related functions
afc_error_t AFCDirectoryOpen(afc_connection conn,const char *path,afc_directory *dir);
afc_error_t AFCDirectoryRead(afc_connection conn,afc_directory dir,char **dirent);
afc_error_t AFCDirectoryClose(afc_connection conn,afc_directory dir);

afc_error_t AFCDirectoryCreate(afc_connection conn,const char *dirname);
afc_error_t AFCRemovePath(afc_connection conn,const char *dirname);
afc_error_t AFCRenamePath(afc_connection conn,const char *from,const char *to);
afc_error_t AFCLinkPath(afc_connection conn,uint64_t mode, const char *target,const char *link);
//	NSLog(@"linkpath returned %#lx",AFCLinkPath(_afc,(1=hard,2=sym)"/tmp/aaa","/tmp/bbb"));

// file i/o functions
afc_error_t AFCFileRefOpen(afc_connection conn, const char *path, uint64_t mode,afc_file_ref *ref);
afc_error_t AFCFileRefClose(afc_connection conn,afc_file_ref ref);
afc_error_t AFCFileRefSeek(afc_connection conn,	afc_file_ref ref, int64_t offset, uint64_t mode);
afc_error_t AFCFileRefTell(afc_connection conn, afc_file_ref ref, uint64_t *offset);
afc_error_t AFCFileRefRead(afc_connection conn,afc_file_ref ref,void *buf, afc_long *len);
afc_error_t AFCFileRefSetFileSize(afc_connection conn,afc_file_ref ref, afc_long offset);
afc_error_t AFCFileRefWrite(afc_connection conn,afc_file_ref ref, const void *buf, afc_long len);
afc_error_t AFCFileRefLock(afc_connection conn, afc_file_ref ref);
afc_error_t AFCFileRefUnlock(afc_connection conn, afc_file_ref ref);
// afc_error_t AFCFileRefLock(afc_connection *conn, afc_file_ref ref, ...);
// 00019747 T _AFCFileRefUnlock
// device/file information functions
afc_error_t AFCDeviceInfoOpen(afc_connection conn, afc_dictionary *info);
afc_error_t AFCFileInfoOpen(afc_connection conn, const char *path, afc_dictionary *info);
afc_error_t AFCKeyValueRead(afc_dictionary dict, const char **key, const char **val);
afc_error_t AFCKeyValueClose(afc_dictionary dict);

// Notification stuff - only call these on "com.apple.mobile.notification_proxy" (AMSVC_NOTIFICATION_PROXY)
mach_error_t AMDPostNotification(am_service socket, CFStringRef notification, CFStringRef userinfo);
mach_error_t AMDShutdownNotificationProxy(am_service socket);
mach_error_t AMDObserveNotification(am_service socket, CFStringRef notification);
typedef void (*NOTIFY_CALLBACK)(CFStringRef notification, void* data);
mach_error_t AMDListenForNotifications(am_service socket, NOTIFY_CALLBACK cb, void* data);

// New style - seems to formalise the creation of the "request packet" seperately
// from the execution.
afc_error_t AFCConnectionProcessOperation(afc_connection a1, afc_operation op, double timeout);
afc_error_t AFCOperationGetResultStatus(afc_operation op);
CFTypeRef AFCOperationGetResultObject(afc_operation op);
CFTypeID AFCOperationGetTypeID(afc_operation op);
// 0000000000002dd3 T _AFCOperationGetState
// 00000000000030c5 T _AFCOperationCopyPacketData
afc_error_t AFCOperationSetContext(afc_operation op, void *ctx);
void *AFCOperationGetContext(afc_operation op);

// each of these returns an op, with the appropriate request encoded.  The value of ctx is
// available via AFCOperationGetContext()
afc_operation AFCOperationCreateGetConnectionInfo(CFAllocatorRef allocator, void *ctx);
afc_operation AFCOperationCreateGetDeviceInfo(CFAllocatorRef allocator, void *ctx);
afc_operation AFCOperationCreateGetFileHash(CFAllocatorRef allocator, CFStringRef filename, void *ctx);
afc_operation AFCOperationCreateGetFileInfo(CFAllocatorRef allocator, CFStringRef filename, void *ctx);
afc_operation AFCOperationCreateLinkPath(CFAllocatorRef allocator, uint32_t mode, CFStringRef filename1, CFStringRef filename2, void *ctx);
afc_operation AFCOperationCreateMakeDirectory(CFAllocatorRef allocator, CFStringRef filename, void *ctx);
afc_operation AFCOperationCreateOpenFile(CFAllocatorRef allocator, CFStringRef filename, void *ctx);
afc_operation AFCOperationCreateReadDirectory(CFAllocatorRef allocator, CFStringRef filename, void *ctx);
afc_operation AFCOperationCreateRemovePath(CFAllocatorRef allocator, CFStringRef filename, void *ctx);
afc_operation AFCOperationCreateRenamePath(CFAllocatorRef allocator, CFStringRef oldname, CFStringRef newname, void *ctx);
afc_operation AFCOperationCreateSetConnectionOptions(CFAllocatorRef allocator, CFDictionaryRef dict, void *ctx);
afc_operation AFCOperationCreateSetModTime(CFAllocatorRef allocator, CFStringRef filename, uint64_t mtm, void *ctx);

@interface AMDevice(Private)
- (am_service)_startService:(NSString*)name isSecure:(BOOL)isSecure;
@end

@implementation AMService

@synthesize lasterror = _lasterror;
@synthesize delegate = _delegate;
@synthesize isSecure = _isSecure;

- (void)clearLastError
{
    if (_lasterror) {
        [_lasterror release];
        _lasterror = nil;
    }
}

- (void)setLastError:(NSString*)msg
{
	[self clearLastError];
	_lasterror = [msg retain];
}

- (void)performDelegateSelector:(SEL)sel
			  		 withObject:(id)info
{
	if (_delegate) {
		if ([_delegate respondsToSelector:sel]) {
			[_delegate performSelector:sel withObject:info];
		}
	}
}

- (void)dealloc
{
	[_lasterror release];
	[super dealloc];
}

- (id)initWithName:(NSString*)name onDevice:(AMDevice*)device isSecure:(BOOL)isSecure
{
    
	if (self = [super init]) {
		_isSecure = isSecure;
		_delegate = nil;
		_service = [device _startService:name isSecure:isSecure];
		if (_service == 0) {
			[self release];
			return nil;
		}
        _serviceIsOpen = YES;
        if (_isSecure) {
            socket_fd = AMDServiceConnectionGetSocket(_service);
        } else {
            socket_fd = (int)_service;
        }
	}
	return self;
}

+ (AMService*)serviceWithName:(NSString *)name onDevice:(AMDevice*)device
{
    BOOL isSecure = [device isWifiConnection];
	return [[[AMService alloc] initWithName:name onDevice:device isSecure:isSecure] autorelease];
}

- (BOOL)disConnectService {
    if (_isSecure) {
        if (_serviceIsOpen) {
            return (AMDServiceConnectionInvalidate(_service) == 0);
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}

- (uint32_t)sendRaw:(char*)data withLength:(uint32_t)length {
    if (data == nil || length == 0) {
        return 0;
    }
    int sock = socket_fd;
    uint32_t sent = 0;
    while (sent < length) {
        uint32_t n = (uint32_t)send(sock, data+sent, length-sent, 0);
        if (n <= 0) {
            break;
        }
        sent += n;
    }
    return sent;
}

- (uint32_t)receiveRaw:(char*)data withLength:(uint32_t)length {
    if (data == nil || length == 0) {
        return 0;
    }
    int sock = socket_fd;
    uint32_t received = 0;
    while (received < length) {
        uint32_t n = (uint32_t)recv(sock, data+received, length-received, 0);
        if (n <= 0) {
            break;
        }
        received += n;
    }
    return received;
}

- (uint32_t)sendRawData:(NSData*)data {
    uint32_t sendByteCnt = 0;
    if (data == nil || data.length == 0) {
        return sendByteCnt;
    }
    uint8_t *bytes = (uint8_t*)data.bytes;
    uint32_t length = (uint32_t)data.length;
    uint32_t sz;
    int sock = socket_fd;
    sz = htonl(length);
    if (send(sock, &sz, sizeof(sz), 0) != sizeof(sz)) {
        [self setLastError:@"Can't send data size"];
    } else {
        uint32_t sent = 0;
        while (sent < length) {
            uint32_t n = (uint32_t)send(sock, bytes + sent, length - sent, 0);
            if (n <= 0) {
                break;
            }
            sent += n;
        }
        if (sent != length) {
            [self setLastError:@"Can't send data bytes"];
        } else {
            [self clearLastError];
            sendByteCnt = sent;
        }
    }
    return sendByteCnt;
}

- (NSData*)receiveRawData {
    NSData *retData = nil;
    int sock = socket_fd;
    uint32_t length;
    uint32_t sz;
    if (sizeof(sz) != recv(sock, &sz, sizeof(sz), 0)) {
        [self setLastError:@"Can't receive reply size"];
    } else {
        length = ntohl(sz);
        if (length) {
            unsigned char *buff = malloc(length);
            uint32_t received = 0;
            while (received < length) {
                uint32_t n = (uint32_t)recv(sock, buff+received, length-received, 0);
                if (n <= 0) {
                    break;
                }
                received += n;
            }
            if (received == length) {
                retData = [NSData dataWithBytes:buff length:received];
            } else {
                retData = nil;
            }
            free(buff);
        }
    }
    return retData;
}

- (bool)sendXMLRequest:(id)message
{
	bool result = NO;
	CFPropertyListRef messageAsXML = CFPropertyListCreateXMLData(NULL, message);
	if (messageAsXML) {
		CFIndex xmlLength = CFDataGetLength(messageAsXML);
		uint32_t sz;
		int sock = socket_fd; // (int)_service;
		sz = htonl(xmlLength);
		if (send(sock, &sz, sizeof(sz), 0) != sizeof(sz)) {
			[self setLastError:@"Can't send message size"];
		} else {
			if (send(sock, CFDataGetBytePtr(messageAsXML), xmlLength,0) != xmlLength) {
				[self setLastError:@"Can't send message text"];
			} else {
				[self clearLastError];
				result = YES;
			}
		}
		CFRelease(messageAsXML);
	} else {
		[self setLastError:@"Can't convert request to XML"];
	}
	return(result);
}

- (id)readXMLReply
{
	id result = nil;
	int sock = socket_fd; // (int)((uint32_t)_service);
	uint32_t sz;

	/* now wait for the reply */

	if (sizeof(uint32_t) != recv(sock, &sz, sizeof(sz), 0)) {
		[self setLastError:@"Can't receive reply size"];
	} else {
		sz = ntohl(sz);
		if (sz) {
			// we need to be careful in here, because there is a fixed buffer size in the
			// socket, and it may be smaller than the message we are going to recieve.  we
			// need to allocate a buffer big enough for the final result, but loop calling
			// recv() until we recieve the complete reply.
			unsigned char *buff = malloc(sz);
			unsigned char *p = buff;
			uint32_t left = sz;
			while (left) {
				uint32_t rc = (uint32_t)recv(sock, p, left,0);
				if (rc==0) {
					[self setLastError:[NSString stringWithFormat:@"Reply was truncated, expected %d more bytes",left]];
					free(buff);
					return(nil);
				}
				left -= rc;
				p += rc;
			}
			CFDataRef r = CFDataCreateWithBytesNoCopy(0,buff,sz,kCFAllocatorNull);
			CFPropertyListRef reply = CFPropertyListCreateFromXMLData(0,r,0,0);
//			CFPropertyListRef reply = CFPropertyListCreateWithData(0,(CFDataRef)plistdata, kCFPropertyListImmutable, NULL, NULL);
			CFRelease(r);
			free(buff);
			result = [[(id)reply copy] autorelease];
			CFRelease(reply);
			[self clearLastError];
		}
	}

	return(result);
}

- (NSInputStream*)inputStreamFromSocket
{
	CFReadStreamRef s;
	int sock = (int)((uint32_t)_service);

	CFStreamCreatePairWithSocket(
		kCFAllocatorDefault, (CFSocketNativeHandle)sock, &s, NULL);
	return [(NSInputStream*)s autorelease];
}

/*
am_service socket;
AMDeviceStartService(dev, CFSTR("com.apple.mobile.notification_proxy"), &socket, NULL);
AMDPostNotification(socket, CFSTR("com.apple.itunes-mobdev.syncWillStart"), NULL);
AMDPostNotification(socket, &CFSTR("com.apple.itunes-mobdev.syncDidFinish"), NULL);
AMDShutdownNotificationProxy(socket);
*/
@end

@implementation AFCFileReference

@synthesize lasterror = _lasterror;

- (void)clearLastError
{
	[_lasterror release];
	_lasterror = nil;
}

- (void)setLastError:(NSString*)msg
{
	[self clearLastError];
	_lasterror = [msg retain];
}

- (bool)checkStatus:(afc_error_t)ret from:(const char *)func
{
	if (ret != 0) {
		[self setLastError:[NSString stringWithFormat:@"%s failed: %d",func,ret]];
		return NO;
	}
	[self clearLastError];
	return YES;
}

- (bool)ensureFileIsOpen
{
	if (_ref) return YES;
	[self setLastError:@"File is not open"];
	return NO;
}

- (void)dealloc
{
	[self closeFile];
	[_lasterror release];
	[super dealloc];
}

- (id)initWithPath:(NSString*)path reference:(afc_file_ref)ref afc:(afc_connection)afc
{
	if (self=[super init]) {
		_ref = ref;
		_afc = afc;
	}
	return self;
}

- (bool)closeFile
{
	if (![self ensureFileIsOpen]) return NO;
	if (![self checkStatus:AFCFileRefClose(_afc, _ref) from:"AFCFileRefClose"]) return NO;
	_ref = 0;
	return YES;
}

- (bool)seek:(int64_t)offset mode:(int)m
{
	if (![self ensureFileIsOpen]) return NO;
	return [self checkStatus:AFCFileRefSeek(_afc, _ref, offset, m) from:"AFCFileRefSeek"];
}

- (bool)tell:(uint64_t*)offset
{
	if (![self ensureFileIsOpen]) return NO;
	return [self checkStatus:AFCFileRefTell(_afc, _ref, offset) from:"AFCFileRefTell"];
}

- (afc_long)readN:(afc_long)n bytes:(char *)buff
{
    //NSLog(@"ensureFileIsOpen before");
	if (![self ensureFileIsOpen]) return NO;
	afc_long afcSize = n;
	if (![self checkStatus:AFCFileRefRead(_afc, _ref, buff, &afcSize) from:"AFCFileRefRead"]) return 0;
    //NSLog(@"ensureFileIsOpen after afcSize");
    return afcSize;
}

- (bool)writeN:(afc_long)n bytes:(const char *)buff
{
	if (![self ensureFileIsOpen]) return NO;
	if (n>0) {
		return [self checkStatus:AFCFileRefWrite(_afc, _ref, buff, n) from:"AFCFileRefWrite"];
	}
	return YES;
}

- (bool)writeNSData:(NSData*)data
{
	return [self writeN:[data length] bytes:[data bytes]];
}

- (bool)setFileSize:(uint64_t)size
{
	if (![self ensureFileIsOpen]) return NO;
	return [self checkStatus:AFCFileRefSetFileSize(_afc, _ref, size) from:"AFCFileRefSetFileSize"];
}

- (void)lock:(int)tries {
    BOOL ret = NO;
    @try {
        for (int i = 0; i < tries; i++) {
            ret = [self checkStatus:AFCFileRefLock(_afc, _ref) from:"AFCFileRefLock"];
            if (ret == YES) {
                break;
            }
            [NSThread sleepForTimeInterval:250];
        }
    }
    @catch (NSException *exception) {
        ret = NO;
    }
}

- (void)unLock {
    BOOL ret = NO;
    @try {
        ret = [self checkStatus:AFCFileRefUnlock(_afc, _ref) from:"AFCFileRefUnlock"];
    }
    @catch (NSException *exception) {
        ret = NO;
    }
}

@end

@implementation AFCDirectoryAccess

- (void)dealloc
{
	NSLog(@"deallocating %@",self);
	if (_afc) [self close];
	[super dealloc];
}

- (bool)checkStatus:(int)ret from:(const char *)func
{
	if (ret != 0) {
        //TODO 这个地方出过莫名的错误。
		[self setLastError:[NSString stringWithFormat:@"%s failed: Return code = 0x%04X",func,ret]];
		return NO;
	}
	[self clearLastError];
	return YES;
}

- (bool)ensureConnectionIsOpen
{
	if (_afc) return YES;
	[self setLastError:@"Connection is not open"];
	return NO;
}

- (void)close
{
	if (_afc) {
		NSLog(@"disconnecting");
		int ret = AFCConnectionClose(_afc);
		if (ret != 0) {
			NSLog(@"AFCConnectionClose failed: %d", ret);
		}
		_afc = nil;
	}
}

- (NSMutableDictionary*)readAfcDictionary:(afc_dictionary)dict
{
	NSMutableDictionary *result = [[[NSMutableDictionary alloc] init] autorelease];
	const char *k, *v;
	while (0 == AFCKeyValueRead(dict, &k, &v)) {
		if (!k) break;
		if (!v) break;

		// if all the characters in the value are digits, pass it back as
		// as 'long long' in a dictionary - else pass it back as a string
		const char *p;
		for (p=v; *p; p++) if (*p<'0' | *p>'9') break;
		if (*p) {
			/* its a string */
			[result setObject:[NSString stringWithUTF8String:v] forKey:[NSString stringWithUTF8String:k]];
		} else {
			[result setObject:[NSNumber numberWithLongLong:atoll(v)] forKey:[NSString stringWithUTF8String:k]];
		}
	}
	return result;
}

// retrieve a dictionary of information describing the device
// {
//		FSFreeBytes = 93876224
//		FSBlockSize = 4096
//		FSTotalBytes = 524288000
//		Model = iPod1,1
// }
- (NSDictionary*)deviceInfo
{
	if (![self ensureConnectionIsOpen]) return nil;
	afc_dictionary dict;
	if ([self checkStatus:AFCDeviceInfoOpen(_afc, &dict) from:"AFCDeviceInfoOpen"]) {
		NSMutableDictionary *result = [self readAfcDictionary:dict];
		AFCKeyValueClose(dict);
		[self clearLastError];
		return [NSDictionary dictionaryWithDictionary:result];
	}
	return nil;
}

/***

/dev/console
2009-08-07 20:10:11.331 MobileDeviceAccess[7284:10b]  st_blocks = 0
2009-08-07 20:10:11.331 MobileDeviceAccess[7284:10b]  st_nlink = 1
2009-08-07 20:10:11.332 MobileDeviceAccess[7284:10b]  st_size = 0
2009-08-07 20:10:11.333 MobileDeviceAccess[7284:10b]  st_ifmt = S_IFCHR

/dev/disk1
2009-08-07 20:11:35.842 MobileDeviceAccess[7296:10b]  st_blocks = 0
2009-08-07 20:11:35.843 MobileDeviceAccess[7296:10b]  st_nlink = 1
2009-08-07 20:11:35.844 MobileDeviceAccess[7296:10b]  st_size = 0
2009-08-07 20:11:35.844 MobileDeviceAccess[7296:10b]  st_ifmt = S_IFBLK

****/
// var/mobile/Media
// 2009-08-06 23:38:04.070 MobileDeviceAccess[1823:813]  st_blocks = 0
// 2009-08-06 23:38:04.071 MobileDeviceAccess[1823:813]  st_nlink = 11
// 2009-08-06 23:38:04.071 MobileDeviceAccess[1823:813]  st_size = 476
// 2009-08-06 23:38:04.072 MobileDeviceAccess[1823:813]  st_ifmt = S_IFDIR

// jailbreak.log
// 2009-08-06 23:37:23.089 MobileDeviceAccess[1800:813]  st_blocks = 64
// 2009-08-06 23:37:23.089 MobileDeviceAccess[1800:813]  st_nlink = 1
// 2009-08-06 23:37:23.090 MobileDeviceAccess[1800:813]  st_size = 29260
// 2009-08-06 23:37:23.091 MobileDeviceAccess[1800:813]  st_ifmt = S_IFREG
//    "st_birthtime" = 9223372036854775807;
//    "st_mtime" = 280689926000000000;

// /Applications
// 2009-08-06 23:39:01.872 MobileDeviceAccess[1864:813]  st_blocks = 8
// 2009-08-06 23:39:01.872 MobileDeviceAccess[1864:813]  st_nlink = 1
// 2009-08-06 23:39:01.876 MobileDeviceAccess[1864:813]  st_size = 27
// 2009-08-06 23:39:01.877 MobileDeviceAccess[1864:813]  st_ifmt = S_IFLNK
// 2009-08-06 23:39:01.873 MobileDeviceAccess[1864:813]  LinkTarget = /var/stash/Applications.pwn

-(void) fix_date_entry:(NSString*)key in:(NSMutableDictionary *)dict
{
	id d = [dict objectForKey:key];
	if (d) {
		long v = [d doubleValue] / 1000000000.0;
		d = [NSDate dateWithTimeIntervalSince1970:v];
		[dict setObject:d forKey:key];
	}
}

- (NSDictionary*)getFileInfo:(NSString*)path
{
	if (!path) {
		[self setLastError:@"Input path is nil"];
		return nil;
	}

	if ([self ensureConnectionIsOpen]) {
		afc_dictionary dict;
		if ([self checkStatus:AFCFileInfoOpen(_afc, [path UTF8String], &dict) from:"AFCFileInfoOpen"]) {
			NSMutableDictionary *result = [self readAfcDictionary:dict];
			[result setObject:path forKey:@"path"];
			AFCKeyValueClose(dict);
			[self clearLastError];

			// fix the ones we know are dates
			[self fix_date_entry:@"st_birthtime" in:result];
			[self fix_date_entry:@"st_mtime" in:result];
			return [NSDictionary dictionaryWithDictionary:result];
		}
	}
	return nil;
}

- (BOOL)fileExistsAtPath:(NSString *)path
{
	if (!path) {
		[self setLastError:@"Input path is nil"];
		return NO;
	}
	if ([self ensureConnectionIsOpen]) {
		afc_dictionary dict;
		if (AFCFileInfoOpen(_afc, [path UTF8String], &dict)==0) {
			AFCKeyValueClose(dict);
			[self clearLastError];
			return YES;
		}
	}
	return NO;
}

- (NSArray*)directoryContents:(NSString*)path
{
	if (!path) {
		[self setLastError:@"Input path is nil"];
		return nil;
	}

	if (![self ensureConnectionIsOpen]) return nil;
	afc_directory dir;
	if ([self checkStatus:AFCDirectoryOpen(_afc,[path UTF8String],&dir) from:"AFCDirectoryOpen"]) {
		NSMutableArray *result = [NSMutableArray new];
		while (1) {
			char *d = NULL;
			AFCDirectoryRead(_afc,dir,&d);
			if (!d) break;
			if (*d=='.') {
				if (d[1]=='\000') continue;			// skip '.'
				if (d[1]=='.') {
					if (d[2]=='\000') continue;		// skip '..'
				}
			}
			[result addObject:[NSString stringWithUTF8String:d]];
		}
		AFCDirectoryClose(_afc,dir);
		[self clearLastError];
		return [NSArray arrayWithArray:[result autorelease]];
	}

	// ret=4: path is a file
	// ret=8: can't open path
	return nil;
}

static BOOL read_dir( AFCDirectoryAccess *self, afc_connection afc, NSString *path, NSMutableArray *files )
{
	BOOL result;

	afc_directory dir;
	int ret = AFCDirectoryOpen(afc,[path UTF8String],&dir);

	if (ret == 4) {
		// its a file, so add it in and return
		[files addObject:path];
		return YES;
	}

	if (ret != 0) {
		// something other than a file causes us to fail
		return [self checkStatus:ret from:"AFCDirectoryOpen"];
	}

	// collect us, with a trailing slash, since we are a directory
    
	[files addObject:[NSString stringWithFormat:@"%@/",path]];

	// build a list of all the files located here.
	NSMutableArray *here = [NSMutableArray new];
	while (1) {
		char *d = NULL;
		AFCDirectoryRead(afc,dir,&d);
		if (!d) break;
		if (*d=='.') {
			if (d[1]=='\000') continue;			// skip '.'
			if (d[1]=='.') {
				if (d[2]=='\000') continue;		// skip '..'
			}
		}
		[here addObject:[NSString stringWithFormat:@"%@/%@",path,[NSString stringWithUTF8String:d]]];
	}
	AFCDirectoryClose(afc,dir);

	// step through everything we found and add to the array
	result = YES;
	for (NSString *f in here) {
		if (!read_dir(self, afc, f, files)) {
			result = NO;
			break;
		}
	}
	[here release];

	return result;
}

static BOOL read_currdir(AFCDirectoryAccess *self, afc_connection afc, NSString *path, NSMutableArray *files) {
    BOOL result;
    
	afc_directory dir;
	int ret = AFCDirectoryOpen(afc,[path UTF8String],&dir);
    
	if (ret == 4) {
		// its a file, so add it in and return
		[files addObject:path];
		return YES;
	}
    
	if (ret != 0) {
		// something other than a file causes us to fail
		return [self checkStatus:ret from:"AFCDirectoryOpen"];
	}
    
	// collect us, with a trailing slash, since we are a directory
    
	[files addObject:[NSString stringWithFormat:@"%@/",path]];
    
	// build a list of all the files located here.
	while (1) {
		char *d = NULL;
		AFCDirectoryRead(afc,dir,&d);
		if (!d) break;
		if (*d=='.') {
			if (d[1]=='\000') continue;			// skip '.'
			if (d[1]=='.') {
				if (d[2]=='\000') continue;		// skip '..'
			}
		}
        [files addObject:[NSString stringWithFormat:@"%@/%@",path,[NSString stringWithUTF8String:d]]];
	}
	AFCDirectoryClose(afc,dir);
	result = YES;
	return result;
}

- (NSArray*)getItemInDirectory:(NSString*)path {
    if (!path) {
        [self setLastError:@"Input path is nil"];
		return nil;
    }
    
    if (![self ensureConnectionIsOpen]) return nil;
    
    NSMutableArray *filePaths = [NSMutableArray new];
    read_currdir(self, _afc, path, filePaths);
    if (filePaths != nil && [filePaths count] > 0) {
        NSMutableArray *unsorted = [NSMutableArray new];
        for (NSString *filePath in filePaths) {
            AMFileEntity *file = [[AMFileEntity new] autorelease];
            file.FilePath = filePath;
            file.Name = [filePath lastPathComponent];
            NSDictionary *fileInfoDic = [self getFileInfo:filePath];
            if (fileInfoDic != nil && [fileInfoDic count] > 0) {
                file.FileSize = [[fileInfoDic objectForKey:@"st_size"] longValue];
                NSString *fileType = [fileInfoDic objectForKey:@"st_ifmt"];
                if ([@"S_IFREG" isEqualToString:fileType]) {
                    file.FileType = AMRegularFile;
                } else if ([@"S_IFDIR" isEqualToString:fileType]) {
                    file.FileType = AMDirectory;
                } else if ([@"S_IFCHR" isEqualToString:fileType]) {
                    file.FileType = AMCharacterDevice;
                } else if ([@"S_IFBLK" isEqualToString:fileType]) {
                    file.FileType = AMBlockDevice;
                } else if ([@"S_IFLNK" isEqualToString:fileType]) {
                    file.FileType = AMSymbolicLink;
                }
            }
            [unsorted addObject:file];
        }
        NSArray *result = [NSArray arrayWithArray:unsorted];
        [unsorted release];
        unsorted = nil;
        return result;
    }
    [filePaths release];
    filePaths = nil;
    return nil;
}

//2013-07-07 zhangyang add
- (NSArray*)getItemInDirWithoutRootDir:(NSString*)path {
    if (!path) {
        [self setLastError:@"Input path is nil"];
		return nil;
    }
    
    if (![self ensureConnectionIsOpen]) return nil;
    
    NSMutableArray *filePaths = [NSMutableArray new];
    read_currdir(self, _afc, path, filePaths);
    if (filePaths != nil && [filePaths count] > 0) {
        NSMutableArray *unsorted = [NSMutableArray new];
        for (NSString *filePath in filePaths) {
            AMFileEntity *file = [[AMFileEntity new] autorelease];
            file.FilePath = filePath;
            file.Name = [filePath lastPathComponent];
            NSDictionary *fileInfoDic = [self getFileInfo:filePath];
            if (fileInfoDic != nil && [fileInfoDic count] > 0) {
                file.FileSize = [[fileInfoDic objectForKey:@"st_size"] longValue];
                NSString *fileType = [fileInfoDic objectForKey:@"st_ifmt"];
                if ([@"S_IFREG" isEqualToString:fileType]) {
                    file.FileType = AMRegularFile;
                } else if ([@"S_IFDIR" isEqualToString:fileType]) {
                    //过滤掉根目录
                    if ([[path stringByStandardizingPath] isEqualToString:[filePath stringByStandardizingPath]]) {
                        continue;
                    }
                    file.FileType = AMDirectory;
                } else if ([@"S_IFCHR" isEqualToString:fileType]) {
                    file.FileType = AMCharacterDevice;
                } else if ([@"S_IFBLK" isEqualToString:fileType]) {
                    file.FileType = AMBlockDevice;
                } else if ([@"S_IFLNK" isEqualToString:fileType]) {
                    file.FileType = AMSymbolicLink;
                }
            }
            [unsorted addObject:file];
        }
        NSArray *result = [NSArray arrayWithArray:unsorted];
        [unsorted release];
        unsorted = nil;
        return result;
    }
    [filePaths release];
    filePaths = nil;
    return nil;
}

- (NSArray*)recursiveDirectoryContents:(NSString*)path
{
	if (!path) {
		[self setLastError:@"Input path is nil"];
		return nil;
	}

	if (![self ensureConnectionIsOpen]) return nil;

	NSMutableArray *unsorted = [NSMutableArray new];
	if (read_dir(self, _afc, path, unsorted)) {
		[unsorted sortUsingSelector:@selector(compare:)];
		NSArray *result = [NSArray arrayWithArray:unsorted];
		[unsorted release];
		return result;
	}
	[unsorted release];
	return nil;
}

/**
 * Add By Zhangyang 2012/12/4
 * Return a array containing a list of file found
 * in the specified directory, and all subordinate directories.
 * Entries for directories will end in "/"
 * The entries for "." and ".." are not included.
 * @param path Full pathname to the directory to scan
 * Create a dictionary for each regular file
 * Keys in the result dictionary include:
 *	- \p "st_ifmt" - file type
 *		- \p "S_IFREG" - regular file
 *		- \p "S_IFDIR" - directory
 *		- \p "S_IFCHR" - character device
 *		- \p "S_IFBLK" - block device
 *		- \p "S_IFLNK" - symbolic link (see LinkTarget)
 *
 *	- \p "st_blocks" - number of disk blocks occupied by file
 *
 *	- \p "st_nlink" - number of "links" occupied by file
 *
 *	- \p "st_size" - number of "bytes" in file
 *
 *	- \p "LinkTarget" - target of symbolic link (only if st_ifmt="S_IFLNK")
 *
 *	- \p "st_birthtime" - time that file was created
 *
 *	- \p "st_mtime" - time that file was modified
 */
- (NSArray*)recursiveDirectoryContentsDics:(NSString*)path
{    
    NSArray *pathArray = [self recursiveDirectoryContents:path];
    NSMutableArray *unsorted = [NSMutableArray new];
    if (pathArray != nil) {
        //create a dic to array
        for (int i=0; i < [pathArray count];i++) {
            AMFileEntity *file = [[AMFileEntity new] autorelease];
            file.FilePath = [pathArray objectAtIndex:i];
            NSDictionary *fileDic = [self getFileInfo:(NSString*)[pathArray objectAtIndex:i]];
            if (fileDic != nil) {
                file.FileSize = [[fileDic objectForKey:@"st_size"] longValue];
                NSString *fileType = [fileDic objectForKey:@"st_ifmt"];
                if ([@"S_IFREG" isEqualToString:fileType]) {
                    file.FileType = AMRegularFile;
                }
                if ([@"S_IFDIR" isEqualToString:fileType]) {
                    file.FileType = AMDirectory;
                }
                if ([@"S_IFCHR" isEqualToString:fileType]) {
                    file.FileType = AMCharacterDevice;
                }
                if ([@"S_IFBLK" isEqualToString:fileType]) {
                    file.FileType = AMBlockDevice;
                }
                if ([@"S_IFLNK" isEqualToString:fileType]) {
                    file.FileType = AMSymbolicLink;
                }
            }
            [unsorted addObject:file];
        }
        NSArray *result = [NSArray arrayWithArray:unsorted];
		[unsorted release];
		return result;
    }
	[unsorted release];
	return nil;
}

- (BOOL)mkdir:(NSString*)path
{
	if (!path) {
		[self setLastError:@"Input path is nil"];
		return NO;
	}
	if (![self ensureConnectionIsOpen]) return NO;
	return [self checkStatus:AFCDirectoryCreate(_afc, [path UTF8String]) from:"AFCDirectoryCreate"];
}

static BOOL read_dir_size(AFCDirectoryAccess *self, afc_connection afc, NSString *path, int64_t *folderSize) {
    BOOL result;
	afc_directory dir;
	int ret = AFCDirectoryOpen(afc,[path UTF8String],&dir);
    
	if (ret == 4) {
		// its a file, so add it in and return
        NSDictionary *fileDic = [self getFileInfo:path];
        *folderSize += [[fileDic objectForKey:@"st_size"] longValue];
		return YES;
	}
    
	if (ret != 0) {
		// something other than a file causes us to fail
		return [self checkStatus:ret from:"AFCDirectoryOpen"];
	}
    
	// collect us, with a trailing slash, since we are a directory
	//[files addObject:[NSString stringWithFormat:@"%@/",path]];
    
	// build a list of all the files located here.
	NSMutableArray *here = [NSMutableArray new];
	while (1) {
		char *d = NULL;
		AFCDirectoryRead(afc,dir,&d);
		if (!d) break;
		if (*d=='.') {
			if (d[1]=='\000') continue;			// skip '.'
			if (d[1]=='.') {
				if (d[2]=='\000') continue;		// skip '..'
			}
		}
        
		[here addObject:[NSString stringWithFormat:@"%@/%@",path,[NSString stringWithUTF8String:d]]];
        
	}
	AFCDirectoryClose(afc,dir);
    
	// step through everything we found and add to the array
	result = YES;
	for (NSString *f in here) {
        if (!read_dir_size(self, afc, f, folderSize)) {
            result = NO;
			break;
        }
	}
	[here release];
    
	return result;
}

- (int64_t)getFolderSize:(NSString *)folderPath {
    int64_t folderSize = 0;
    if (!folderPath) {
        [self setLastError:@"Input path is nil"];
		return 0;
    }
    
    NSDictionary *fileDic = [self getFileInfo:folderPath];
    if (fileDic != nil) {
        NSString *fileType = [fileDic objectForKey:@"st_ifmt"];
        if ([@"S_IFDIR" isEqualToString:fileType]) {
            if (![self ensureConnectionIsOpen]) return 0;
            read_dir_size(self, _afc, folderPath, &folderSize);
        } else {
            folderSize = [[fileDic objectForKey:@"st_size"] longValue];
        }
    }
    return folderSize;
}


- (BOOL)unlink:(NSString*)path
{
	if (!path) {
		[self setLastError:@"Input path is nil"];
		return NO;
	}
	if (![self ensureConnectionIsOpen]) return NO;
	return [self checkStatus:AFCRemovePath(_afc, [path UTF8String]) from:"AFCRemovePath"];
}

- (BOOL)unlinkFolder:(NSString *)path {
    if (!path) {
        [self setLastError:@"Input path is nil"];
		return NO;
    }
    // 得到目录下的所有文件及其文件夹
    NSMutableArray *filePaths = [NSMutableArray new];
    read_currdir(self, _afc, path, filePaths);
    if (filePaths != nil && filePaths.count > 0) {
        for (int i=0; i < [filePaths count];i++) {
            NSString *filePath = [filePaths objectAtIndex:i];
            if ([[path stringByStandardizingPath] isEqualToString:[filePath stringByStandardizingPath]]) {
                continue;
            }
            NSDictionary *fileInfoDic = [self getFileInfo:filePath];
            if (fileInfoDic != nil && [fileInfoDic count] > 0) {
                // long fileSize = [[fileInfoDic objectForKey:@"st_size"] longValue];
                NSString *fileType = [fileInfoDic objectForKey:@"st_ifmt"];
                if ([@"S_IFDIR" isEqualToString:fileType] ) {
                    [self unlinkFolder:filePath];
                } else {
                    [self unlink:filePath];
                }
            }
        }
    }
    [self unlink:path];
    return YES;
}

- (BOOL)rename:(NSString*)path1 to:(NSString*)path2
{
	if (!path1) {
		[self setLastError:@"Old path is nil"];
		return NO;
	}
	if (!path2) {
		[self setLastError:@"New path is nil"];
		return NO;
	}
	if (![self ensureConnectionIsOpen]) return NO;
	return [self checkStatus:AFCRenamePath(_afc, [path1 UTF8String], [path2 UTF8String]) from:"AFCRenamePath"];
}

- (BOOL)link:(NSString*)path to:(NSString*)target
{
	if (!path) {
		[self setLastError:@"Path is nil"];
		return NO;
	}
	if (!target) {
		[self setLastError:@"Target is nil"];
		return NO;
	}
	if (![self ensureConnectionIsOpen]) return NO;
	return [self checkStatus:AFCLinkPath(_afc, 1, [target UTF8String], [path UTF8String]) from:"AFCLinkPath"];
}


- (BOOL)symlink:(NSString*)path to:(NSString*)target
{
	if (!path) {
		[self setLastError:@"Path is nil"];
		return NO;
	}
	if (!target) {
		[self setLastError:@"Target is nil"];
		return NO;
	}
	if (![self ensureConnectionIsOpen]) return NO;
	return [self checkStatus:AFCLinkPath(_afc, 2, [target UTF8String], [path UTF8String]) from:"AFCLinkPath"];
}

- (bool)processOp:(afc_operation)op from:(const char *)func
{
	BOOL result = NO;
	if ([self checkStatus:AFCConnectionProcessOperation(_afc, op, AFCConnectionGetIOTimeout(_afc)) from:"AFCConnectionProcessOperation"]) {
		afc_error_t e = AFCOperationGetResultStatus(op);
		if (e == 0) {
			[self clearLastError];
			result = YES;
		} else {
			CFTypeRef err = AFCConnectionCopyLastErrorInfo(_afc);
			if (err) {
				id msg = [(id)err objectForKey:@"NSLocalizedDescription"];
				if (msg) {
					[self setLastError:msg];
				} else {
					[self setLastError:[NSString stringWithFormat:@"Error %d occurred, no message",e]];
				}
				CFRelease(err);
			} else {
				[self setLastError:[NSString stringWithFormat:@"Error %d occurred, no error info",e]];
			}
		}
	}
	CFRelease(op);
	return result;
}

/**
 * Set file modification time for a file on the device
 * @param filename Full pathname of file to modify
 * @param modtime time to set it to
 */
- (BOOL)setmodtime:(NSString*)path to:(NSDate*)timestamp
{
	if (!path) {
		[self setLastError:@"Path is nil"];
		return NO;
	}
	if (!timestamp) {
		[self setLastError:@"timestamp is nil"];
		return NO;
	}
	if (![self ensureConnectionIsOpen]) return NO;

	double tm = [timestamp timeIntervalSince1970] * 1000000000;
	void *op = AFCOperationCreateSetModTime(NULL,(CFStringRef)path, tm, self);
	if (op) {
		return [self processOp:op from:"setmodtime:to:"];
	}
	[self setLastError:@"AFCOperationCreateSetModTime() failed"];
	return NO;
}

- (AFCFileReference*)openForRead:(NSString*)path
{
	if (![self ensureConnectionIsOpen]) return nil;
    AFCFileReference *afcFile = nil;
    @synchronized(self) {
        afc_file_ref ref = 0;
//        NSLog(@"open path:%@  socket_fd:%d  [path UTF8String]:%s  _afc:%@",path,socket_fd,[path UTF8String],_afc);
        @try {
            afc_error_t openRet = AFCFileRefOpen(_afc, [path UTF8String], 1, &ref);
            bool ret = [self checkStatus:openRet from:"AFCFileRefOpen"];
            if (ret) {
                afcFile = [[[AFCFileReference alloc] initWithPath:path reference:ref afc:_afc] autorelease];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"exception:%@",exception.reason);
        }
    }
	// if mode==0, ret=7
	// if file does not exist, ret=8
	return afcFile;
}

- (AFCFileReference*)openForWrite:(NSString*)path
{
	if (![self ensureConnectionIsOpen]) return nil;
	afc_file_ref ref;
	if ([self checkStatus:AFCFileRefOpen(_afc, [path UTF8String], 2, &ref) from:"AFCFileRefOpen"]) {
		return [[[AFCFileReference alloc] initWithPath:path reference:ref afc:_afc] autorelease];
	}
	// if mode==0, ret=7
	// if file does not exist, ret=8
	return nil;
}

- (AFCFileReference*)openForReadWrite:(NSString*)path
{
	if (![self ensureConnectionIsOpen]) return nil;
	afc_file_ref ref;
	if ([self checkStatus:AFCFileRefOpen(_afc, [path UTF8String], 3, &ref) from:"AFCFileRefOpen"]) {
		return [[[AFCFileReference alloc] initWithPath:path reference:ref afc:_afc] autorelease];
	}
	// if mode==0, ret=7
	// if file does not exist, ret=8
	return nil;
}

- (BOOL)copyLocalFile:(NSString*)path1 toRemoteFile:(NSString*)path2
{
	//NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	BOOL result = NO;
	if ([self ensureConnectionIsOpen]) {
		// make sure remote file doesn't exist
		if ([self fileExistsAtPath:path2]) {
			[self setLastError:@"Won't overwrite existing file"];
		} else {
			// ok, make sure the input file opens before creating the
			// output file
			NSFileHandle *in = [NSFileHandle fileHandleForReadingAtPath:path1];
			if (in) {
				struct stat s;
				stat([path1 fileSystemRepresentation],&s);
                uint32_t bufsz = 10240;
                long long filesize = (long long)s.st_size;
                if (filesize>102400*5) {
                    bufsz = 102400*5;
                }else if (filesize<=102400*5&&filesize>102400){
                    bufsz = 102400*5;
                }else if (filesize<=102400){
                    bufsz = 102400;
                }
				// open remote file for write
				AFCFileReference *out = [self openForWrite:path2];
				if (out) {
					// copy all content across 10K at a time
					uint64_t done = 0;
					while (1) {
                        @autoreleasepool {
                            NSData *nextblock = [in readDataOfLength:bufsz];
                            uint64_t n = [nextblock length];
                            if (n==0) break;
                            [out writeNSData:nextblock];
                            done += n;
                        }
					}
					[out closeFile];
					result = YES;
				}
				// close input file regardless
				[in closeFile];
			} else {
				// hmmm, failed to open
				[self setLastError:@"Can't open input file"];
			}
		}
	}
	return result;
}

- (BOOL)copyDataToFile:(NSData *)data toRemoteFile:(NSString *)path {
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	BOOL result = NO;
    if ([self ensureConnectionIsOpen]) {
        // make sure remote file doesn't exist
		if ([self fileExistsAtPath:path]) {
			[self setLastError:@"Won't overwrite existing file"];
		} else {
            if (data != nil) {
				// open remote file for write
				AFCFileReference *out = [self openForWrite:path];
                if (out) {
					// copy all content across 10K at a time
//					uint32_t done = 0;
                    [out writeNSData:data];
//                    done = (uint32_t)data.length;
					[out closeFile];
					result = YES;
				}
            } else {
				// hmmm, failed to open
				[self setLastError:@"NSData is empty"];
			}
        }
    }
    return result;
}

// 将一个文件夹的内容递归拷贝到设备中去
- (BOOL)copyLocalFile:(NSString*)path1 toRemoteDir:(NSString*)path2 transLength:(long*)length
{
   	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *fname;
	BOOL isdir;
	isdir = NO;
	if ([fm fileExistsAtPath:path1 isDirectory:&isdir]) {
		if (isdir) {
			// create the target directory
			NSString *basename = [path2 stringByAppendingPathComponent:[path1 lastPathComponent]];
			if (![self mkdir:basename]) return NO;
			for (fname in [fm contentsOfDirectoryAtPath:path1 error:nil]) {
				BOOL worked;
                worked = [self copyLocalFile:[path1 stringByAppendingPathComponent:fname]
                                 toRemoteDir:basename transLength:length];
				if (!worked) {
					NSLog(@"failed on %@/%@: %@",path1,fname,self.lasterror);
					return NO;
				}
			}
			return YES;
		} else {
			fname = [path1 lastPathComponent];
			NSString *dest = [path2 stringByAppendingPathComponent:fname];
			char buff[PATH_MAX+1];
			ssize_t buflen = readlink([path1 UTF8String], buff, sizeof(buff));
			if (buflen>0) {
				buff[buflen] = 0;
				return [self symlink:dest to:[NSString stringWithUTF8String:buff]];
			} else {
				return [self copyLocalFile:path1 toRemoteFile:dest];
			}
		}
	}
	return NO;
}

- (BOOL)copyRemoteFile:(NSString*)path1 toLocalFile:(NSString*)path2
{
   // NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	BOOL result = NO;
	if ([self ensureConnectionIsOpen]) {
		NSFileManager *fm = [NSFileManager defaultManager];
		// make sure local file doesn't exist
		if ([fm fileExistsAtPath:path2]) {
			[self setLastError:@"Won't overwrite existing file"];
		} else {
			// open remote file for read
			AFCFileReference *in = [self openForRead:path1];
			if (in) {
                uint32_t bufsz = 10240;
                uint32_t filesize = [[[self getFileInfo:path1] valueForKey:@"st_size"] intValue];
                if (filesize>102400*5) {
                    bufsz = 102400*5;
                }else if (filesize<=102400*5&&filesize>102400){
                    bufsz = 102400*5;
                }else if (filesize<=102400){
                    bufsz = 102400;
                }
				// open local file for write - stupidly we need to create it before
				// we can make an NSFileHandle
				[fm createFileAtPath:path2 contents:nil attributes:nil];
                NSFileHandle *out = [NSFileHandle fileHandleForWritingAtPath:path2];
				if (!out) {
					[self setLastError:@"Can't open output file"];
				} else {
					// copy all content across 10K at a time...  use
					// malloc for the buffer rather than NSData because I've noticed
					// strange problems in the debugger
                    //NSLog(@"after fileHandleForWritingAtPath1");
					char *buff = (char*)malloc(bufsz);
                    uint64_t done = 0;
					while (1) {
						uint64_t n = [in readN:bufsz bytes:buff];
						if (n==0) break;
						NSData *b2 = [[NSData alloc]
									  initWithBytesNoCopy:buff length:n freeWhenDone:NO];
						[out writeData:b2];
						[b2 release];
                        done += n;
					}
					free(buff);
                    [out closeFile];
					[self clearLastError];
					result = YES;
				}
				// close output file
				[in closeFile];
			}
		}
	}
	return result;
}

- (BOOL)asyncCopyRemoteFile:(NSString *)path1 toLocalFile:(NSString *)path2 {
    BOOL result = NO;
    if ([self ensureConnectionIsOpen]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        AFCFileReference *in = [self openForRead:path1];
        if (in) {
            [fm createFileAtPath:path2 contents:nil attributes:nil];
            NSFileHandle *out = [NSFileHandle fileHandleForWritingAtPath:path2];
            if (out) {
                //创建一个Buffer，用于存放读出的Byte字节
                uint32_t bufsz = 10240;
                uint32_t filesize = [[[self getFileInfo:path1] valueForKey:@"st_size"] intValue];
                if (filesize>102400*5) {
                    bufsz = 102400*5;
                }else if (filesize<=102400*5&&filesize>102400){
                    bufsz = 102400*5;
                }else if (filesize<=102400){
                    bufsz = 102400;
                }
                char *buff = (char*)malloc(bufsz);
                
                //创建一个AsyncState实体类，用于存在文件信息
                AsyncState *state = [[AsyncState alloc] init];
                state.fileHandle = out;
                state.dfHandle = in;
                state.fileLength = filesize;
                state.buff = buff;
                state.bufsz = bufsz;
                uint64_t length = [in readN:bufsz bytes:buff];
                if (length > 0) {
                    NSData *data = [[NSData alloc]
                                  initWithBytesNoCopy:buff length:length freeWhenDone:NO];
                    [state.bufferList addObject:data];
                    [data release];
                    [state.readLengthList addObject:[NSNumber numberWithLongLong:length]];
                    
                    //开启一个线程读取文件内容
                    [NSThread detachNewThreadSelector:@selector(doReadFile:) toTarget:self withObject:state];
                    
                    //开始异步写入文件
                    [NSThread detachNewThreadSelector:@selector(doWriteFile:) toTarget:self withObject:state];
                    
                    [state.condition lock];
                    [state.condition wait];
                    [state.condition unlock];
                }
                
                free(buff);
                [out closeFile];
                [self clearLastError];
                [state.bufferList removeAllObjects];
                [state.readLengthList removeAllObjects];
                [state release];
                state = nil;
                result = YES;
            }
            [in closeFile];
        }
    }
    return result;
}

- (void)doReadFile:(AsyncState *)state {
    while (1) {
//        memset(state.buff, 0, state.bufsz);
        uint64_t n = [state.dfHandle readN:state.bufsz bytes:state.buff];
        if (n==0) {
            state.isReaded = YES;
            break;
        }
        NSData *data = [[NSData alloc]
                        initWithBytesNoCopy:state.buff length:n freeWhenDone:NO];
        [state.bufferList addObject:data];
        [data release];
        [state.readLengthList addObject:[NSNumber numberWithLongLong:n]];
    }
}

- (void)doWriteFile:(AsyncState *)state {
    @try {
        @synchronized(state.bufferList) {
//            uint64_t length = [[state.readLengthList objectAtIndex:0] longLongValue];
            NSData *data = [state.bufferList objectAtIndex:0];
            [state.fileHandle writeData:data];
            [state.bufferList removeObjectAtIndex:0];
            [state.readLengthList removeObjectAtIndex:0];
        }
    }
    @catch (NSException *exception) {
        //IO出错
//        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"error:%@",exception.reason]];
        [state.condition lock];
        [state.condition signal];
        [state.condition unlock];
        return;
    }
    if (state.isReaded && state.bufferList.count == 0)
    {
        //写完发出完成信号
//        SuccessCount = SuccessCount + 1;
        [state.condition lock];
        [state.condition signal];
        [state.condition unlock];
    }else {
        @synchronized(state.bufferList) {
            while (1)
            {
                if (state.bufferList.count > 0)
                {
                    if (state.readLengthList.count > 0)
                    {
                        [self doWriteFile:state];
                        break;
                    }
                }
                else if (state.isReaded && state.bufferList.count == 0)
                {
//                    SuccessCount = SuccessCount + 1;
                    [state.condition lock];
                    [state.condition signal];
                    [state.condition unlock];
                    break;
                }
                [NSThread sleepForTimeInterval:0.005];
            }
        }
    }
}

//TODO 进度完成等事件未加上
- (bool)recursiveCopyFile:(NSString*)srcPath sourcAFCDir:(AFCDirectoryAccess*)sourceAFCDir toPath:(NSString*)tarPath
{
	if (!srcPath) {
		[self setLastError:@"Input path is nil"];
		return false;
	}
    
	if (![self ensureConnectionIsOpen]) return false;
    if (![sourceAFCDir ensureConnectionIsOpen]) return false;
    if (![self fileExistsAtPath:tarPath]) {
        [self mkdir:tarPath];
    }

    //这里两种方案，第一先取得所有文件个数，然后开始拷贝。可以得到文件的整体进度。
    //第二每个目录递归导入
    NSArray *array = [sourceAFCDir getItemInDirWithoutRootDir:srcPath];
    //AMRegularFile = 1,
    //AMDirectory = 2,
    //NSLog(@"file array %@", [array description]);
    int i = 0;
    for (AMFileEntity *file in array) {
        //TODO
        /*
        if (i == 0 && file.FileType == AMDirectory) {
            //过滤掉当前目录
            i++;
            continue;
        }
        */
         //NSLog(@"file.name %@", file.Name);
         //NSLog(@"file.filePath %@", file.FilePath);
        
        NSString *tarfilePath = [tarPath stringByAppendingPathComponent:file.Name];
        //NSLog(@"tarfilePath %@", tarfilePath);
        if (file.FileType == AMRegularFile) {
            [self copyFile:file.FilePath sourcAFCDir:sourceAFCDir toFile:tarfilePath];
            continue;
        }
        
        if (file.FileType == AMDirectory) {
            [self recursiveCopyFile:file.FilePath sourcAFCDir:sourceAFCDir toPath:tarfilePath];
        }
        i++;
    }
	return true;
}


//TODO 进度完成等事件未加上
- (bool)recursiveCopyFile:(NSString*)srcPath toPath:(NSString*)tarPath
{
	if (!srcPath) {
		[self setLastError:@"Input path is nil"];
		return false;
	}
    
	if (![self ensureConnectionIsOpen]) return false;
    if (![self fileExistsAtPath:tarPath]) {
        [self mkdir:tarPath];
    }
    
    //这里两种方案，第一先取得所有文件个数，然后开始拷贝。可以得到文件的整体进度。
    //第二每个目录递归导入
    NSArray *array = [self getItemInDirWithoutRootDir:srcPath];
    //AMRegularFile = 1,
    //AMDirectory = 2,
    //NSLog(@"file array %@", [array description]);
    int i = 0;
    for (AMFileEntity *file in array) {
        //TODO
        /*
         if (i == 0 && file.FileType == AMDirectory) {
         //过滤掉当前目录
         i++;
         continue;
         }
         */
        //NSLog(@"file.name %@", file.Name);
        //NSLog(@"file.filePath %@", file.FilePath);
        
        NSString *tarfilePath = [tarPath stringByAppendingPathComponent:file.Name];
        //NSLog(@"tarfilePath %@", tarfilePath);
        if (file.FileType == AMRegularFile) {
            [self copyFile:file.FilePath toFile:tarfilePath];
            continue;
        }
        
        if (file.FileType == AMDirectory) {
            [self recursiveCopyFile:file.FilePath toPath:tarfilePath];
        }
        i++;
    }
	return true;
}

- (BOOL)copyFile:(NSString*)path1 sourcAFCDir:(AFCDirectoryAccess*)sourceAFCDir toFile:(NSString*)path2
{
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	BOOL result = NO;
    if ([self ensureConnectionIsOpen] && [sourceAFCDir ensureConnectionIsOpen]) {
		if ([self fileExistsAtPath:path2]) {
            [self setLastError:@"Won't overwrite existing file"];
		} else {
			// open remote file for read
			AFCFileReference *in = [sourceAFCDir openForRead:path1];
			if (in) {
                // open local file for write - stupidly we need to create it before
				// we can make an NSFileHandle
//                NSMutableDictionary *info = [[NSMutableDictionary new] autorelease];
                //得到sourceDevice的文件的大小
                long fileSize = 0;
                NSDictionary *fileInfoDic = [sourceAFCDir getFileInfo:path1];
                if ([fileInfoDic valueForKey:@"st_size"] != nil) {
                    fileSize = [[fileInfoDic valueForKey:@"st_size"]longValue];
                }
                
				//struct stat s;
				//stat([path1 fileSystemRepresentation],&s);
				
                AFCFileReference *out = [self openForWrite:path2];
				if (out) {
					// copy all content across 10K at a time...  use
					// malloc for the buffer rather than NSData because I've noticed
					// strange problems in the debugger
					const uint32_t bufsz = 10240;
					char *buff = malloc(bufsz);
                    uint64_t totalTrasferedSize = 0;
					while (1) {
                        //long transferFileSize = 0;
						uint64_t n = [in readN:bufsz bytes:buff];
						if (n==0) break;
						NSData *b2 = [[NSData alloc]
									  initWithBytesNoCopy:buff length:n freeWhenDone:NO];
						[out writeNSData:b2];
						[b2 release];
                        totalTrasferedSize += n;
					}
					free(buff);
					[out closeFile];
					[self clearLastError];
					result = YES;
				}
				[in closeFile];
			}
		}
	}
	return result;
}

- (BOOL)copyFile:(NSString*)path1 toFile:(NSString*)path2
{
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	BOOL result = NO;
    if ([self ensureConnectionIsOpen]) {
		if ([self fileExistsAtPath:path2]) {
            [self setLastError:@"Won't overwrite existing file"];
		} else {
			// open remote file for read
			AFCFileReference *in = [self openForRead:path1];
			if (in) {
                // open local file for write - stupidly we need to create it before
				// we can make an NSFileHandle
//                NSMutableDictionary *info = [[NSMutableDictionary new] autorelease];
                //得到sourceDevice的文件的大小
                long fileSize = 0;
                NSDictionary *fileInfoDic = [self getFileInfo:path1];
                if ([fileInfoDic valueForKey:@"st_size"] != nil) {
                    fileSize = [[fileInfoDic valueForKey:@"st_size"]longValue];
                }
                
				//struct stat s;
				//stat([path1 fileSystemRepresentation],&s);
                AFCFileReference *out = [self openForWrite:path2];
				if (out) {
					// copy all content across 10K at a time...  use
					// malloc for the buffer rather than NSData because I've noticed
					// strange problems in the debugger
					const uint32_t bufsz = 10240;
					char *buff = malloc(bufsz);
                    uint32_t totalTrasferedSize = 0;
					while (1) {
                        //long transferFileSize = 0;
						uint64_t n = [in readN:bufsz bytes:buff];
						if (n==0) break;
						NSData *b2 = [[NSData alloc]
									  initWithBytesNoCopy:buff length:n freeWhenDone:NO];
						[out writeNSData:b2];
						[b2 release];
                        totalTrasferedSize += n;
					}
					free(buff);
					[out closeFile];
					[self clearLastError];
					result = YES;
				}
				[in closeFile];
			}
		}
	}
	return result;
}

//- (BOOL)exportZipFile:(NSString*)zipFilePath fromRemoteFilePath:(NSString*)remoteFilePath {
//    if ([IMBHelper stringIsNilOrEmpty:remoteFilePath] || [IMBHelper stringIsNilOrEmpty:zipFilePath] || ![self fileExistsAtPath:remoteFilePath]) {
//        return NO;
//    }
//    BOOL isFolder = NO;
//    NSDictionary *fileInfoDic = [self getFileInfo:remoteFilePath];
//    if (fileInfoDic != nil && [fileInfoDic count] > 0) {
//        NSString *fileType = [fileInfoDic objectForKey:@"st_ifmt"];
//        if ([@"S_IFDIR" isEqualToString:fileType]){
//            isFolder = YES;
//        }
//    }
//    
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if ([fm fileExistsAtPath:zipFilePath]) {
//        [fm removeItemAtPath:zipFilePath error:nil];
//    }
//    BOOL ret = [fm createFileAtPath:zipFilePath contents:nil attributes:nil];
//    if (ret) {
//        ZipFile *zipFile= [[ZipFile alloc] initWithFileName:zipFilePath mode:ZipFileModeCreate];
//        uint64_t totalSize = 0;
//        if (isFolder) {
//            totalSize = [self getFolderSize:remoteFilePath];
//            uint64_t currCompressedSize = 0;
//            NSMutableDictionary *info = [NSMutableDictionary dictionary];
//            [info setObject:[NSNumber numberWithLongLong:totalSize] forKey:@"FileSize"];
//            [info setObject:[NSNumber numberWithInt:0] forKey:@"CurCopiedSize"];
//            [info setObject:[NSNumber numberWithLongLong:currCompressedSize] forKey:@"TotalCopiedSize"];
//            [info setObject:TRANSBEGIN forKey:@"CurState"];
//            [nc postNotificationName:TRANSBEGIN object:self userInfo:info];
//            [self recuZipFileWithRootPath:remoteFilePath withZipFile:zipFile withBaseFolder:@"" withCurrCompressedSize:currCompressedSize withTotolSize:totalSize withNotification:nc];
//            [info setObject:[NSNumber numberWithLongLong:totalSize] forKey:@"FileSize"];
//            [info setObject:[NSNumber numberWithInt:0] forKey:@"CurCopiedSize"];
//            [info setObject:[NSNumber numberWithLongLong:currCompressedSize] forKey:@"TotalCopiedSize"];
//            [info setObject:TRANSDONE forKey:@"CurState"];
//            [nc postNotificationName:TRANSDONE object:self userInfo:info];
//        } else {
//            totalSize = [[[self getFileInfo:remoteFilePath] objectForKey:@"st_size"] longValue];
//            uint64_t currCompressedSize = 0;
//            NSMutableDictionary *info = [NSMutableDictionary dictionary];
//            [info setObject:[NSNumber numberWithLongLong:totalSize] forKey:@"FileSize"];
//            [info setObject:[NSNumber numberWithInt:0] forKey:@"CurCopiedSize"];
//            [info setObject:[NSNumber numberWithLongLong:currCompressedSize] forKey:@"TotalCopiedSize"];
//            [info setObject:TRANSBEGIN forKey:@"CurState"];
//            [nc postNotificationName:TRANSBEGIN object:self userInfo:info];
//            AFCFileReference *read = [self openForRead:remoteFilePath];
//            if (read) {
//                NSString *fileName = [remoteFilePath lastPathComponent];
//                NSString *innerPath = [@"" stringByAppendingPathComponent:fileName];
//                ZipWriteStream *stream= [zipFile writeFileInZipWithName:innerPath fileDate:[NSDate dateWithTimeIntervalSinceNow:-86400.0] compressionLevel:ZipCompressionLevelBest];
//                if (stream) {
//                    const uint32_t bufsz = 1024 * 1024;
//                    char *buff = (char*)malloc(bufsz);
//                    while (1) {
//                        uint32_t n = [read readN:bufsz bytes:buff];
//                        if (n==0) break;
//                        //将字节数据转化为NSdata
//                        NSData *b2 = [[NSData alloc] initWithBytesNoCopy:buff length:n freeWhenDone:NO];
//                        //输入流写数据
//                        [stream writeData:b2];
//                        [b2 release];
//                        currCompressedSize += n;
//                        
//                        //此处发送开始导出消息
//                        NSMutableDictionary *info = [NSMutableDictionary dictionary];
//                        [info setObject:[NSNumber numberWithLongLong:totalSize] forKey:@"FileSize"];
//                        [info setObject:[NSNumber numberWithInt:n] forKey:@"CurCopiedSize"];
//                        [info setObject:[NSNumber numberWithLongLong:currCompressedSize] forKey:@"TotalCopiedSize"];
//                        [info setObject:TRANSPROGRESS forKey:@"CurState"];
//                        [nc postNotificationName:TRANSPROGRESS object:self userInfo:info];
//                    }
//                    free(buff);
//                    [stream finishedWriting];
//                }
//                [read closeFile];
//            }
//            [info setObject:[NSNumber numberWithLongLong:totalSize] forKey:@"FileSize"];
//            [info setObject:[NSNumber numberWithInt:0] forKey:@"CurCopiedSize"];
//            [info setObject:[NSNumber numberWithLongLong:currCompressedSize] forKey:@"TotalCopiedSize"];
//            [info setObject:TRANSDONE forKey:@"CurState"];
//            [nc postNotificationName:TRANSDONE object:self userInfo:info];
//        }
//        [zipFile close];
//        [zipFile release];
//        zipFile = nil;
//    }
//    return YES;
//}

//- (BOOL)recuZipFileWithRootPath:(NSString*)rootPath withZipFile:(ZipFile*)zipFile withBaseFolder:(NSString*)baseFolder withCurrCompressedSize:(int64_t)currCompressedSize withTotolSize:(int64_t)totalSize withNotification:(NSNotificationCenter*)notification {
//    NSArray *array = [self getItemInDirWithoutRootDir:rootPath];
//    for (AMFileEntity *file in array) {
//        NSString *fileName = [file.FilePath lastPathComponent];
//        NSString *innerPath = [baseFolder stringByAppendingPathComponent:fileName];
//        //如果是目录
//        if (file.FileType == AMDirectory) {
//            [self recuZipFileWithRootPath:file.FilePath withZipFile:zipFile withBaseFolder:innerPath withCurrCompressedSize:currCompressedSize withTotolSize:totalSize withNotification:notification];
//        } else {
//            AFCFileReference *read = [self openForRead:file.FilePath];
//            if (read) {
//                ZipWriteStream *stream= [zipFile writeFileInZipWithName:innerPath fileDate:[NSDate dateWithTimeIntervalSinceNow:-86400.0] compressionLevel:ZipCompressionLevelBest];
//                if (stream) {
//                    const uint32_t bufsz = 1024 * 1024;
//                    char *buff = (char*)malloc(bufsz);
//                    while (1) {
//                        uint32_t n = [read readN:bufsz bytes:buff];
//                        if (n==0) break;
//                        //将字节数据转化为NSdata
//                        NSData *b2 = [[NSData alloc] initWithBytesNoCopy:buff length:n freeWhenDone:NO];
//                        //输入流写数据
//                        [stream writeData:b2];
//                        [b2 release];
//                        currCompressedSize += n;
//                        
//                        //此处发送开始导出消息
//                        NSMutableDictionary *info = [NSMutableDictionary dictionary];
//                        [info setObject:[NSNumber numberWithLongLong:totalSize] forKey:@"FileSize"];
//                        [info setObject:[NSNumber numberWithInt:n] forKey:@"CurCopiedSize"];
//                        [info setObject:[NSNumber numberWithLongLong:currCompressedSize] forKey:@"TotalCopiedSize"];
//                        [info setObject:TRANSPROGRESS forKey:@"CurState"];
//                        [notification postNotificationName:TRANSPROGRESS object:self userInfo:info];
//                    }
//                    free(buff);
//                    [stream finishedWriting];
//                }
//                [read closeFile];
//            }
//        }
//    }
//    return YES;
//}

@end

@implementation AFCMediaDirectory

- (id)initWithAMDevice:(AMDevice*)device
{
    BOOL isSecure = [device isWifiConnection];
	if (self = [super initWithName:@"com.apple.afc" onDevice:device isSecure:isSecure]) {
		int ret = AFCConnectionOpen(_service, 0/*timeout*/, &_afc);
		if (ret != 0) {
			NSLog(@"AFCConnectionOpen failed: %d", ret);
            if (ret == -402653158) {
                device.isUnlock = YES;
            }
			[self release];
			self = nil;
		}else{
            device.isUnlock  = NO;
        }
	}
	return self;
}

@end

@implementation AFCCrashLogDirectory

- (id)initWithAMDevice:(AMDevice*)device
{
    BOOL isSecure = [device isWifiConnection];
	if (self = [super initWithName:@"com.apple.crashreportcopymobile" onDevice:device isSecure:isSecure]) {
		int ret = AFCConnectionOpen(_service, 0/*timeout*/, &_afc);
		if (ret != 0) {
			NSLog(@"AFCConnectionOpen failed: %d", ret);
			[self release];
			self = nil;
		}
	}
	return self;
}

@end

@implementation AFCRootDirectory

- (id)initWithAMDevice:(AMDevice*)device
{
    BOOL isSecure = [device isWifiConnection];
	if (self = [super initWithName:@"com.apple.afc2" onDevice:device isSecure:isSecure]) {
		int ret = AFCConnectionOpen(_service, 0/*timeout*/, &_afc);
		if (ret != 0) {
			NSLog(@"AFCConnectionOpen failed: %d", ret);
			[self release];
			self = nil;
		}
	}
	return self;
}

@end

@implementation AFCApplicationDirectory

- (id)initWithAMDevice:(AMDevice*)device
			 andName:(NSString*)identifier
{
    BOOL isSecure = [device isWifiConnection];
	if (self = [super initWithName:@"com.apple.mobile.house_arrest" onDevice:device isSecure:isSecure]) {
		NSDictionary *message;
		message = [NSDictionary dictionaryWithObjectsAndKeys:
						// value			key
						@"VendContainer",	@"Command",
						identifier,			@"Identifier",
						nil];
		if ([self sendXMLRequest:message]) {
			NSDictionary *reply = [self readXMLReply];
			if (reply) {
				// The reply will contain one of
				// "Error" => "the error message"
				// "Status" => "Complete"
				NSString *err = [reply objectForKey:@"Error"];
				if (err) {
					NSLog(@"House Arrest failed, %@", err);
					[self release];
					self = nil;
				} else {
					int ret = AFCConnectionOpen(_service, 0/*timeout*/, &_afc);
					if (ret != 0) {
						NSLog(@"AFCConnectionOpen failed: %d", ret);
						[self release];
						self = nil;
					}
				}
			} else {
				NSLog(@"%@",self.lasterror);
				[self release];
				self = nil;
			}
		} else {
			NSLog(@"%@",self.lasterror);
			[self release];
			self = nil;
		}
	}
	return self;
}
@end

@implementation AMApplication

- (void)dealloc
{
   
    if (_info != nil) {
        [_info release];
    }
    
    if (_bundleid != nil) {
        [_bundleid release];
    }
	if (_appname != nil) {
        [_appname release];
    }
    [super dealloc];
}

// we are immutable so it costs nothing to make copies
- (id)copyWithZone:(NSZone*)zone
{
	return [self retain];
}

// initialise a new installed app, based on the contents of the specified directory
- (id)initWithDictionary:(NSDictionary*)info
{
	if (self=[super init]) {
		_info = [info retain];
		_bundleid = [[_info objectForKey:@"CFBundleIdentifier"] retain];

		// appname is harder than you think, for some reason many apps don't
		// seem to populate the correct keys.  Way to go, Apples validation team...
		_appname = nil;
		if (!_appname) _appname = [info objectForKey:@"CFBundleDisplayName"];
		if ([_appname compare:@""]==NSOrderedSame) _appname = nil;		// PuzzleManiak, I'm looking at you
		if (!_appname) _appname = [info objectForKey:@"CFBundleName"];
		if (!_appname) _appname = [info objectForKey:@"CFBundleExecutable"];
		[_appname retain];
	}
	return self;
}

- (id)bundleid
{
	return [[_bundleid retain] autorelease];
}

- (NSString*)appname
{
	return [[_appname retain] autorelease];
}

- (NSDictionary*)info
{
	return [[_info retain] autorelease];
}



// we fake out missing entries in our object with NSNull.  That way,
// I think NSPredicate can refer to "missing" entries without throwing exceptions
- (id)valueForKey:(NSString *)key
{
	if ([key isEqual:@"appname"]) return _appname;
	if ([key isEqual:@"bundleid"]) return _bundleid;
	id v = [_info valueForKey:key];
	if (v) return v;
	return [NSNull null];
}

- (id)appdir
{
	return [_info objectForKey:@"Container"];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"<AMApplication name=%@ id=%@>",_appname,_bundleid];
}

- (NSUInteger)hash
{
	return [_bundleid hash];
}

- (NSComparisonResult)compare:(AMApplication *)other
{
	return [_appname caseInsensitiveCompare:other->_appname];
}

- (BOOL)isEqual:(id)anObject
{
	if (![anObject isKindOfClass:[self class]]) return NO;
	return ([self compare:anObject] == NSOrderedSame);
}

@end

@implementation AMInstallationProxy

#if 0
Yeah, I’ve just found out how to handle this and terminate sync when user slides cancel switch.

We need following functions (meta-language):

ERROR AMDObserveNotification(HANDLE proxy, CFSTR notification);

ERROR AMDListenForNotifications(HANDLE proxy, NOTIFY_CALLBACK cb, USERDATA data);

and callback delegate:

typedef void (*NOTIFY_CALLBACK)(CFSTR notification, USERDATA data);

First, we need AMDObserveNotification to subscribe notifications about “com.apple.itunes-client.syncCancelRequest”. Then we should start listening for notifications (second function) until we get “AMDNotificationFaceplant”.
That’s it. When notification got, you should unlock and close lock file handle (don’t sure if you need to post “syncDidFinish” to proxy, seems it doesn’t matter) and terminate sync gracefully.

P.S. The same notification is also got when you unplug your device, so you should always be ready for errors.
#endif

- (NSArray *)browse:(NSString*)type
{
	return [self browseFiltered:nil];
}

- (NSArray *)browseFiltered:(NSPredicate*)filter
{
	NSDictionary *message;
	NSArray *result = nil;

	message = [NSDictionary dictionaryWithObjectsAndKeys:
					// value																key
					@"Browse",																@"Command",
					[NSDictionary dictionaryWithObject:@"Any" forKey:@"ApplicationType"],	@"ClientOptions",
					nil];
	if ([self sendXMLRequest:message]) {
		//
		// we return all applications in a single array.  However,
		// the protocol between ipod and mac does not - instead, the ipod only returns up to
		// about 20 at a time, passing a Status field as well which tells us whether the
		// transfer is finished or not.  This loop worries about gluing the responses
		// back together for you.
		//
		NSMutableArray *thelist = nil;
		for (;;) {
			// read next slab of information
			NSDictionary *reply = [self readXMLReply];
			if (!reply) break;

			// first time through, thelist will be nil so we'll allocate it.
			if (nil == thelist) {
				// each reply that comes back has a list size in the Total key, so we can 
				// ask for an array of the correct size up front...  If we have a filter,
				// then we'll be over-estimating but thats not that big a deal...
				NSNumber *total = [reply objectForKey:@"Total"];
				if (total && [total isKindOfClass:[NSNumber class]]) {
					thelist = [[NSMutableArray alloc] initWithCapacity:[total intValue]];
				} else {
					// Hmmm, no Total, do it the hard way
					thelist = [[NSMutableArray alloc] init];
				}
			}

			// now, this reply might not have a current list in it so we need to be careful
			NSArray *currentlist = [reply objectForKey:@"CurrentList"];
			if (currentlist) {
				for (NSDictionary *appinfo in currentlist) {
					AMApplication *app = [[AMApplication alloc] initWithDictionary:appinfo];
					if (filter==nil || [filter evaluateWithObject:app]) {
						[thelist addObject:app];
					}
					[app release];
				}
			}

			NSString *s = [reply objectForKey:@"Status"];
			if (![s isEqual:@"BrowsingApplications"]) break;
		}

		// all finished, make it immutable and return
		if (thelist) {
			result = [NSArray arrayWithArray:thelist];
			[thelist release];
		}
	}
	return result;
}

// 在类AMInstallationProxy中增加此方法
- (NSMutableArray *)getAllAppsInfo {
    NSMutableArray *appsInfo = [[[NSMutableArray alloc] init] autorelease];
    NSArray *retAttArray = [NSArray arrayWithObjects:@"CFBundleIdentifier", @"ApplicationType", @"CFBundleName", @"CFBundleDisplayName", @"CFBundleExecutable", @"CFBundleVersion", @"CFBundleShortVersionString", @"Path", @"MinimumOSVersion", @"UIDeviceFamily", @"DynamicDiskUsage", @"StaticDiskUsage", nil];
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSDictionary dictionaryWithObjectsAndKeys:retAttArray, @"ReturnAttributes", nil], @"ClientOptions",
                             @"Browse", @"Command",
                             nil];
    if ([self sendXMLRequest:message]) {
        for (;;) {
            NSDictionary *reply = [self readXMLReply];
			if (!reply) break;
            
            NSString *s = [reply objectForKey:@"Status"];
			if ([s isEqual:@"Complete"]) break;
            
            NSArray *allKey = [reply allKeys];
            if ([allKey containsObject:@"CurrentList"]) {
                NSArray *currApps = [reply objectForKey:@"CurrentList"];
                [appsInfo addObjectsFromArray:currApps];
            }
        }
    }
    return appsInfo;
}


- (BOOL)archive:(NSString*)bundleid
		container:(BOOL)container
		payload:(BOOL)payload
		uninstall:(BOOL)uninstall
{
	BOOL result = NO;
	NSDictionary *message;
	NSString *mode;

	if (container) {
		if (payload) {
			mode = @"All";
		} else {
			mode = @"DocumentsOnly";
		}
	} else {
		if (payload) {
			mode = @"ApplicationOnly";
		} else {
			return NO;
		}
	}

	// { "Command" => "Archive";	"ApplicationIdentifier" => ...; ClientOptions => ... }
	// it also takes {"ArchiveType" => oneof "All", "DocumentsOnly", "ApplicationOnly" }
	// it also takes {"SkipUninstall" => True / False}
	message = [NSDictionary dictionaryWithObjectsAndKeys:
					// value																key
					@"Archive",														@"Command",
					bundleid,																@"ApplicationIdentifier",
					[NSDictionary dictionaryWithObjectsAndKeys:
						// value										key
						mode,											@"ArchiveType",
						uninstall ? kCFBooleanFalse : kCFBooleanTrue,	@"SkipUninstall",
						nil],																@"ClientOptions",
					nil];

	[self performDelegateSelector:@selector(operationStarted:) withObject:message];
     NSLog(@"Archive start: %@", [message description]);
	if ([self sendXMLRequest:message]) {
		for (;;) {
			// read next slab of information
			// The reply will contain an entry for Status, a string from the following:
			//	"TakingInstallLock"
			//	"EmptyingApplication"
			//	"ArchivingApplication"
			//	"RemovingApplication"			/__ only if the application was uninstalled
			//	"GeneratingApplicationMap"		\
			//	"Complete"
			// All except "Complete" also include PercentageComplete, an integer between 0 and 100 (but it goes up and down)
			//
			// If its already been archived, we might get:
			//    Error = AlreadyArchived;
			// If we keep listening we'll then get
			//    Error = APIInternalError;
			NSDictionary *reply = [self readXMLReply];
			if (!reply) break;
            NSLog(@"Archive reply: %@", [reply description]);
			[self performDelegateSelector:@selector(operationContinues:) withObject:reply];
            
            if ([reply objectForKey:@"Error"] != nil) {
                //TODO 需要做什么处理吗？
                result = NO;
                break;
            }
            
			NSString *s = [reply objectForKey:@"Status"];
			if ([s isEqual:@"Complete"]) {
                result = YES;
                break;
            }

		}
		
	}
	[self performDelegateSelector:@selector(operationCompleted:) withObject:message];
	return result;
}

- (BOOL)restore:(NSString*)bundleid
{
	BOOL result = NO;
	NSDictionary *message;
	message = [NSDictionary dictionaryWithObjectsAndKeys:
					// value																key
					@"Restore",																@"Command",
					bundleid,																@"ApplicationIdentifier",
					nil];
	[self performDelegateSelector:@selector(operationStarted:) withObject:message];
	if ([self sendXMLRequest:message]) {
		for (;;) {
			// read next slab of information
			// The reply will contain an entry for Status, a string from the following:
			//	"TakingInstallLock"
			//	"RestoringApplication"
			//	"SandboxingApplication"
			//	"GeneratingApplicationMap"
			//	"Complete"
			// All except "Complete" also include PercentageComplete, an integer between 0 and 100 (but it goes up and down)
			//
			// Looks like instead of Status, we can get:
			// Error = APIInternalError
			// (that happened if I passed in ClientOptions.  Bad...
			// Error = APIEpicFail;
			// (that happened if I passed in a missing bundle-id
			NSDictionary *reply = [self readXMLReply];
			if (!reply) break;
			[self performDelegateSelector:@selector(operationContinues:) withObject:reply];
            if ([reply objectForKey:@"Error"] != nil) {
                //TODO 需要做什么处理吗？
                result = NO;
                break;
            }
            NSString *s = [reply objectForKey:@"Status"];
			if ([s isEqual:@"Complete"]) {
                result = YES;
                break;
            }
		}
		//result = YES;
	}
	[self performDelegateSelector:@selector(operationCompleted:) withObject:message];
	return result;
}

- (BOOL)uninstall:(NSString*)bundleid
{
	BOOL result = NO;
	NSDictionary *message;
	message = [NSDictionary dictionaryWithObjectsAndKeys:
               // value																key
               @"Uninstall",																@"Command",
               bundleid,																@"ApplicationIdentifier",
               nil];
	[self performDelegateSelector:@selector(operationStarted:) withObject:message];
	if ([self sendXMLRequest:message]) {
		for (;;) {
			// read next slab of information
			// The reply will contain an entry for Status, a string from the following:
			//	"TakingInstallLock"
			//	"RestoringApplication"
			//	"SandboxingApplication"
			//	"GeneratingApplicationMap"
			//	"Complete"
			// All except "Complete" also include PercentageComplete, an integer between 0 and 100 (but it goes up and down)
			//
			// Looks like instead of Status, we can get:
			// Error = APIInternalError
			// (that happened if I passed in ClientOptions.  Bad...
			// Error = APIEpicFail;
			// (that happened if I passed in a missing bundle-id
			NSDictionary *reply = [self readXMLReply];
			if (!reply) break;
            NSLog(@"Install reply: %@", [reply description]);
			[self performDelegateSelector:@selector(operationContinues:) withObject:reply];
            if ([reply objectForKey:@"Error"] != nil) {
                //TODO 需要做什么处理吗？
                result = NO;
                break;
            }
            NSString *s = [reply objectForKey:@"Status"];
			if ([s isEqual:@"Complete"]) {
                result = YES;
                break;
            }
		}
		//result = YES;
	}
	[self performDelegateSelector:@selector(operationCompleted:) withObject:message];
	return result;
}

- (NSArray*)archivedAppBundleIds
{
	NSDictionary *appInfo = [self archivedAppInfo];
	return [appInfo allKeys];
}

- (NSDictionary*)archivedAppInfo
{
	NSDictionary *message;
	message = [NSDictionary dictionaryWithObjectsAndKeys:
					// value					key
					@"LookupArchives",			@"Command",
					nil];
	if ([self sendXMLRequest:message]) {
		NSDictionary *reply = [self readXMLReply];
		if (reply) {
			return [[[reply objectForKey:@"LookupResult"] retain] autorelease];
		}
	}
	return nil;
}

/// Remove the archive for a given bundle id.
- (BOOL)removeArchive:(NSString*)bundleid
{
	NSDictionary *message;
	message = [NSDictionary dictionaryWithObjectsAndKeys:
					// value					key
					@"RemoveArchive",			@"Command",
					bundleid,					@"ApplicationIdentifier",
					nil];

	[self performDelegateSelector:@selector(operationStarted:) withObject:message];
	if ([self sendXMLRequest:message]) {
		for (;;) {
			// read next slab of information
			// The reply will contain an entry for Status, a string from the following:
			//	"RemovingArchive"
			//	"Complete"
			// All except "Complete" also include PercentageComplete, an integer between 0 and 100 (but it goes up and down)
			//
			// Looks like instead of Status, we can get:
			// Error = APIEpicFail;
			// (that happened if I passed in a missing bundle-id
			// Error = APIInternalError
			// (that happened if I kept reading?
			NSDictionary *reply = [self readXMLReply];
			if (!reply) break;
			[self performDelegateSelector:@selector(operationContinues:) withObject:reply];
            if ([reply objectForKey:@"Error"] != nil) {
                //TODO 需要做什么处理吗？
                break;
            }
            NSString *s = [reply objectForKey:@"Status"];
			if ([s isEqual:@"Complete"]) break;
		}
	}
	[self performDelegateSelector:@selector(operationCompleted:) withObject:message];
	return NO;
}

//
// lookup is similiar to browse - it looks like it has clever filtering
// capability but its not that useful.  You can look up all attributes that
// *have* an explicit value for a specific attribute - you can't filter on actual
// values, just on the presence/absence of the attribute - use browseFiltered:
// instead.
//
// note we return a DICTIONARY indexed by bundle id
//
- (NSDictionary*)lookupType:(NSString*)type withAttribute:(NSString*)attr
{
	NSDictionary *message;
	if (type == nil) type = @"Any";
	message = [NSDictionary dictionaryWithObjectsAndKeys:
					// value					key
					@"Lookup",				@"Command",
					[NSDictionary dictionaryWithObjectsAndKeys:
						type, @"ApplicationType",
						attr, @"Attribute",
						nil],				@"ClientOptions",
					nil];
	[self performDelegateSelector:@selector(operationStarted:) withObject:message];
	if ([self sendXMLRequest:message]) {
		NSDictionary *reply = [self readXMLReply];
		if (reply) {
			[self performDelegateSelector:@selector(operationContinues:) withObject:reply];
			NSMutableDictionary *result = [[NSMutableDictionary new] autorelease];
			NSDictionary *lookup_result = [reply objectForKey:@"LookupResult"];
			for (NSString *key in lookup_result) {
				NSDictionary *info = [lookup_result objectForKey:key];
				AMApplication *app = [[AMApplication alloc] initWithDictionary:info];
				[result setObject:app forKey:key];
				[app release];
			}
			return [NSDictionary dictionaryWithDictionary:result];
		}
	}
	[self performDelegateSelector:@selector(operationCompleted:) withObject:message];
	return nil;
}

- (id)initWithAMDevice:(AMDevice*)device
{
    BOOL isSecure = [device isWifiConnection];
	if (self = [super initWithName:@"com.apple.mobile.installation_proxy" onDevice:device isSecure:isSecure]) {
	}
	return self;
}
#if 0
http://libiphone.lighthouseapp.com/projects/27916/tickets/104/a/365185/0001-new-installation_proxy-interface.patch

// { "Command" => "Install";
//			"PackagePath" => "...";	// Will be prefixed with /var/mobile/Media/
//									// if PackageType="Developer", it should be a pointer to an expanded .app
//									// containing code signature stuff, etc.
//			"ClientOptions" = { "PackageType" = "Developer"; "ApplicationSINF" = ... "; "iTunesMetadata" = "...",  }
//							  { "PackageType" = "Customer";
//							  { "PackageType" = "CarrierBundle"; ...
//		<- { Status => Complete; }
//		<- { Status => "..."; PercentComplete = ... }
// { "Command" => "Upgrade"; "PackagePath" => "..." }
//

2010-06-08 20:01:34.628 iPodBackup[40130:a0f] operationContinues::{
    PercentComplete = 0;
    Status = TakingInstallLock;
}
2010-06-08 20:01:34.640 iPodBackup[40130:a0f] operationContinues::{
    PercentComplete = 5;
    Status = CreatingStagingDirectory;
}
2010-06-08 20:01:34.656 iPodBackup[40130:a0f] operationContinues::{
    PercentComplete = 10;
    Status = StagingPackage;
}
2010-06-08 20:01:34.694 iPodBackup[40130:a0f] operationContinues::{
    PercentComplete = 15;
    Status = ExtractingPackage;
}
2010-06-08 20:01:34.697 iPodBackup[40130:a0f] operationContinues::{
    PercentComplete = 20;
    Status = InspectingPackage;
}
2010-06-08 20:01:34.701 iPodBackup[40130:a0f] operationContinues::{
    PercentComplete = 30;
    Status = PreflightingApplication;
}
2010-06-08 20:01:34.704 iPodBackup[40130:a0f] operationContinues::{
    PercentComplete = 30;
    Status = InstallingEmbeddedProfile;
}
2010-06-08 20:01:34.708 iPodBackup[40130:a0f] operationContinues::{
    PercentComplete = 40;
    Status = VerifyingApplication;
}
2010-06-08 20:01:34.722 iPodBackup[40130:a0f] operationContinues::{
    Error = BundleVerificationFailed;
}
2010-06-08 20:01:34.728 iPodBackup[40130:a0f] operationContinues::{
    Error = APIInternalError;
}
2010-06-08 20:01:34.730 iPodBackup[40130:a0f] operationCompleted::{
    ClientOptions =     {
        PackageType = Developer;
    };
    Command = Install;
    PackagePath = "PublicStaging/AncientFrogHD.app";
}

// { "Command" => "Uninstall";	"ApplicationIdentifier" => ...; ClientOptions => ... }

// { "Command" => "RemoveArchive";	"ApplicationIdentifier" => ...; ClientOptions => ... }
// { "Command" => "CheckCapabilitiesMatch"; Capabilities => ...; ClientOptions => ... }
//		<- { Status => Complete; LookupResult => ... }
//		<- { Error = APIInternalError; }
//

2010-06-08 20:16:59.431 iPodBackup[40417:a0f] operationStarted::{
    ClientOptions =     {
        PackageType = Developer;
    };
    Command = Install;
    PackagePath = "PublicStaging/Rooms.app";
}
2010-06-08 20:16:59.462 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 0;
    Status = TakingInstallLock;
}
2010-06-08 20:16:59.479 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 5;
    Status = CreatingStagingDirectory;
}
2010-06-08 20:16:59.488 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 10;
    Status = StagingPackage;
}
2010-06-08 20:16:59.504 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 15;
    Status = ExtractingPackage;
}
2010-06-08 20:16:59.511 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 20;
    Status = InspectingPackage;
}
2010-06-08 20:16:59.518 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 30;
    Status = PreflightingApplication;
}
2010-06-08 20:16:59.526 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 30;
    Status = InstallingEmbeddedProfile;
}
2010-06-08 20:16:59.533 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 40;
    Status = VerifyingApplication;
}
2010-06-08 20:17:02.915 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 50;
    Status = CreatingContainer;
}
2010-06-08 20:17:02.926 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 60;
    Status = InstallingApplication;
}
2010-06-08 20:17:02.935 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 70;
    Status = PostflightingApplication;
}
2010-06-08 20:17:02.939 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 80;
    Status = SandboxingApplication;
}
2010-06-08 20:17:02.977 iPodBackup[40417:a0f] operationContinues::{
    PercentComplete = 90;
    Status = GeneratingApplicationMap;
}
2010-06-08 20:17:04.943 iPodBackup[40417:a0f] operationContinues::{
    Status = Complete;
}
#endif

- (BOOL)install:(NSString*)pathname
{
    BOOL result = NO;
	NSDictionary *message;
	message = [NSDictionary dictionaryWithObjectsAndKeys:
					// value					key
					@"Install",				@"Command",
					pathname,				@"PackagePath",
					[NSDictionary dictionaryWithObjectsAndKeys:
						@"Customer", @"PackageType",
						nil],				@"ClientOptions",
					nil];
	[self performDelegateSelector:@selector(operationStarted:) withObject:message];
    NSLog(@"install started:%@", [message description]);
	if ([self sendXMLRequest:message]) {
		for (;;) {
            // read next slab of information
			// The reply will contain an entry for Status, a string from the following:
			//	"RemovingArchive"
			//	"Complete"
			// All except "Complete" also include PercentageComplete, an integer between 0 and 100 (but it goes up and down)
			//
			// Looks like instead of Status, we can get:
			// Error = APIEpicFail;
			// (that happened if I passed in a missing bundle-id
			// Error = APIInternalError
			// (that happened if I kept reading?
            NSDictionary *reply = [self readXMLReply];
            if (!reply) break;
            NSLog(@"install replay:%@", [reply description]);
			[self performDelegateSelector:@selector(operationContinues:) withObject:reply];
            if ([reply objectForKey:@"Error"] != nil) {
                //TODO 需要做什么处理吗？
                result = NO;
                break;
            }
            NSString *s = [reply objectForKey:@"Status"];
            if ([s isEqual:@"Complete"]) {
                result = YES;
                break;
            }
		}
	}
	[self performDelegateSelector:@selector(operationCompleted:) withObject:message];
	return result;
}

- (BOOL)upgrade:(NSString*)bundleId from:(NSString*)pathname;
{
	NSDictionary *message;
	message = [NSDictionary dictionaryWithObjectsAndKeys:
					// value					key
					@"Upgrade",				@"Command",
					pathname,				@"PackagePath",
					bundleId,				@"ApplicationIdentifier",
					[NSDictionary dictionaryWithObjectsAndKeys:
						@"Developer", @"PackageType",
						nil],				@"ClientOptions",
					nil];
	[self performDelegateSelector:@selector(operationStarted:) withObject:message];
	if ([self sendXMLRequest:message]) {
		for (;;) {
			// read next slab of information
			// The reply will contain an entry for Status, a string from the following:
			//	"RemovingArchive"
			//	"Complete"
			// All except "Complete" also include PercentageComplete, an integer between 0 and 100 (but it goes up and down)
			//
			// Looks like instead of Status, we can get:
			// Error = APIEpicFail;
			// (that happened if I passed in a missing bundle-id
			// Error = APIInternalError
			// (that happened if I kept reading?
			NSDictionary *reply = [self readXMLReply];
			if (!reply) break;
			[self performDelegateSelector:@selector(operationContinues:) withObject:reply];
			NSString *s = [reply objectForKey:@"Status"];
			if ([s isEqual:@"Complete"]) break;
		}
	}
	[self performDelegateSelector:@selector(operationCompleted:) withObject:message];
	return NO;
}

@end

@implementation AMSyslogRelay

// This gets called back whenever there is data in the socket that we need
// to read out of it.
static
void AMSyslogRelayCallBack (
	CFReadStreamRef stream,
	CFStreamEventType eventType,
	void *clientCallBackInfo )
{
	AMSyslogRelay *relay = (AMSyslogRelay*)clientCallBackInfo;

	switch (eventType) {
	case kCFStreamEventNone:
	case kCFStreamEventOpenCompleted:
	case kCFStreamEventCanAcceptBytes: 
	case kCFStreamEventErrorOccurred:
	case kCFStreamEventEndEncountered:
		break;

	case kCFStreamEventHasBytesAvailable:
		{
			// The relay has a maximum buffer size of 0x4000, so we might as
			// well match it.  The buffer consists of multiple syslog records
			// which are \0 terminated - they may contain \n characters within
			// a record, and they never seem to send us an unterminated message
			// (again, the server code seems to preclude it)
			//
			// Control characters seem to be escaped with \ - ie, tab comes through as \ followed by t
			UInt8 buffer[0x4000];
			const CFIndex len = CFReadStreamRead(stream,buffer,sizeof(buffer));
			if (len) {
				UInt8 *p, *q;
				CFIndex left = len;
				p = buffer;
				buffer[sizeof(buffer)-1] = '\000';
				while (left>0) {
					// remove leading newlines
					while (*p == '\n') {
						if (--left) p++;
						else break;
					}
					q = p;
					while (*q && left>0) {q++;left--;}
					if (left) {
						// occasionally we encounter a null record - no need
						// to pass that on and confuse our listener.  Also, sometimes
						// the relay seems to pass us lines of the form "> ".  It looks
						// like thats the 'end' marker that the syslog daemon on the
						// device uses to communicate with the relay to tell it "thats
						// all for now".
						if (q-p) {
							NSString *s = [[NSString alloc] initWithBytesNoCopy:p length:q-p encoding:NSUTF8StringEncoding freeWhenDone:NO];
							[relay->_listener performSelector:relay->_message withObject:s];
							[s release];
						}
						p = q+1;
						left--;
					}
				}
			}
		}
	}
}

- (void)dealloc
{
	if (_service) {
		if (_readstream) {
			CFReadStreamUnscheduleFromRunLoop (_readstream,CFRunLoopGetMain(),kCFRunLoopCommonModes);
			CFReadStreamClose(_readstream);
			CFRelease(_readstream);
		}
	}
	[super dealloc];
}

- (id)initWithAMDevice:(AMDevice*)device listener:(id)listener message:(SEL)message
{
    BOOL isSecure = [device isWifiConnection];
	if (self = [super initWithName:@"com.apple.syslog_relay" onDevice:device isSecure:isSecure]) {
		_listener = listener;
		_message = message;
		int sock = (int)((uint32_t)_service);
		CFSocketNativeHandle s = (CFSocketNativeHandle)sock;
		CFStreamCreatePairWithSocket ( 0, s, &_readstream, NULL);
		if (_readstream) {
			CFStreamClientContext ctx = { 0,self,0,0,0 };
			int flags = kCFStreamEventHasBytesAvailable;
			flags = 31;
			if (CFReadStreamSetClient (_readstream,flags, &AMSyslogRelayCallBack, &ctx )) {
				CFReadStreamScheduleWithRunLoop (_readstream,CFRunLoopGetMain(),kCFRunLoopCommonModes);
				if (CFReadStreamOpen(_readstream)) {
					// NSLog(@"stream opened ok");
				} else {
					NSLog(@"stream did not open");
				}
			} else {
				NSLog(@"couldn't set client");
			}
		} else {
			NSLog(@"couldn't create read stream");
		}
	}
	return self;
}

@end

@implementation AMFileRelay

- (bool)slurpInto:(NSOutputStream*)writestream
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	bool result = NO;
	UInt8 buf[1024];

	// make sure they remembered to open the stream
	bool opened = NO;
	if ([writestream streamStatus] == NSStreamStatusNotOpen) {
		[writestream open];
		opened = YES;
	}

	// create an input stream to read from the socket 
	// loop around reading till its all done
	NSInputStream *readstream = [self inputStreamFromSocket];
	[readstream open];
	for (;;) {
		NSInteger nr = [readstream read:buf maxLength:sizeof(buf)];
		if (nr > 0) {
			NSInteger nw = [writestream write:buf maxLength:nr];
			if (nw != nr) {
				[self setLastError:[NSString stringWithFormat:@"File truncated on write, nr=%ld nw=%ld",(long)nr,(long)nw]];
				break;
			}
		} else if (nr < 0) {
			[self setLastError:[[readstream streamError] localizedDescription]];
			break;
		} else {
			[self clearLastError];
			result = YES;
			break;
		}
	}
	[readstream close];

	// if we opened the stream, we close it as well
	if (opened) [writestream close];

	[pool drain];
	return(result);
}

- (id)initWithAMDevice:(AMDevice*)device
{
    BOOL isSecure = [device isWifiConnection];
	if (self = [super initWithName:@"com.apple.mobile.file_relay" onDevice:device isSecure:isSecure]) {
		_used = NO;
	}
	return self;
}

- (bool)getFileSets:(NSArray*)set into:(NSOutputStream*)output
{
	if (_used) {
		[self setLastError:@"AlreadyUsed"];
		return NO;
	}
	_used = YES;

	NSDictionary *message;
	message = [NSDictionary dictionaryWithObject:set forKey:@"Sources"];
	if ([self sendXMLRequest:message]) {
		NSDictionary *reply = [self readXMLReply];
		if (reply) {
			// If the reply contains an "Error" item, we failed
			id err = [reply objectForKey:@"Error"];
			if (err) {
				[self setLastError:[NSString stringWithFormat:@"%@",err]];
				return NO;
			}
			// We could check for "Status = Acknowledged" but why bother
			return [self slurpInto:output];
		}
	}
	return NO;
}

- (bool)getFileSet:(NSString*)name into:(NSOutputStream*)output
{
	return [self getFileSets:[NSArray arrayWithObject:name] into:output];
} 

@end

@implementation AMNotificationProxy

/*

http://matt.colyer.name/projects/iphone-linux/index.php?title=Banana's_lockdownd_session

+// NotificationProxy related
+// notifications for use with post_notification (client --> device)
+#define NP_SYNC_WILL_START      "com.apple.itunes-mobdev.syncWillStart"
+#define NP_SYNC_DID_START       "com.apple.itunes-mobdev.syncDidStart"
+#define NP_SYNC_DID_FINISH      "com.apple.itunes-mobdev.syncDidFinish"
+
+// notifications for use with observe_notification (device --> client)
+#define NP_SYNC_CANCEL_REQUEST  "com.apple.itunes-client.syncCancelRequest"
+#define NP_SYNC_SUSPEND_REQUEST "com.apple.itunes-client.syncSuspendRequest"
+#define NP_SYNC_RESUME_REQUEST  "com.apple.itunes-client.syncResumeRequest"
+#define NP_PHONE_NUMBER_CHANGED "com.apple.mobile.lockdown.phone_number_changed"
+#define NP_DEVICE_NAME_CHANGED  "com.apple.mobile.lockdown.device_name_changed"
+#define NP_ATTEMPTACTIVATION    "com.apple.springboard.attemptactivation"
+#define NP_DS_DOMAIN_CHANGED    "com.apple.mobile.data_sync.domain_changed"
+#define NP_APP_INSTALLED        "com.apple.mobile.application_installed"
+#define NP_APP_UNINSTALLED      "com.apple.mobile.application_uninstalled"
+

*/
- (void)dealloc
{
	NSLog(@"deallocating %@",self);
	if (_service) {
		AMDShutdownNotificationProxy(_service);
		// don't nil it, superclass might need to do something?
		[_messages release];
	}
	[super dealloc];
}

// Note, sometimes we get called with "AMDNotificationFaceplant" - that happens
// when the connection to the device goes away.  We may have a race condition in
// here because we may have killed the AMDevice which will close all the services
static void AMNotificationProxy_callback(CFStringRef notification, void* data)
{
	AMNotificationProxy *proxy = (AMNotificationProxy*)data;
	if (proxy->_messages) {
		NSMutableArray *message_observers = [proxy->_messages objectForKey:(NSString*)notification];
		for (NSArray *a in message_observers) {
			id observer = [a objectAtIndex:0];
			SEL message = NSSelectorFromString([a objectAtIndex:1]);
			[observer performSelector:message withObject:(NSString*)notification];
		}
	}
}

// AMDListenForNotification() is a bit stupid.  It creates a CFSocketRunloopSource but
// it hooks it up to the *current* runloop - we need it to be hooked to the *main*
// runloop.  Thus, we arrange for our registration to be punted across to the
// main thread, whose runloop should be the main one.
- (void)_amdlistenfornotifications
{
	mach_error_t status;
	status = AMDListenForNotifications(_service, AMNotificationProxy_callback, self);
	if (status != ERR_SUCCESS) NSLog(@"AMDListenForNotifications returned %d",status);
}

- (id)initWithAMDevice:(AMDevice*)device
{
    BOOL isSecure = [device isWifiConnection];
	if (self = [super initWithName:@"com.apple.mobile.notification_proxy" onDevice:device isSecure:isSecure]) {
		_messages = [NSMutableDictionary new];
		[self performSelectorOnMainThread:@selector(_amdlistenfornotifications) withObject:nil waitUntilDone:YES];
	}
	return self;
}

- (void)postNotification:(NSString*)notification
{
	AMDPostNotification(_service, (CFStringRef)notification, (CFStringRef)NULL);
}

/// Add an observer for a specific message.
- (void)addObserver:(id)notificationObserver
           selector:(SEL)notificationSelector
               name:(NSString *)notificationName
{
	// make sure this method is appropriate
	NSMethodSignature *sig = [notificationObserver methodSignatureForSelector:notificationSelector];
	if (
		sig == nil
		||
		strcmp([sig methodReturnType],"v")!=0
		||
		[sig numberOfArguments] != 3
		||
		strcmp([sig getArgumentTypeAtIndex:2],"@")!=0
	) {
		NSString *c = NSStringFromClass([notificationObserver class]);
		NSString *s = NSStringFromSelector(notificationSelector);
		NSLog(@"%@.%@ defined incorrectly for AMNotificationCenter.addObserver:selector:name:",c,s);
		NSLog(@"It should be:");
		NSLog(@"-(void)%@: (id)notificationname;",s);
		return;
	}

	if ([notificationObserver respondsToSelector:notificationSelector]) {
		// we keep an array of observers in a dictionary indexed by notificationName.
		// each observer is recorded as an array containing { object, "selector-as-string" }
		NSMutableArray *message_observers = [_messages objectForKey:notificationName];
		if (message_observers) {
			for (NSArray *a in message_observers) {
				// already here, just ignore it?
				if ([a objectAtIndex:0] == notificationObserver) return;
			}
		} else {
			// we aren't watching this one yet, so start it now
			mach_error_t status;
			status = AMDObserveNotification(_service, (CFStringRef)notificationName);
			if (status != ERR_SUCCESS) NSLog(@"AMDObserveNotification returned %d",status);

			message_observers = [NSMutableArray new];
			[_messages setObject:message_observers forKey:notificationName];
			[message_observers release];
		}
		[message_observers addObject:[NSArray arrayWithObjects:notificationObserver,NSStringFromSelector(notificationSelector),nil]];
	} else {
		NSLog(@"%@ does not respond to %@",notificationObserver,NSStringFromSelector(notificationSelector));
	}
}

/// Remove an observer for a specific message.
- (void)removeObserver:(id)notificationObserver
                  name:(NSString *)notificationName
{
	NSMutableArray *message_observers = [_messages objectForKey:notificationName];
	if (message_observers) {
		for (NSArray *a in message_observers) {
			if ([a objectAtIndex:0] == notificationObserver) {
				[message_observers removeObject:a];
				// there is no mechanism for us to "unobserve" so we just leave
				// the listener in place
				break;
			}
		}
	}
}

/// Remove an observer for all messages.
- (void)removeObserver:(id)notificationObserver
{
	for (NSString *k in [_messages allKeys]) {
		[self removeObserver:notificationObserver name:k];
	}
}

@end

@implementation AMSpringboardServices

- (id)getIconState
{
	NSDictionary *message;
	message = [NSDictionary dictionaryWithObject:@"getIconState" forKey:@"command"];
	if ([self sendXMLRequest:message]) {
		return [self readXMLReply];
	}
	return nil;
}

- (id)getIconPNGData:(NSString*)bundleId
{
	NSDictionary *message;
	message = [NSDictionary dictionaryWithObjectsAndKeys:
					// value			key
					@"getIconPNGData",	@"command",
					bundleId,			@"bundleId",
					nil];
	if ([self sendXMLRequest:message]) {
		return [self readXMLReply];
	}
	return nil;
}

- (NSImage*)getIcon:(NSString*)displayIdentifier
{
	id reply = [self getIconPNGData:displayIdentifier];
	if (reply) {
		NSData *pngdata = [reply objectForKey:@"pngData"];
		if (pngdata) {
			return [[[NSImage alloc] initWithData:pngdata] autorelease];
		}
	}
	return nil;
}

- (id)initWithAMDevice:(AMDevice*)device
{
    BOOL isSecure = [device isWifiConnection];
	if (self = [super initWithName:@"com.apple.springboardservices" onDevice:device isSecure:isSecure]) {
		// nothing special
	}
	return self;
}

/*
 /// - \p "com.apple.mobile.springboardservices"
 ///			(implemented as /usr/libexec/springboardservicesrelay)
 
 {	"command" = "getIconState"; }
 - returns an NSArray() of pages
 -   page 0 is the dock
 -   each page is an NSArray() of icon entries
 -       each entry is an NSDictionary()
 -               bundleIdentifier = "com.apple.mobileipod";
 -               displayIdentifier = "com.apple.mobileipod-AudioPlayer";
 -               displayName = Music;
 -               iconModDate = 2009-09-26 20:45:29 +1000;
 -       or a zero (for an unused slot)
 -       padded to a multiple of four.

 {	"command" = "getIconPNGData"; "bundleId" = ... };
 
 {	"command" = "setIconState"; }
	perhaps expects to be passed a follow up plist with the new state
*/
@end

#if 0
misagent
__cfstring:000020B0 cfstr_Profiletype __CFString <0, 0x7C8, aProfiletype, 0xB> ; "ProfileType"
__cfstring:000020C0 cfstr_Provisioning __CFString <0, 0x7C8, aProvisioning, 0xC> ; "Provisioning"
__cfstring:000020D0 cfstr_Messagetype __CFString <0, 0x7C8, aMessagetype, 0xB> ; "MessageType"
__cfstring:000020E0 cfstr_Install   __CFString <0, 0x7C8, aInstall, 7> ; "Install"
__cfstring:000020F0 cfstr_Profile   __CFString <0, 0x7C8, aProfile, 7> ; "Profile"
__cfstring:00002100 cfstr_Remove    __CFString <0, 0x7C8, aRemove, 6> ; "Remove"
__cfstring:00002110 cfstr_Profileid __CFString <0, 0x7C8, aProfileid, 9> ; "ProfileID"
__cfstring:00002120 cfstr_Copy      __CFString <0, 0x7C8, aCopy, 4> ; "Copy"
__cfstring:00002130 cfstr_Status    __CFString <0, 0x7C8, aStatus, 6> ; "Status"
__cfstring:00002140 cfstr_Payload   __CFString <0, 0x7C8, aPayload, 7> ; "Payload"
__cfstring:00002150 cfstr_Response  __CFString <0, 0x7C8, aResponse, 8> ; "Response"

#endif

@implementation AMDiagnosticsRelayServices

- (BOOL)restartDevice {
    NSDictionary *message;
    message = [NSDictionary dictionaryWithObjectsAndKeys:
               @"Restart", @"Request",
               nil];
    
    [self sendXMLRequest:message];
    return YES;
}

- (BOOL)shutDownDevice {
    NSDictionary *message;
    message = [NSDictionary dictionaryWithObjectsAndKeys:
               @"Shutdown", @"Request",
               nil];
    
    [self sendXMLRequest:message];
    return YES;
}

- (id)initWithAMDevice:(AMDevice*)device
{
    BOOL isSecure = [device isWifiConnection];
    if (self = [super initWithName:@"com.apple.mobile.diagnostics_relay" onDevice:device isSecure:isSecure]) {
        // nothing special
    }
    return self;
}

@end


@implementation AMMobileSync

- (id)initWithAMDevice:(AMDevice*)device
{
	if (self = [super initWithName:@"com.apple.mobilesync" onDevice:device isSecure:YES]) {
		// wait for the version exchange
//		NSLog(@"waiting for the version exchange");
//		NSLog(@"%@", [self readXMLReply]);
		NSLog(@"sending OK");
		[self sendXMLRequest:[NSArray arrayWithObjects:@"DLMessageVersionExchange", @"DLVersionsOk",
			[NSNumber numberWithInt:100],[NSNumber numberWithInt:100],nil]];
		NSLog(@"%@", [self readXMLReply]);
	}
	return self;
}

- (void)dealloc
{
	[self sendXMLRequest:[NSArray arrayWithObjects:@"DLMessageDisconnect", @"So long and thanks for all the fish",nil]];
	[super dealloc];
}

- (id)getData:(id)message waitingReply:(BOOL)waitingReply
{
    id ret = nil;
	NSLog(@"sending %@",message);
	if ([self sendXMLRequest:message]) {
        if (waitingReply) {
            NSLog(@"waiting reply");
            ret = [self readXMLReply];
            NSLog(@"%@", ret);
        }
	}
    return ret;
}

- (id)startQuerySessionWithDomain:(NSString*)domainStr{
    
    //domainStr 有可能是 @"com.apple.Notes";contacts com.apple.MailAccounts等等内容
    NSArray *message;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	message = [NSArray arrayWithObjects:
               @"SDMessageSyncDataClassWithDevice",
               domainStr,
               @"---",
               [dateFormatter stringFromDate:[NSDate date]],
               [NSNumber numberWithInt:106],		// protocol version 106
               @"___EmptyParameterString___",
               nil];
    NSArray *retArray = [self getData:message waitingReply:YES];
    [dateFormatter release];
    
    message = [NSArray arrayWithObjects:
               @"SDMessageGetAllRecordsFromDevice",
               domainStr,
               nil];
    retArray = [self getData:message waitingReply:YES];
    
    message = [NSArray arrayWithObjects:
               @"SDMessageAcknowledgeChangesFromDevice",
               domainStr,
               nil];
    
    retArray = [self getData:message waitingReply:YES];
    
    return retArray;
}


- (id)startModifySessionWithDomain:(NSString*)domainStr withDomainAnchor:(NSString*)anchorStr{
    //DomainAnchor @"Notes-Device-Anchor"
    //domainStr @"note等"
    
    NSArray *message = nil;
    NSArray *retArray = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	message = [NSArray arrayWithObjects:
               @"SDMessageSyncDataClassWithDevice",
               domainStr,
               anchorStr,
               [dateFormatter stringFromDate:[NSDate date]],
               [NSNumber numberWithInt:106],		// protocol version 106
               @"___EmptyParameterString___",
               nil];
    retArray = [self getData:message waitingReply:YES];
    [dateFormatter release];
    
    // 中间执行添加操作
    message = [NSArray arrayWithObjects:
               @"SDMessageGetChangesFromDevice",
               domainStr,
               nil];
    retArray = [self getData:message waitingReply:YES];
    
    message = [NSArray arrayWithObjects:
               @"SDMessageAcknowledgeChangesFromDevice",
               domainStr,
               nil];
    BOOL isReadFinish = NO;
    while (!isReadFinish) {
        retArray = [self getData:message waitingReply:YES];
        for (id item in retArray) {
            if ([item isKindOfClass:[NSNumber class]]) {
                if ([item boolValue] == NO) {
                    isReadFinish = YES;
                }
            }
        }
    }
    
    message = [NSArray arrayWithObjects:
               @"DLMessagePing",
               @"Preparing to get changes for device",
               nil];
    retArray = [self getData:message waitingReply:YES];
    
    message = [NSArray arrayWithObjects:
               @"SDMessageGetChangesFromDevice",
               domainStr,
               nil];
    retArray = [self getData:message waitingReply:YES];
    return retArray;
}

- (BOOL)startDeleteSessionWithDomain:(NSString*)domainStr withDomainAnchor:(NSString*)anchorStr{
    BOOL result = false;
    NSArray *message;
    NSArray *retArray = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	message = [NSArray arrayWithObjects:
               @"SDMessageSyncDataClassWithDevice",
               domainStr,
               anchorStr,
               [dateFormatter stringFromDate:[NSDate date]],
               [NSNumber numberWithInt:106],		// protocol version 106
               @"___EmptyParameterString___",
               nil];
    retArray = [self getData:message waitingReply:YES];
    [dateFormatter release];
    
    // 中间执行删除操作
    message = [NSArray arrayWithObjects:
               @"SDMessageGetChangesFromDevice",
               @"com.apple.Notes",
               nil];
    retArray = [self getData:message waitingReply:YES];
    
    message = [NSArray arrayWithObjects:
               @"SDMessageAcknowledgeChangesFromDevice",
               @"com.apple.Notes",
               nil];
    BOOL isReadFinish = NO;
    while (!isReadFinish) {
        retArray = [self getData:message waitingReply:YES];
        for (id item in retArray) {
            if ([item isKindOfClass:[NSNumber class]]) {
                if ([item boolValue] == NO) {
                    isReadFinish = YES;
                }
            }
        }
    }
    result = true;
    return result;

}



- (void)endSessionWithDomain:(NSString*)domainStr{
    
    NSArray *message = [NSArray arrayWithObjects:
               @"SDMessageFinishSessionOnDevice",
               domainStr,
               nil];
    [self getData:message waitingReply:YES];
    
    message = [NSArray arrayWithObjects:
               @"SDMessageDeviceFinishedSession",
               domainStr,
               nil];
    [self getData:message waitingReply:YES];
    return;
}



#if 0

http://github.com/MattColyer/libiphone/blob/master/src/MobileSync.c

http://iphone-docs.org/doku.php?id=docs:protocols:screenshot

http://libimobiledevice.org/docs/mobilesync.html

Like other DeviceLink protocols, it starts with a simple handshake (binary plists represented as ruby objects):

< ["DLMessageVersionExchange", 100, 0]
> ["DLMessageVersionExchange", "DLVersionsOk"]
< ["DLMessageDeviceReady"]
After which it will accept commands (in the form [“DLMessageProcessMessage”, {“MessageType” ⇒ commandname}]).

< ["DLMessageProcessMessage", {"MessageType" => "ScreenShotRequest"}]
> ["DLMessageProcessMessage", {"MessageType" => "ScreenShotReply", "ScreenShotData" => png_data}]

	message = [NSArray arrayWithObjects:
				@"SDMessageGetAllRecordsFromDevice",
				@"com.apple.Contacts",
				@"---",
				[NSDate date],
				[NSNumber numberWithInt:106],		// protocol version 106
				@"___EmptyParameterString___",
				nil ];

__cstring:00007008 aSyncsubscribed DCB "SyncSubscribedCalendars",0

__cstring:00006FF4 aCom_apple_cale DCB "com.apple.Calendars",0
__cstring:00007020 aCom_apple_devi DCB "com.apple.DeviceLink",0
__cstring:00007038 aCom_apple_book DCB "com.apple.Bookmarks",0
__cstring:0000704C aCom_apple_note DCB "com.apple.Notes",0



Notifications:
com.apple.MobileSync.SyncAgent.kSyncAgentSyncEnded
com.apple.MobileSync.SyncAgent.kSyncAgentSyncStarted

Commands:
__text:000068EC						; "SDMessageSyncDataClassWithDevice"
__text:000068F0						; "SDMessageSyncDataClassWithComputer"
__text:000068F4						; "SDMessageRefuseToSyncDataClassWithComputer"
__text:000068F8						; "SDMessageClearAllRecordsOnDevice"
__text:000068FC						; "SDMessageDeviceWillClearAllRecords"
__text:00006900						; "SDMessageGetChangesFromDevice"
__text:00006904						; "SDMessageGetAllRecordsFromDevice"
__text:00006908						; "SDMessageProcessChanges"
__text:00006910						; "SDMessageAcknowledgeChangesFromDevice"
__text:00006914						; "SDMessageDeviceReadyToReceiveChanges"
__text:00006918						; "SDMessageRemapRecordIdentifiers"
__text:0000691C						; "SDMessageFinishSessionOnDevice"
__text:00006920						; "SDMessageDeviceFinishedSession"
__text:00006924						; "SDMessageCancelSession"


	plist_t array = build_contact_hello_msg(env);
	ret = iphone_msync_send(env->msync, array);
	plist_free(array);
	array = NULL;
	ret = iphone_msync_recv(env->msync, &array);

		array = plist_new_array();
		plist_add_sub_string_el(array, "SDMessageAcknowledgeChangesFromDevice");
		plist_add_sub_string_el(array, "com.apple.Contacts");

		ret = iphone_msync_send(env->msync, array);
		plist_free(array);
		array = NULL;


	array = plist_new_array();
	plist_add_sub_string_el(array, "DLMessagePing");
	plist_add_sub_string_el(array, "Preparing to get changes for device");

	ret = iphone_msync_send(env->msync, array);
	plist_free(array);
	array = NULL;

	array = plist_new_array();
	plist_add_sub_string_el(array, "SDMessageFinishSessionOnDevice");
	plist_add_sub_string_el(array, "com.apple.Contacts");

	ret = iphone_msync_send(env->msync, array);
	plist_free(array);
	array = NULL;

	ret = iphone_msync_recv(env->msync, &array);

plist_t build_contact_hello_msg(iphone_env *env)
{
	plist_t array = NULL;

	array = plist_new_array();
	plist_add_sub_string_el(array, "SDMessageSyncDataClassWithDevice");
	plist_add_sub_string_el(array, "com.apple.Contacts");

	//get last anchor and send new one
	OSyncError *anchor_error;
	char *timestamp = NULL;
	timestamp = osync_anchor_retrieve(osync_objtype_sink_get_anchor(env->contact_sink),
					  &anchor_error);

	if (timestamp && strlen(timestamp) > 0)
		osync_trace(TRACE_INTERNAL, "timestamp is: %s\n", timestamp);
	else {
		if (timestamp)
			free(timestamp);
		timestamp = strdup("---");
		osync_trace(TRACE_INTERNAL, "first sync!\n");
	};

	time_t t = time(NULL);

	char* new_timestamp = osync_time_unix2vtime(&t);

	plist_add_sub_string_el(array, timestamp);
	plist_add_sub_string_el(array, new_timestamp);

	plist_add_sub_uint_el(array, 106);
	plist_add_sub_string_el(array, "___EmptyParameterString___");

	return array;
}

#endif
@end

@implementation AMMobileBackupRestore
@synthesize backupServiceStatus = _backupServiceStatus;
@synthesize handShakeStatus = _handShakeStatus;
@synthesize quitFlag = _quitFlag;
@synthesize restoreFlags = _restoreFlags;
@synthesize restoreReboot = _restoreReboot;
@synthesize removeNotRestoredItems = _removeNotRestoredItems;
@synthesize backupPassword = _backupPassword;
@synthesize isOnlyManifest = _isOnlyManifest;

- (id)initWithAMDevice:(AMDevice*)device {
    NSString *devVersion = [device productVersion];
    NSString *backupService = nil;
    uint64_t version_major = 0;
    uint64_t version_minor = 0;
    if ([devVersion isVersionLessEqual:@"4.0"]) {
        _isMobileBackup = YES;
        backupService = @"com.apple.mobilebackup";
        version_major = 100;
        version_minor = 0;
    } else {
        _isMobileBackup = NO;
        backupService = @"com.apple.mobilebackup2";
        version_major = 300;
        version_minor = 0;
    }
    if (self = [super initWithName:backupService onDevice:device isSecure:YES]) {
//        _logHandle = [IMBLogManager singleton];
        _backupServiceStatus = YES;
        _device = [device retain];
        _targetUUID = [[device udid] retain];
        _restoreFlags = FLAG_RESTORE_SYSTEM_FILES;
        [self setRestoreReboot:NO];
        [self setRemoveNotRestoredItems:NO];
        [self setBackupPassword:nil];
        NSString *message = nil;
        NSArray *recArray = nil;
        id recObj = [self readXMLReply];
        if (recObj != nil && [recObj isKindOfClass:[NSArray class]]) {
            recArray = (NSArray*)recObj;
            if (recArray.count < 1 || recArray.count <3) {
                _handShakeStatus = NO;
                goto leave;
            }
            message = [self getMessage:recArray];
        }
        if ([NSString isNilOrEmpty:message]) {
            goto leave;
        }
        uint64_t vmajor = [[recArray objectAtIndex:1] longLongValue];
        uint64_t vminor = [[recArray objectAtIndex:2] longLongValue];
        if (vmajor > version_major) {
            _handShakeStatus = NO;
            goto leave;
        } else if ((vmajor == version_major) && (vminor > version_minor)) {
            _handShakeStatus = NO;
            goto leave;
        }
        if ([self sendXMLRequest:[NSArray arrayWithObjects:@"DLMessageVersionExchange", @"DLVersionsOk",
                                  [NSNumber numberWithLongLong:version_major], nil]]) {
            recArray = [self readXMLReply];
            if (recArray != nil) {
                message = [self getMessage:recArray];
                if (![NSString isNilOrEmpty:message] && [message isEqualToString:@"DLMessageDeviceReady"]) {
                    _handShakeStatus = YES;
                } else {
                    _handShakeStatus = NO;
                    goto leave;
                }
            } else {
                _handShakeStatus = NO;
                goto leave;
            }
        } else {
            _handShakeStatus = NO;
            goto leave;
        }
    } else {
        //        _backupServiceStatus = NO;
        //        _device = nil;
    }
leave:;
    return self;
}

- (void)setCondition:(NSCondition *)condition {
    _condition = condition;
}

- (void)dealloc {
    if (_backupServiceStatus) {
        [self disConnectService];
    }
    if (_device != nil) {
        [_device release];
        _device = nil;
    }
    if (_targetUUID != nil) {
        [_targetUUID release];
        _targetUUID = nil;
    }
    [super dealloc];
}

- (BOOL)restoreReboot {
    return _restoreReboot;
}

- (void)setRestoreReboot:(BOOL)restoreReboot {
    if (restoreReboot != _restoreReboot) {
        _restoreReboot = restoreReboot;
        if (_restoreReboot) {
            _restoreFlags |= FLAG_RESTORE_REBOOT;
        } else {
            _restoreFlags &= ~FLAG_RESTORE_REBOOT;
        }
    }
}

- (BOOL)removeNotRestoredItems {
    return _removeNotRestoredItems;
}

- (void)setRemoveNotRestoredItems:(BOOL)removeNotRestoredItems {
    if (removeNotRestoredItems != _removeNotRestoredItems) {
        _removeNotRestoredItems = removeNotRestoredItems;
        if (_removeNotRestoredItems) {
            _restoreFlags |= FLAG_RESTORE_REMOVE_ITEMS;
        } else {
            _restoreFlags &= ~FLAG_RESTORE_REMOVE_ITEMS;
        }
    }
}

- (BOOL)requestWithExcute:(ExcuteEnum)excute withBackupPath:(NSString*)backupPath withSourceUUID:(NSString*)sourceUUID withIsFullBackup:(BOOL)isFullBackup withAFCDirectory:(AFCMediaDirectory*)afcDirectory {
    /* TODO: check domain com.apple.mobile.backup key RequiresEncrypt and WillEncrypt with lockdown */
    /* TODO: verify battery on AC enough battery remaining */
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_START object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_START object:nil userInfo:nil];
    if (backupPath == nil || [backupPath isEqualToString:@""]) {
        return NO;
    }
    
    // 判断备份文件夹是否存在
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:backupPath isDirectory:&isDir]) {
        if (!isDir) {
            [fm removeItemAtPath:backupPath error:nil];
            [fm createDirectoryAtPath:backupPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    } else {
        [fm createDirectoryAtPath:backupPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    BOOL ret = NO;
    if (_isMobileBackup) {
        ret = [self mobileBackup:excute withBackupPath:backupPath withIsFullBackup:isFullBackup withAFCDirectory:afcDirectory];
    } else {
        ret = [self mobileBackup2:excute withBackupPath:backupPath withSourceUUID:sourceUUID withIsFullBackup:isFullBackup withAFCDirectory:afcDirectory];
    }
    return ret;
}

- (BOOL)mobileBackup:(ExcuteEnum)excute withBackupPath:(NSString*)backupPath withIsFullBackup:(BOOL)isFullBackup withAFCDirectory:(AFCMediaDirectory*)afcDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *manifest_plist = nil;
    NSDictionary *info_plist = nil;
    NSString *file_path = nil;
    NSString *statusStr = nil;
    uint64_t backup_total_size = 0;
    uint64_t c = 0;
    enum device_link_file_status_t file_status = DEVICE_LINK_FILE_STATUS_NONE;
    
    backupPath = [backupPath stringByAppendingPathComponent:_targetUUID];
    NSString *infoPath = [[backupPath stringByAppendingPathComponent:@"Info"] stringByAppendingPathExtension:@"plist"];
    if (excute == EXCUTE_RESTORE) {
        if (![fm fileExistsAtPath:infoPath]) {
            return NO;
        }
    }
    
    /* verify existing Info.plist */
    if ([fm fileExistsAtPath:infoPath]) {
        info_plist = [NSMutableDictionary dictionaryWithContentsOfFile:infoPath];
        if (info_plist == nil) {
            isFullBackup = YES;
        }
        if (info_plist && excute == EXCUTE_BACKUP) {
            if ([self info_is_current_device:info_plist]) {
                // update the last backup time within Info.plist
                [info_plist setValue:[NSDate date] forKey:@"Last Backup Date"];
                [fm removeItemAtPath:infoPath error:nil];
                [info_plist writeToFile:infoPath atomically:YES];
            } else {
                // Aborting backup. Backup is not compatible with the current device
                return NO;
            }
        } else if (info_plist && excute == EXCUTE_RESTORE) {
            if (![self info_is_current_device:info_plist]) {
                // Aborting restore. Backup data is not compatible with the current device.
                return NO;
            }
        }
    } else {
        if (excute == EXCUTE_BACKUP) {
            isFullBackup = YES;
        } else {
            // Aborting restore. Info.plist is missing.
            return NO;
        }
    }
    
    BOOL ret = NO;
    NSString *manifest_path = [[backupPath stringByAppendingPathComponent:@"Manifest"] stringByAppendingPathExtension:@"plist"];
    switch (excute) {
        case EXCUTE_BACKUP: {
            // read the last Manifest.plist
            if (!isFullBackup) {
                if ([fm fileExistsAtPath:manifest_path]) {
                    manifest_plist = [NSDictionary dictionaryWithContentsOfFile:manifest_path];
                    if (manifest_plist == nil) {
                        isFullBackup = YES;
                    }
                } else {
                    isFullBackup = YES;
                }
            }
            
            // create new Info.plist on new backups
            if (isFullBackup) {
                if (info_plist) {
                    info_plist = nil;
                }
                [fm removeItemAtPath:infoPath error:nil];
                [self info_plist_new:infoPath withAFCDirectory:afcDirectory];
            }
            
            // create Status.plist with failed status for now
            [self status_plist_write:backupPath withStatus:NO];
            
            // request backup from device with manifest from last backup
            BOOL isOk = NO;
            //NSDictionary *msgDic = nil;
            isOk = [self mobilebackup_request_backup:manifest_plist withBasePath:backupPath withProtoVersion:@"1.6"];
            if (isOk) {
                NSLog(@"Please wait. Device is preparing backup data...");
            } else {
                break;
            }
            
            int backup_ok = 0;
            id msgObj = nil;
            
            uint64_t file_size = 0;
            uint64_t file_size_current = 0;
            int file_index = 0;
            int hunk_index = 0;
            uint64_t backup_real_size = 0;
            NSString *filename_mdinfo = nil;
            NSString *filename_mddata = nil;
            NSString *filename_source = nil;
            int is_manifest = 0;
            
            while (YES) {
                msgObj = [self readXMLReply];
                if (msgObj == nil) {
                    NSLog(@"Device is not ready yet. Going to try again in 2 seconds.");
                    sleep(2);
                    goto files_out;
                }
                if (msgObj != nil && [msgObj isKindOfClass:[NSArray class]]) {
                    NSArray *tmpArray = (NSArray*)msgObj;
                    statusStr = (NSString*)[tmpArray objectAtIndex:0];
                    if (![statusStr isEqualToString:@"DLSendFile"]) {
                        break;
                    }
                    
                    id tmpObj = [tmpArray objectAtIndex:2];
                    NSDictionary *tmpDic = nil;
                    if (tmpObj != nil && [tmpObj isKindOfClass:[NSDictionary class]]) {
                        tmpDic = (NSDictionary*)tmpObj;
                        NSArray *allkeys = tmpDic.allKeys;
                        // first message hunk contains total backup size
                        if ((hunk_index == 0) && (file_index == 0)) {
                            if (allkeys!= nil && [allkeys containsObject:@"BackupTotalSizeKey"]) {
                                backup_total_size = [[tmpDic objectForKey:@"BackupTotalSizeKey"] longLongValue];
                            }
                        }
                        // check DLFileStatusKey (codes: 1 = Hunk, 2 = Last Hunk)
                        if (allkeys != nil && [allkeys containsObject:@"DLFileStatusKey"]) {
                            c = [[tmpDic objectForKey:@"DLFileStatusKey"] longLongValue];
                            file_status = (enum device_link_file_status_t)c;
                        }
                        // get source filename
                        BOOL b = NO;
                        if (allkeys != nil && [allkeys containsObject:@"BackupManifestKey"]) {
                            b = [[tmpDic objectForKey:@"BackupManifestKey"] boolValue];
                        }
                        is_manifest = b == YES ? 1 : 0;
                        
                        if ((hunk_index == 0) && (!is_manifest)) {
                            // get source filename
                            if (allkeys != nil && [allkeys containsObject:@"DLFileSource"]) {
                                filename_source = (NSString*)[tmpDic objectForKey:@"DLFileSource"];
                            }
                            // increase received size
                            if (allkeys != nil && [allkeys containsObject:@"DLFileAttributesKey"]) {
                                NSDictionary *attrDic = (NSDictionary*)[tmpDic objectForKey:@"DLFileAttributesKey"];
                                if (attrDic != nil && [attrDic.allKeys containsObject:@"FileSize"]) {
                                    file_size = [[attrDic objectForKey:@"FileSize"] longLongValue];
                                    backup_real_size += file_size;
                                }
                            }
                        }
                        
                        // check if we completed a file
                        if ((file_status == DEVICE_LINK_FILE_STATUS_HUNK) && (!is_manifest)) {
                            // save <hash>.mdinfo
                            if (allkeys != nil && [allkeys containsObject:@"DLFileDest"]) {
                                file_path = (NSString*)[tmpDic objectForKey:@"DLFileDest"];
                                filename_mdinfo = [[backupPath stringByAppendingPathComponent:file_path] stringByAppendingPathExtension:@"mdinfo"];
                                if ([fm fileExistsAtPath:filename_mdinfo]) {
                                    [fm removeItemAtPath:filename_mdinfo error:nil];
                                }
                                if (allkeys != nil && [allkeys containsObject:@"BackupFileInfo"]) {
                                    NSDictionary *mdinfoDic = (NSDictionary*)[tmpDic objectForKey:@"BackupFileInfo"];
                                    [mdinfoDic writeToFile:filename_mdinfo atomically:YES];
                                }
                            }
                            file_index++;
                        }
                        
                        // save <hash>.mddata
                        if (allkeys != nil && [allkeys containsObject:@"DLFileDest"]) {
                            file_path = (NSString*)[tmpDic objectForKey:@"DLFileDest"];
                            filename_mddata = [backupPath stringByAppendingPathComponent:file_path];
                            if (!is_manifest) {
                                filename_mddata = [filename_mddata stringByAppendingPathExtension:@"mddata"];
                            }
                            if ((hunk_index == 0) && [fm fileExistsAtPath:filename_mddata]) {
                                [fm removeItemAtPath:filename_mddata error:nil];
                            }
                            // get file data hunk
                            NSData *fileData = (NSData*)[tmpArray objectAtIndex:1];
                            [fileData writeToFile:filename_mddata atomically:YES];
                            if (!is_manifest) {
                                file_size_current += fileData.length;
                            }
                            // activate currently sent manifest
                            if ((file_status == DEVICE_LINK_FILE_STATUS_LAST_HUNK) && (is_manifest)) {
                                [fm moveItemAtPath:filename_mddata toPath:manifest_path error:nil];
                            }
                        }
                        
                        if (!is_manifest) {
                            if (hunk_index == 0 && file_status == DEVICE_LINK_FILE_STATUS_LAST_HUNK) {
                                NSLog(@"progress is 100");
                            } else {
                                if (file_size > 0) {
                                    NSLog(@"progress is %f", (double)((file_size_current*100)/file_size));
                                }
                            }
                        }
                        hunk_index++;
                        
                        if (file_status == DEVICE_LINK_FILE_STATUS_LAST_HUNK) {
                            // acknowlegdge that we received the file
                            [self mobilebackup_send_backup_file_received];
                            // reset hunk_index
                            hunk_index = 0;
                            if (!is_manifest) {
                                file_size_current = 0;
                                file_size = 0;
                            }
                        }
                    }
                }
            files_out:;
                if (_quitFlag) {
                    [self mobilebackup_send_error:@"Cancelling DLSendFile"];
                    manifest_path = [[backupPath stringByAppendingPathComponent:@"Manifest"] stringByAppendingPathExtension:@"plist.tmp"];
                    if ([fm fileExistsAtPath:manifest_path]) {
                        [fm removeItemAtPath:manifest_path error:nil];
                    }
                    break;
                }
            }
            
            if (!_quitFlag && [statusStr isEqualToString:@"DLMessageProcessMessage"]) {
                NSDictionary *tmp_dict = nil;
                NSArray *allkeys = nil;
                if (msgObj != nil && [msgObj isKindOfClass:[NSArray class]]) {
                    tmp_dict = [(NSArray*)msgObj objectAtIndex:1];
                    allkeys = tmp_dict.allKeys;
                }
                
                if (allkeys != nil && [allkeys containsObject:@"BackupMessageTypeKey"]) {
                    NSString *str = (NSString*)[tmp_dict objectForKey:@"BackupMessageTypeKey"];
                    if ([str isEqualToString:@"BackupMessageBackupFinished"]) {
                        // backup finished
                        
                        // process BackupFilesToDeleteKey
                        if ([allkeys containsObject:@"BackupFilesToDeleteKey"]) {
                            id delObject = [tmp_dict objectForKey:@"BackupFilesToDeleteKey"];
                            if (delObject != nil && [delObject isKindOfClass:[NSArray class]]) {
                                NSArray *delArrays = (NSArray*)delObject;
                                if (delArrays != nil && delArrays.count > 0) {
                                    for (NSString *fp in delArrays) {
                                        if ([self mobilebackup_delete_backup_file_by_hash:fp withBackupDir:backupPath]) {
                                            NSLog(@"Done");
                                        } else {
                                            NSLog(@"Failed");
                                        }
                                    }
                                }
                            }
                        }
                        
                        //save last valid Manifest.plist
                        if ([allkeys containsObject:@"BackupManifestKey"]) {
                            manifest_plist = [tmp_dict objectForKey:@"BackupManifestKey"];
                            if (manifest_plist != nil) {
                                if ([fm fileExistsAtPath:manifest_path]) {
                                    [manifest_plist writeToFile:manifest_path atomically:YES];
                                }
                            }
                        }
                        backup_ok = YES;
                    }
                }
            }
            
            if (backup_ok) {
                // Status.plist (Info on how the backup process turned out)
                [self status_plist_write:backupPath withStatus:YES];
            }
            break;
        }
        case EXCUTE_RESTORE: {
            // verify if Status.plist says we read from an successful backup
            if (![self status_plist_read:backupPath]) {
                break;
            }
            if ([fm fileExistsAtPath:manifest_path]) {
                manifest_plist = [NSDictionary dictionaryWithContentsOfFile:manifest_path];
            } else {
                manifest_plist = nil;
            }
            if (manifest_path == nil) {
                break;
            }
            
            NSData *bin = nil;
            if ([manifest_plist.allKeys containsObject:@"Data"]) {
                bin = (NSData*)[manifest_plist objectForKey:@"Data"];
            } else {
                NSLog(@"Could not read Data key from Manifest.plist!");
                break;
            }
            
            NSDictionary *backup_data = nil;
            if (bin != nil) {
                NSString *auth_ver = nil;
                NSData *auth_sig = nil;
                NSArray *allKeys = manifest_plist.allKeys;
                if ([allKeys containsObject:@"AuthVersion"]) {
                    auth_ver = (NSString*)[manifest_plist objectForKey:@"AuthVersion"];
                    if (![NSString isNilOrEmpty:auth_ver] && [auth_ver isEqualToString:@"2.0"]) {
                        if ([allKeys containsObject:@"AuthSignature"]) {
                            auth_sig = (NSData*)[manifest_plist objectForKey:@"AuthSignature"];
                            if (auth_sig != nil && auth_sig.length == 20) {
                                NSData *dataSha1 = [bin sha1];
                                if ([dataSha1 bytesEqual:auth_sig]) {
                                    NSLog(@"AuthSignature is valid");
                                } else {
                                    NSLog(@"ERROR: AuthSignature is NOT VALID.");
                                }
                            }
                        }
                    } else if(![NSString isNilOrEmpty:auth_ver]) {
                        NSLog(@"Unknown AuthVersion %@, cannot verify AuthSignature.", auth_ver);
                    }
                }
                backup_data = [NSDictionary dictionaryFromData:bin];
            }
            if (backup_data == nil) {
                break;
            }
            NSDictionary *files = nil;
            if ([backup_data.allKeys containsObject:@"Files"]) {
                id fsObj = (NSDictionary*)[backup_data objectForKey:@"Files"];
                if (fsObj != nil && [fsObj isKindOfClass:[NSDictionary class]]) {
                    files = (NSDictionary*)fsObj;
                    BOOL file_ok = NO;
                    NSEnumerator *enumerator = [files keyEnumerator];
                    if (enumerator != nil) {
                        id key = [enumerator nextObject];
                        while (key) {
                            id obj = [files objectForKey:key];
                            file_ok = [self mobilebackup_check_file_integrity:backupPath withFileName:(NSString*)key withFileData:(NSDictionary*)obj];
                            if (!file_ok) {
                                break;
                            }
                            key = [enumerator nextObject];
                        }
                        if (!file_ok) {
                            break;
                        }
                    }
                }
            }
            
            // request restore from device with manifest (BackupMessageRestoreMigrate)
            BOOL isOk = NO;
            int restore_flags = MB_RESTORE_NOTIFY_SPRINGBOARD | MB_RESTORE_PRESERVE_SETTINGS | MB_RESTORE_PRESERVE_CAMERA_ROLL;
            isOk = [self mobilebackup_request_restore:manifest_plist withMobileBackupFlags:restore_flags withProtoVersion:@"1.6"];
            if (isOk) {
                NSLog(@"Please wait. Device is preparing backup data...");
            } else {
                break;
            }
            
            int restore_ok = 0;
            if (files) {
                NSEnumerator *enumerator = [files keyEnumerator];
                if (enumerator != nil) {
                    NSString *file_info_path = nil;
                    NSMutableDictionary *file_info = nil;
                    int cur_file = 0;
                    uint64_t file_offset = 0;
                    BOOL is_encrypted = NO;
                    NSData *mdData = nil;
                    NSDictionary *tmpDict = nil;
                    uint64_t length = 0;
                    id key = [enumerator nextObject];
                    while (key) {
                        id obj = [files objectForKey:key];
                        file_info_path = [[backupPath stringByAppendingPathComponent:(NSString*)key] stringByAppendingPathExtension:@"mdinfo"];
                        file_info = [NSMutableDictionary dictionaryWithContentsOfFile:file_info_path];
                        NSArray *miAllKeys = file_info.allKeys;
                        if (miAllKeys != nil && [miAllKeys containsObject:@"IsEncrypted"]) {
                            is_encrypted = [[file_info objectForKey:@"IsEncrypted"] boolValue];
                        }
                        if (miAllKeys != nil && [miAllKeys containsObject:@"Metadata"]) {
                            mdData = (NSData*)[file_info objectForKey:@"Metadata"];
                            tmpDict = [NSDictionary dictionaryFromData:mdData];
                        }
                        if (tmpDict != nil && [tmpDict.allKeys containsObject:@"Path"]) {
                            file_path = (NSString*)[tmpDict objectForKey:@"Path"];
                        }
                        
                        // add additional device link file information keys
                        [file_info setObject:[(NSDictionary*)obj mutableCopy] forKey:@"DLFileAttributesKey"];
                        [file_info setObject:file_info_path forKey:@"DLFileSource"];
                        [file_info setObject:@"/tmp/RestoreFile.plist" forKey:@"DLFileDest"];
                        [file_info setObject:[NSNumber numberWithBool:is_encrypted] forKey:@"DLFileIsEncrypted"];
                        [file_info setObject:[NSNumber numberWithLongLong:file_offset] forKey:@"DLFileOffsetKey"];
                        [file_info setObject:[NSNumber numberWithInt:file_status] forKey:@"DLFileStatusKey"];
                        
                        // read data from file
                        file_info_path = [[backupPath stringByAppendingPathComponent:(NSString*)key] stringByAppendingPathExtension:@"mddata"];
                        NSData *buffData = [NSData dataWithContentsOfFile:file_info_path];
                        length = buffData.length;
                        
                        file_offset = 0;
                        while (file_offset < length) {
                            if ((length - file_offset) <= 8192) {
                                file_status = DEVICE_LINK_FILE_STATUS_LAST_HUNK;
                            } else {
                                file_status = DEVICE_LINK_FILE_STATUS_HUNK;
                            }
                            [file_info removeObjectForKey:@"DLFileOffsetKey"];
                            [file_info setObject:[NSNumber numberWithLongLong:file_offset] forKey:@"DLFileOffsetKey"];
                            [file_info removeObjectForKey:@"DLFileStatusKey"];
                            [file_info setObject:[NSNumber numberWithInt:file_status] forKey:@"DLFileStatusKey"];
                            NSMutableArray *send_file_list = [[NSMutableArray alloc] init];
                            [send_file_list addObject:@"DLSendFile"];
                            if (file_status == DEVICE_LINK_FILE_STATUS_HUNK) {
                                [send_file_list addObject:[buffData subdataWithRange:NSMakeRange((int)file_offset, (int)(length - file_offset))]];
                            } else {
                                [send_file_list addObject:[buffData subdataWithRange:NSMakeRange((int)file_offset, 8192)]];
                            }
                            [send_file_list addObject:file_info];
                            ret = [self mobilebackup_send:send_file_list];
                            [send_file_list release];
                            send_file_list = nil;
                            if (!ret) {
                                file_status = NO;
                            }
                            if (file_status == DEVICE_LINK_FILE_STATUS_LAST_HUNK) {
                                NSDictionary *recObj = [self mobilebackup_receive_restore_file_received];
                                if (recObj == nil) {
                                    file_status = DEVICE_LINK_FILE_STATUS_NONE;
                                }
                            }
                            file_offset += 8192;
                            if (file_status ==  DEVICE_LINK_FILE_STATUS_LAST_HUNK) {
                                NSLog(@"Done!");
                            }
                            if (file_status == DEVICE_LINK_FILE_STATUS_NONE) {
                                break;
                            }
                        }
                        restore_ok = YES;
                        if (file_status == DEVICE_LINK_FILE_STATUS_NONE) {
                            restore_ok = NO;
                            break;
                        }
                        cur_file++;
                        key = [enumerator nextObject];
                    }
                    NSLog(@"Restored %d files on device.", cur_file);
                }
                
            }
            
            id appObj = [backup_data objectForKey:@"Applications"];
            if (appObj != nil && [appObj isKindOfClass:[NSDictionary class]] && restore_ok) {
                NSDictionary *applications = (NSDictionary*)appObj;
                NSEnumerator *enumerator = [applications keyEnumerator];
                if (enumerator != nil) {
                    // loop over Application entries in Manifest data plist
                    int total_files = (int)applications.allKeys.count;
                    int cur_file = 1;
                    NSMutableDictionary *dict = nil;
                    NSMutableArray *array = nil;
                    NSDictionary *tmpDict = nil;
                    id key = [enumerator nextObject];
                    while (key) {
                        NSLog(@"Restoring Application %d/%d (%d%%)...", cur_file, total_files, (cur_file * 100 / total_files));
                        tmpDict = [[applications objectForKey:key] objectForKey:@"AppInfo"];
                        dict = [[NSMutableDictionary alloc] init];
                        [dict setObject:tmpDict forKey:@"AppInfo"];
                        [dict setObject:@"BackupMessageRestoreApplicationSent" forKey:@"BackupMessageTypeKey"];
                        array = [[NSMutableArray alloc] init];
                        [array addObject:@"DLMessageProcessMessage"];
                        [array addObject:dict];
                        [dict release];
                        dict = nil;
                        ret = [self mobilebackup_send:array];
                        [array release];
                        array = nil;
                        if (!ret) {
                            NSLog(@"ERROR: Unable to restore application %@ due to error %d. Aborting...", key, ret);
                            restore_ok = NO;
                        }
                        // receive BackupMessageRestoreApplicationReceived from device
                        if (restore_ok) {
                            NSDictionary *recObj = [self mobilebackup_receive_restore_application_received];
                            if (recObj == nil) {
                                NSLog(@"ERROR: Failed to receive an ack from the device for this application due to error. Aborting...");
                                restore_ok = NO;
                            }
                        }
                        
                        if (restore_ok) {
                            cur_file++;
                            key = [enumerator nextObject];
                        } else {
                            break;
                        }
                    }
                    if (restore_ok) {
                        NSLog(@"All applications restored.");
                    } else {
                        NSLog(@"Failed to restore applications.");
                    }
                }
            }
            
            // signal restore finished message to device; BackupMessageRestoreComplete
            if (restore_ok) {
                ret = [self mobilebackup_send_restore_complete];
                if (!ret) {
                    NSLog(@"ERROR: Could not send BackupMessageRestoreComplete.");
                }
            }
            if (restore_ok) {
                NSLog(@"Restore Successful.");
            } else {
                NSLog(@"Restore Failed.");
            }
            break;
        }
        default:
            break;
    }
    return ret;
}

- (BOOL)mobileBackup2:(ExcuteEnum)excute withBackupPath:(NSString*)backupPath withSourceUUID:(NSString*)sourceUUID withIsFullBackup:(BOOL)isFullBackup withAFCDirectory:(AFCMediaDirectory*)afcDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL result = NO;
    NSDictionary *manifest_plist = nil;
    NSDictionary *info_plist = nil;
    if (excute == EXCUTE_CLOUD) {
        NSArray *asDirArray = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        if (asDirArray != nil && asDirArray.count > 0) {
            backupPath = (NSString*)[asDirArray objectAtIndex:0];
        } else {
            backupPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support"];
        }
        backupPath = [backupPath stringByAppendingPathComponent:@"MobileSync/iCloudBackup"];
    } else {
        if ([NSString isNilOrEmpty:backupPath]) {
//            [_logHandle writeInfoLog:@"No target backup directory specified."];
            return NO;
        }
        if (![fm fileExistsAtPath:backupPath]) {
            //1001错误
            NSNumber *errorId = [NSNumber numberWithInt:1001];
            NSString *error = [NSString stringWithFormat:@"ERROR: Backup directory \"%@\" does not exist!", backupPath];
//            [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROEID:%d ; %@", errorId.intValue, error]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:error, @"errorReason", errorId, @"errorId", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
            return NO;
        }
    }
    
    if ([NSString isNilOrEmpty:sourceUUID]) {
        sourceUUID = _targetUUID;
    }
    
    BOOL is_encrypted = NO;
    NSString *infoPath = nil;
    NSString *manifestPath = nil;
    BOOL willEncrypt = NO;
    if (excute != EXCUTE_CLOUD) {
        // backup directory must contain an Info.plist
        infoPath = [[backupPath stringByAppendingPathComponent:sourceUUID] stringByAppendingPathComponent:@"Info.plist"];
        if (excute == EXCUTE_RESTORE) {
            if (![fm fileExistsAtPath:infoPath]) {
                //1002错误
                NSNumber *errorId = [NSNumber numberWithInt:1002];
                NSString *error = [NSString stringWithFormat:@"ERROR: Backup directory \"%@\" is invalid. No Info.plist found for UDID %@.", backupPath, sourceUUID];
//                [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROEID:%d ; %@", errorId.intValue, error]];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:error, @"errorReason", errorId, @"errorId", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
                
                return NO;
            }
            manifestPath = [[backupPath stringByAppendingPathComponent:sourceUUID] stringByAppendingPathComponent:@"Manifest.plist"];
            if (![fm fileExistsAtPath:manifestPath]) {
                return NO;
            }
            manifest_plist = [NSDictionary dictionaryWithContentsOfFile:manifestPath];
            if (manifest_plist == nil) {
                //1002错误
                NSNumber *errorId = [NSNumber numberWithInt:1002];
                NSString *error = [NSString stringWithFormat:@"ERROR: Backup directory \"%@\" is invalid. No Manifest.plist found for UDID %@.", backupPath, sourceUUID];
//                [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROEID:%d ; %@", errorId.intValue, error]];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:error, @"errorReason", errorId, @"errorId", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
                return NO;
            }
            if ([manifest_plist.allKeys containsObject:@"IsEncrypted"]) {
                is_encrypted = [[manifest_plist objectForKey:@"IsEncrypted"] boolValue];
            }
        }
    }
//    if (excute != EXCUTE_CLOUD && is_encrypted) {
//        [_logHandle writeInfoLog:@"This is an encrypted backup."];
//        // Todo Require the user to cancel the backup password
//    }
    
    //send Hello message
    NSArray *localVersions = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2.0], [NSNumber numberWithDouble:2.1], nil];
    double remoteVersion = 0.0;
    BOOL exchRet = [self mobilebackup2_version_exchange:localVersions withRemoteVersion:&remoteVersion];
    if (!exchRet) {
//        [_logHandle writeInfoLog:@"Could not perform backup protocol version exchange."];
        excute = EXCUTE_LEAVE;
        goto checkpoint;
    }
    
    
    // check abort conditions
    ScanStatus *scanStatus =[ScanStatus shareInstance];
    [_condition lock];
    if (scanStatus.isPause) {
        [_condition wait];
    }
    [_condition unlock];
    if (_quitFlag) {
        excute = EXCUTE_LEAVE;
        goto checkpoint;
    }
    
    // verify existing Info.plist
    if (![NSString isNilOrEmpty:infoPath] && [fm fileExistsAtPath:infoPath] && excute != EXCUTE_CLOUD) {
//        [_logHandle writeInfoLog:@"Reading Info.plist from backup."];
        info_plist = [NSDictionary dictionaryWithContentsOfFile:infoPath];
        if (info_plist == nil) {
            isFullBackup = YES;
        } else if (info_plist != nil && ((excute ==  EXCUTE_BACKUP) || (excute == EXCUTE_RESTORE))) {
            if (![self info_is_current_device:info_plist]) {
                if (excute == EXCUTE_BACKUP) {
                    //TODO:重命名该备份;
                    NSString *lbDate = nil;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
                    NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:infoPath];
                    if (infoDic != nil && [[infoDic allKeys] count] > 0) {
                        NSArray *allKey = [infoDic allKeys];
                        if ([allKey containsObject:@"Last Backup Date"]) {
                            lbDate = [dateFormatter stringFromDate:(NSDate *)[infoDic objectForKey:@"Last Backup Date"]];
                        }
                    }
                    if (lbDate == nil) {
                        lbDate = [dateFormatter stringFromDate:[NSDate date]];
                    }
                    if ([fm fileExistsAtPath:[backupPath stringByAppendingPathComponent:sourceUUID]]) {
                        NSString *toPath = [backupPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", sourceUUID, lbDate]];
                        [fm moveItemAtPath:[backupPath stringByAppendingPathComponent:sourceUUID] toPath:toPath error:nil];
                        isFullBackup = YES;
                    }
                    [dateFormatter release];
                    dateFormatter = nil;
                }else {
                    //1003错误
                    NSNumber *errorId = [NSNumber numberWithInt:1003];
                    NSString *error = @"Aborting. Backup data is not compatible with the current device.";
//                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROEID:%d ; %@", errorId.intValue, error]];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:error, @"errorReason", errorId, @"errorId", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
                    excute = EXCUTE_LEAVE;
                }
            }
        }
    } else {
        if (excute == EXCUTE_RESTORE) {
//            [_logHandle writeInfoLog:@"Aborting restore. Info.plist is missing."];
            //1002错误
            NSNumber *errorId = [NSNumber numberWithInt:1002];
            NSString *error = [NSString stringWithFormat:@"ERROR: Backup directory \"%@\" is invalid. No Info.plist found for UDID %@.", backupPath, sourceUUID];
//            [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROEID:%d ; %@", errorId.intValue, error]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:error, @"errorReason", errorId, @"errorId", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
            excute = EXCUTE_LEAVE;
        } else {
            isFullBackup = YES;
        }
    }
    
    if (isFullBackup) {
        _restoreFlags |= FLAG_FORCE_FULL_BACKUP;
    }
    
    
    willEncrypt = [[_device deviceValueForKey:@"WillEncrypt" inDomain:@"com.apple.mobile.backup"] boolValue];
checkpoint:;
    BOOL ret = NO;
    NSMutableDictionary *opts =nil;
    switch (excute) {
        case EXCUTE_CLOUD: {
            opts = [[NSMutableDictionary alloc] init];
            [opts setObject:[NSNumber numberWithBool:(self.restoreFlags & FLAG_CLOUD_ENABLE)] forKey:@"CloudBackupState"];
            ret =  [self mobilebackup2_send_request:@"EnableCloudBackup" withTarUDID:_targetUUID withSourUDID:sourceUUID withOptions:opts];
            [opts release];
            opts = nil;
            if (!ret) {
//                [_logHandle writeInfoLog:@"Error setting cloud backup state on device."];
                excute = EXCUTE_LEAVE;
            }
            break;
        }
        case EXCUTE_BACKUP: {
            NSString *devbackupdir = [backupPath stringByAppendingPathComponent:sourceUUID];
            if (![sourceUUID isEqualToString:_targetUUID]) {
                // handle different source backup directory, make sure target backup device sub-directory exists
                devbackupdir = [backupPath stringByAppendingPathComponent:_targetUUID];
            }
            if (![fm fileExistsAtPath:devbackupdir]) {
                [fm createDirectoryAtPath:devbackupdir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            infoPath = [devbackupdir stringByAppendingPathComponent:@"Info.plist"];
            // TODO: check domain com.apple.mobile.backup key RequiresEncrypt and WillEncrypt with lockdown
            // TODO: verify battery on AC enough battery remaining
            
            // re-create Info.plist (Device infos, IC-Info.sidb, photos, app_ids, iTunesPrefs)
            [self info_plist_new:infoPath withAFCDirectory:afcDirectory];
            //NSString *statusplist = [devbackupdir stringByAppendingPathComponent:@"Status.plist"];
            //[self status_plist_new:statusplist withIsFullBackup:isFullBackup];
            if (self.restoreFlags & FLAG_FORCE_FULL_BACKUP) {
                opts = [[NSMutableDictionary alloc] init];
                [opts setObject:[NSNumber numberWithBool:YES] forKey:@"ForceFullBackup"];
            }
            
            // request backup from device with manifest from last backup
//            if (willEncrypt) {
//                [_logHandle writeInfoLog:@"Backup will be encrypted."];
//            } else {
//                [_logHandle writeInfoLog:@"Backup will be unencrypted."];
//            }
            ret = [self mobilebackup2_send_request:@"Backup" withTarUDID:_targetUUID withSourUDID:sourceUUID withOptions:opts];
            if (opts != nil) {
                [opts release];
                opts = nil;
            }
            if (ret) {
//                if (isFullBackup) {
//                    [_logHandle writeInfoLog:@"Full backup mode."];
//                } else {
//                    [_logHandle writeInfoLog:@"Incremental backup mode."];
//                }
            } else {
                excute = EXCUTE_LEAVE;
            }
            break;
        }
        case EXCUTE_RESTORE: {
            /* TODO: verify battery on AC enough battery remaining */
            
            // verify if Status.plist says we read from an successful backup
            if (![self mb2_status_check_snapshot_state:backupPath withUDID:sourceUUID withMatches:@"finished"]) {
                //1004错误
                NSNumber *errorId = [NSNumber numberWithInt:1004];
                NSString *error = [NSString stringWithFormat:@"ERROR: Cannot ensure we restore from a successful backup. Aborting."];
//                [_logHandle writeInfoLog:error];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:error, @"errorReason", errorId, @"errorId", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
                excute = EXCUTE_LEAVE;
                break;
            }
            
            opts = [[NSMutableDictionary alloc] init];
            [opts setObject:[NSNumber numberWithBool:(self.restoreFlags & FLAG_RESTORE_SYSTEM_FILES)] forKey:@"RestoreSystemFiles"];
            if ((self.restoreFlags & FLAG_RESTORE_REBOOT) == 0) {
                [opts setObject:[NSNumber numberWithBool:NO] forKey:@"RestoreShouldReboot"];
            } else {
                [opts setObject:[NSNumber numberWithBool:YES] forKey:@"RestoreShouldReboot"];
            }
            if ((self.restoreFlags & FLAG_RESTORE_COPY_BACKUP) == 0) {
                [opts setObject:[NSNumber numberWithBool:YES] forKey:@"RestoreDontCopyBackup"];
            }
            [opts setObject:[NSNumber numberWithBool:((self.restoreFlags & FLAG_RESTORE_SETTINGS) == 0)] forKey:@"RestorePreserveSettings"];
            //            if ((self.restoreFlags & FLAG_RESTORE_REMOVE_ITEMS)) {
            [opts setObject:[NSNumber numberWithBool:YES] forKey:@"RemoveItemsNotRestored"];
            //            }
            
            //            [opts setObject:[NSNumber numberWithBool:YES] forKey:@"RestoreSystemFiles"];
            //            [opts setObject:[NSNumber numberWithBool:YES] forKey:@"RestoreShouldReboot"];
            //            [opts setObject:[NSNumber numberWithBool:YES] forKey:@"RestoreDontCopyBackup"];
            //            [opts setObject:[NSNumber numberWithBool:NO] forKey:@"RemoveItemsNotRestored"];
            
            if (![NSString isNilOrEmpty:self.backupPassword]) {
                [opts setObject:self.backupPassword forKey:@"Password"];
            }
            ret = [self mobilebackup2_send_request:@"Restore" withTarUDID:_targetUUID withSourUDID:sourceUUID withOptions:opts];
            [opts release];
            opts = nil;
            if (!ret) {
                excute = EXCUTE_LEAVE;
            }
            break;
        }
        case EXCUTE_INFO: {
            [self mobilebackup2_send_request:@"Info" withTarUDID:_targetUUID withSourUDID:sourceUUID withOptions:nil];
            break;
        }
        case EXCUTE_LIST: {
            [self mobilebackup2_send_request:@"List" withTarUDID:_targetUUID withSourUDID:sourceUUID withOptions:nil];
            break;
        }
        default: {
            break;
        }
    }
    
    if (excute != EXCUTE_LEAVE) {
        BOOL operation_ok = NO;
        NSString *dlMsg = nil;
        int errcode = 0;
        char *errdesc = NULL;
        int file_count = 0;
        NSArray *message = nil;
        while (YES) {
            if (![NSString isNilOrEmpty:dlMsg]) {
                dlMsg = nil;
            }
            NSArray *rcvMsg = [self mobilebackup2_receive_message];
            //NSLog(@"rcvMsg is %@", rcvMsg);
            if (rcvMsg != nil && rcvMsg.count > 0) {
                for (id item in rcvMsg) {
                    if (item != nil && [item isKindOfClass:[NSString class]]) {
                        dlMsg = (NSString*)item;
                    } else if (item != nil && [item isKindOfClass:[NSArray class]]) {
                        message = (NSArray*)item;
                    }
                }
            }
            if (message == nil || [NSString isNilOrEmpty:dlMsg]) {
                sleep(2);
                goto files_out;
            }
            if ([dlMsg isEqualToString:@"DLMessageDownloadFiles"]) {
                // device wants to download files from the computer
                [self mb2_set_overall_progress_from_message:message withIdentifier:dlMsg];
                [self mb2_handle_send_files:message withBackupDir:backupPath];
            } else if ([dlMsg isEqualToString:@"DLMessageUploadFiles"]) {
                // device wants to send files to the computer
                [self mb2_set_overall_progress_from_message:message withIdentifier:dlMsg];
                file_count += [self mb2_handle_receive_files:message withBackupDir:backupPath];
                if (_quitFlag) {
                    break;
                }
            } else if ([dlMsg isEqualToString:@"DLMessageGetFreeDiskSpace"]) {
                // device wants to know how much disk space is available on the computer
                uint64_t freeSpace = 0;
                int res = -1;
                struct statvfs fs;
                memset(&fs, 0x00, sizeof(fs));
                res = statvfs([backupPath cStringUsingEncoding:NSUTF8StringEncoding], &fs);
                if (res == 0) {
                    freeSpace = (uint64_t)fs.f_bavail * (uint64_t)fs.f_bsize;
                }
                [self mobilebackup2_send_status_response:res withStatus1:nil withStatus2:[NSNumber numberWithUnsignedLongLong:freeSpace]];
            } else if ([dlMsg isEqualToString:@"DLContentsOfDirectory"]) {
                // list directory contents
                [self mb2_handle_list_directory:message withBackupDir:backupPath];
            } else if ([dlMsg isEqualToString:@"DLMessageCreateDirectory"]) {
                // make a directory
                [self mb2_handle_make_directory:message withBackupDir:backupPath];
            } else if ([dlMsg isEqualToString:@"DLMessageMoveFiles"] || [dlMsg isEqualToString:@"DLMessageMoveItems"]) {
                // perform a series of rename operations
                [self mb2_set_overall_progress_from_message:message withIdentifier:dlMsg];
                NSDictionary *moves = [message objectAtIndex:1];
                uint32_t cnt = 0;
                if (moves != nil) {
                    cnt = (int)moves.allKeys.count;
                }
//                [_logHandle writeInfoLog:[NSString stringWithFormat:@"Moving %d file%@", cnt ,(cnt == 1) ? @"" : @"s"]];
                errcode = 0;
                errdesc = NULL;
                NSEnumerator *enumerator = [moves keyEnumerator];
                if (enumerator != nil) {
                    id key = nil;
                    id node = nil;
                    while (key = [enumerator nextObject]) {
                        node = [moves objectForKey:key];
                        if ([node isKindOfClass:[NSString class]]) {
                            NSString *str = (NSString*)node;
                            if (![NSString isNilOrEmpty:str]) {
                                NSString *newPath = [backupPath stringByAppendingPathComponent:str];
                                NSString *oldPath = [backupPath stringByAppendingPathComponent:(NSString*)key];
                                if ([fm fileExistsAtPath:newPath]) {
                                    [fm removeItemAtPath:newPath error:nil];
                                }
                                NSError *err = nil;
                                if (![fm moveItemAtPath:oldPath toPath:newPath error:&err]) {
//                                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"Renameing '%@' to '%@' failed: %s (%ld).", oldPath, newPath, strerror((int)err.code), (long)err.code]];
                                    errcode = [self errno_to_device_error:(int)err.code];
                                    errdesc = strerror((int)err.code);
                                    break;
                                }
                            }
                        }
                        key = nil;
                    }
                } else {
                    errcode = -1;
                    errdesc = "Could not create dict iterator";
//                    [_logHandle writeInfoLog:@"Could not create dict iterator"];
                }
                NSMutableDictionary *emptyDict = [[NSMutableDictionary alloc] init];
                if (![self mobilebackup2_send_status_response:errcode withStatus1:(errdesc ? [NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding] : nil) withStatus2:emptyDict]) {
//                    [_logHandle writeInfoLog:@"Could not send status response"];
                }
                [emptyDict release];
                emptyDict = nil;
                if (errcode != 0 || errdesc != NULL) {
//                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROEID:%d ; %s", errcode, errdesc]];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding], @"errorReason", [NSNumber numberWithInt:errcode], @"errorId", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
                    return NO;
                }
            } else if ([dlMsg isEqualToString:@"DLMessageRemoveFiles"] || [dlMsg isEqualToString:@"DLMessageRemoveItems"]) {
                [self mb2_set_overall_progress_from_message:message withIdentifier:dlMsg];
                NSArray *removes = (NSArray*)[message objectAtIndex:1];
                uint32_t cnt = 0;
                if (removes != nil) {
                    cnt = (int)removes.count;
                }
//                [_logHandle writeInfoLog:[NSString stringWithFormat:@"Removing %d file%@", cnt ,(cnt == 1) ? @"" : @"s"]];
                errcode = 0;
                errdesc = NULL;
                for (uint32_t i = 0; i < cnt; i++) {
                    id obj = [removes objectAtIndex:i];
                    if (obj != nil && [obj isKindOfClass:[NSString class]]) {
                        NSString *str = (NSString*)obj;
                        if (![NSString isNilOrEmpty:str]) {
                            NSRange range = [str rangeOfString:@"/" atOccurrence:1];
                            NSString *checkfile = nil;
                            BOOL suppress_warning = NO;
                            if (range.location != NSNotFound) {
                                checkfile = [str substringFromIndex:(range.location+range.length)];
                            }
                            if (![NSString isNilOrEmpty:checkfile] && [checkfile isEqualToString:@"Manifest.mbdx"]) {
                                suppress_warning = YES;
                            }
                            NSString *newPath = [backupPath stringByAppendingPathComponent:str];
                            if ([fm fileExistsAtPath:newPath]) {
                                NSError *err;
                                if (![fm removeItemAtPath:newPath error:&err]) {
                                    if (!suppress_warning) {
//                                        [_logHandle writeInfoLog:[NSString stringWithFormat:@"Could not remove '%@': %s (%ld)", newPath, strerror((int)err.code), (long)err.code]];
                                        errcode = [self errno_to_device_error:(int)err.code];
                                        errdesc = strerror((int)err.code);
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                NSMutableDictionary *emptyDict = [[NSMutableDictionary alloc] init];
                if (![self mobilebackup2_send_status_response:errcode withStatus1:(errdesc ? [NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding] : nil) withStatus2:emptyDict]) {
//                    [_logHandle writeInfoLog:@"Could not send status response"];
                }
                [emptyDict release];
                emptyDict = nil;
                if (errcode != 0 || errdesc != NULL) {
//                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROEID:%d ; %s", errcode, errdesc]];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding], @"errorReason", [NSNumber numberWithInt:errcode], @"errorId", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
                    return NO;
                }
            } else if ([dlMsg isEqualToString:@"DLMessageCopyItem"]) {
                id srcObj = [message objectAtIndex:1];
                id dstObj = [message objectAtIndex:2];
                errcode = 0;
                errdesc = NULL;
                NSString *srcPath = nil;
                NSString *dstPath = nil;
                if (srcObj && [srcObj isKindOfClass:[NSString class]]) {
                    srcPath = (NSString*)srcObj;
                }
                if (dstObj && [dstObj isKindOfClass:[NSString class]]) {
                    dstPath = (NSString*)dstObj;
                }
                if (![NSString isNilOrEmpty:srcPath] && ![NSString isNilOrEmpty:dstPath]) {
                    NSString *oldPath = [backupPath stringByAppendingPathComponent:srcPath];
                    NSString *newPath = [backupPath stringByAppendingPathComponent:dstPath];
//                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"Copying '%@' to '%@'", srcPath, dstPath]];
                    // check that src exists
                    if ([fm fileExistsAtPath:oldPath]) {
                        if ([fm fileExistsAtPath:newPath]) {
                            [fm removeItemAtPath:newPath error:nil];
                        }
                        [fm copyItemAtPath:oldPath toPath:newPath error:nil];
                    }
                }
                NSMutableDictionary *emptyDict = [[NSMutableDictionary alloc] init];
                if (![self mobilebackup2_send_status_response:errcode withStatus1:(errdesc ? [NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding] : nil) withStatus2:emptyDict]) {
//                    [_logHandle writeInfoLog:@"Could not send status response"];
                }
                [emptyDict release];
                emptyDict = nil;
            } else if ([dlMsg isEqualToString:@"DLMessageDisconnect"]) {
                errcode = -10;
                errdesc = "device disconnect.";
//                [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROEID:%d ; %s", errcode, errdesc]];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding], @"errorReason", [NSNumber numberWithInt:errcode], @"errorId", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
                return NO;
            } else if ([dlMsg isEqualToString:@"DLMessageProcessMessage"]) {
                id node = [message objectAtIndex:1];
                if (node && [node isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = (NSDictionary*)node;
                    errcode = -1;
                    if ([dict.allKeys containsObject:@"ErrorCode"]) {
                        uint64_t ec = [[dict objectForKey:@"ErrorCode"] unsignedLongLongValue];
                        errcode = (uint32_t)ec;
                        if (errcode == 0 ) {
                            operation_ok = YES;
                            result = YES;
                        } else {
                            result = NO;
//                            [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROR: error code = %d", -errcode]];
                        }
                    }
                    
                    if ([dict.allKeys containsObject:@"ErrorDescription"]) {
                        NSString *str = (NSString*)[dict objectForKey:@"ErrorDescription"];
                        if (errcode != 0) {
//                            if ([NSString isNilOrEmpty:str]) {
//                                [_logHandle writeInfoLog:[NSString stringWithFormat:@"ErrorCode %d: (Unknown)", errcode]];
//                            } else {
//                                [_logHandle writeInfoLog:[NSString stringWithFormat:@"ErrorCode %d: %@", errcode, str]];
//                            }
                            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:str, @"errorReason", [NSNumber numberWithInt:errcode], @"errorId", nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
                            return NO;
                        }
                    }
                    
                    if ([dict.allKeys containsObject:@"Content"]) {
                        NSString *str = (NSString*)[dict objectForKey:@"Content"];
//                        [_logHandle writeInfoLog:[NSString stringWithFormat:@"Content:%@", str]];
                    }
                } else {
//                    [_logHandle writeInfoLog:@"Unknown message received!"];
                }
                break;
            } else  {
//                [_logHandle writeInfoLog:[NSString stringWithFormat:@"Other message is %@", dlMsg]];
            }
            
            // print status
            int overall_progress = 0;
            if (overall_progress > 0) {
                NSLog(@"Finished");
            }
            
            if (message) {
                message = nil;
            }
        files_out:;
            ScanStatus *scanStatus =[ScanStatus shareInstance];
            [_condition lock];
            if (scanStatus.isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_quitFlag) {
                break;
            }
        }
        
        // report operation status to user
        switch (excute) {
            case EXCUTE_CLOUD: {
                if (self.restoreFlags & FLAG_CLOUD_ENABLE) {
                    if (operation_ok) {
//                        [_logHandle writeInfoLog:@"Cloud backup has been enabled successfully."];
                    } else {
//                        [_logHandle writeInfoLog:@"Could not enable cloud backup."];
                    }
                } else if (self.restoreFlags & FLAG_CLOUD_DISABLE) {
                    if (operation_ok) {
//                        [_logHandle writeInfoLog:@"Cloud backup has been disabled successfully."];
                    } else {
//                        [_logHandle writeInfoLog:@"Could not disable cloud backup."];
                    }
                }
                break;
            }
            case EXCUTE_BACKUP: {
//                [_logHandle writeInfoLog:[NSString stringWithFormat:@"Received %d files from device.", file_count]];
                if (operation_ok && [self mb2_status_check_snapshot_state:backupPath withUDID:_targetUUID withMatches:@"finished"]) {
//                    [_logHandle writeInfoLog:@"Backup Successful."];
                } else {
                    if (self.quitFlag) {
//                        [_logHandle writeInfoLog:@"Backup Aborted."];
                    } else {
//                        [_logHandle writeInfoLog:[NSString stringWithFormat:@"Backup Failed (Error Code %d).", -errcode]];
                        if (errcode != 0 || errdesc != NULL) {
//                            [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROEID:%d ; %s", errcode, errdesc]];
                            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding], @"errorReason", [NSNumber numberWithInt:errcode], @"errorId", nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
                            return NO;
                        }
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_COMPLETE object:nil userInfo:nil];
                break;
            }
            case EXCUTE_RESTORE: {
                if (operation_ok) {
                    if (self.restoreFlags & FLAG_RESTORE_REBOOT) {
//                        [_logHandle writeInfoLog:@"The device should reboot now."];
                    }
//                    [_logHandle writeInfoLog:@"Restore Successful."];
                } else {
//                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"Restore Failed (Error Code %d).", -errcode]];
                    if (errcode != 0 || errdesc != NULL) {
                        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding], @"errorReason", [NSNumber numberWithInt:errcode], @"errorId", nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
                        return NO;
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_COMPLETE object:nil userInfo:nil];
                break;
            }
            case EXCUTE_LEAVE:
            default: {
                if (self.quitFlag) {
//                    [_logHandle writeInfoLog:@"Operation Aborted."];
                } else if (excute == EXCUTE_LEAVE) {
//                    [_logHandle writeInfoLog:@"Operation Failed."];
                } else {
//                    [_logHandle writeInfoLog:@"Operation Successful."];
                }
                break;
            }
        }
        
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_COMPLETE object:[NSNumber numberWithBool:YES] userInfo:nil];
    }
    return YES;
}

- (BOOL)send_dlmsg_to_device:(id)message {
    if (!message) {
        return NO;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"DLMessageProcessMessage"];
    [array addObject:message];
    BOOL ret = [self sendXMLRequest:array];
    NSLog(@"sendData: %@", array);
    [array release];
    array = nil;
    return ret;
}

- (NSString*)getMessage:(NSArray*)dlMessage {
    NSString *retMsg = nil;
    if (dlMessage.count < 1) {
        return retMsg;
    }
    NSString *cmdStr = nil;
    id cmdObj = [dlMessage objectAtIndex:0];
    if (cmdObj != nil && [cmdObj isKindOfClass:[NSString class]]) {
        cmdStr = (NSString*)cmdObj;
    }
    
    if (![NSString isNilOrEmpty:cmdStr] && [cmdStr hasPrefix:@"DL"]) {
        retMsg = cmdStr;
    }
    return retMsg;
}

- (id)receive_process_message {
    id recObj = [self readXMLReply];
    if (recObj == nil || ![recObj isKindOfClass:[NSArray class]]) {
        return nil;
    }
    id retMsg = nil;
    NSArray *pmsg = (NSArray*)recObj;
    NSString *msg = [self getMessage:pmsg];
    if ([NSString isNilOrEmpty:msg] || ![msg isEqualToString:@"DLMessageProcessMessage"]) {
//        [_logHandle writeInfoLog:@"Did not receive DLMessageProcessMessage as expected!"];
        return nil;
    }
    
    if (pmsg.count != 2) {
//        [_logHandle writeInfoLog:@"Malformed plist received for DLMessageProcessMessage."];
        return nil;
    }
    
    retMsg = [pmsg objectAtIndex:1];
    return retMsg;
    
}

- (BOOL)info_is_current_device:(NSDictionary*)info_plist {
    BOOL ret = NO;
    NSString *udid = _device.udid;
    NSString *serialNumber = _device.serialNumber;
    NSString *productVersion = _device.productVersion;
    
    NSString *tmpValue = nil;
    NSArray *allkey = info_plist.allKeys;
    if ([allkey containsObject:@"Target Identifier"]) {
        tmpValue = [info_plist objectForKey:@"Target Identifier"];
    } else {
        tmpValue = nil;
    }
    if ([tmpValue isEqualToString:udid]) {
        ret = YES;
    } else {
        ret = NO;
    }
    
    if (ret) {
        if ([allkey containsObject:@"Serial Number"]) {
            tmpValue = [info_plist objectForKey:@"Serial Number"];
        } else {
            tmpValue = nil;
        }
        if ([tmpValue isEqualToString:serialNumber]) {
            ret = YES;
        } else {
            ret = NO;
        }
    }
    
    if (ret) {
        if ([allkey containsObject:@"Product Version"]) {
            tmpValue = [info_plist objectForKey:@"Product Version"];
        } else {
            tmpValue = nil;
        }
        if ([tmpValue isEqualToString:productVersion]) {
            ret = YES;
        } else {
            ret = NO;
        }
    }
    
    return ret;
}

- (BOOL)mobilebackup_delete_backup_file_by_hash:(NSString*)hash withBackupDir:(NSString*)backupDir {
    BOOL ret = NO;
    NSString *path = [[backupDir stringByAppendingPathComponent:hash] stringByAppendingPathExtension:@"mddata"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        if ([fm removeItemAtPath:path error:nil]) {
            ret = YES;
        } else {
            ret = NO;
        }
    }
    if (!ret) {
        return ret;
    }
    path = [[backupDir stringByAppendingPathComponent:hash] stringByAppendingPathExtension:@"mdinfo"];
    if ([fm fileExistsAtPath:path]) {
        if ([fm removeItemAtPath:path error:nil]) {
            ret = YES;
        } else {
            ret = NO;
        }
    }
    return ret;
}

- (BOOL)mobilebackup_check_file_integrity:(NSString*)backup_dir withFileName:(NSString*)file_name withFileData:(NSDictionary*)file_data {
    NSString *dataPath = nil;
    NSString *infoPath = nil;
    NSDictionary *mdinfo = nil;
    if (file_data == nil || file_data.allKeys.count == 0) {
        return NO;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    dataPath = [[backup_dir stringByAppendingPathComponent:file_name] stringByAppendingPathExtension:@"mddata"];
    if (![fm fileExistsAtPath:dataPath]) {
        return NO;
    }
    infoPath = [[backup_dir stringByAppendingPathComponent:file_name] stringByAppendingPathExtension:@"mdinfo"];
    mdinfo = [NSDictionary dictionaryWithContentsOfFile:infoPath];
    if (mdinfo == nil) {
        NSLog(@"ERROR: '%@.mdinfo' is missing or corrupted!", file_name);
        return NO;
    }
    
    id nodeObj = nil;
    if ([file_data.allKeys containsObject:@"DataHash"]) {
        nodeObj = [file_data objectForKey:@"DataHash"];
        if (nodeObj == nil || ![nodeObj isKindOfClass:[NSData class]]) {
            NSLog(@"ERROR: Could not get DataHash for file entry '%@'!", file_name);
            return NO;
        }
    }
    
    if ([file_data.allKeys containsObject:@"Metadata"]) {
        nodeObj = [file_data objectForKey:@"Metadata"];
        if (nodeObj == nil || ![nodeObj isKindOfClass:[NSData class]]) {
            NSLog(@"ERROR: Could not find Metadata in plist '%@.mdinfo'!", file_name);
            return NO;
        }
    }
    
    NSData *metaData = (NSData*)nodeObj;
    NSDictionary *metaDict = [NSDictionary dictionaryFromData:metaData];
    if (metaDict == nil && metaDict.allKeys.count > 0) {
        NSLog(@"ERROR: Could not get Metadata from plist '%@.mdinfo'!", file_name);
        return NO;
    }
    NSString *version = nil;
    NSString *destpath = nil;
    BOOL greylist = NO;
    NSString *domain = nil;
    NSArray *mdAllKeys = metaDict.allKeys;
    if ([mdAllKeys containsObject:@"Version"]) {
        version = (NSString*)[metaDict objectForKey:@"Version"];
    }
    if ([mdAllKeys containsObject:@"Path"]) {
        destpath = (NSString*)[metaDict objectForKey:@"Path"];
    }
    if ([mdAllKeys containsObject:@"Greylist"]) {
        greylist = [[metaDict objectForKey:@"Greylist"] boolValue];
    }
    if ([mdAllKeys containsObject:@"Domain"]) {
        domain = (NSString*)[metaDict objectForKey:@"Domain"];
    }
    NSString *fnstr = [[domain stringByAppendingString:@"-"] stringByAppendingString:destpath];
    NSData *fnhash = [fnstr sha1];
    NSString *fnamehash = [fnhash dataToHex];
    if (![fnamehash isEqualToString:file_name]) {
        NSLog(@"WARNING: filename hash does not match for entry '%@'", file_name);
    }
    NSString *auth_version = nil;
    NSArray *miAllKeys = mdinfo.allKeys;
    if (miAllKeys != nil && [miAllKeys containsObject:@"AuthVersion"]) {
        auth_version = (NSString*)[mdinfo objectForKey:@"AuthVersion"];
    }
    if ([NSString isNilOrEmpty:auth_version] || [auth_version isEqualToString:@"1.0"]) {
        NSLog(@"WARNING: Unknown AuthVersion '%@', DataHash cannot be verified!", auth_version);
    }
    
    BOOL ret = YES;
    BOOL hash_ok = NO;
    NSData *dataHash = nil;
    if ([file_data.allKeys containsObject:@"DataHash"]) {
        id tmpObj = [file_data objectForKey:@"DataHash"];
        if (tmpObj != nil && [tmpObj isKindOfClass:[NSData class]]) {
            dataHash = (NSData*)tmpObj;
            NSLog(@"WARNING: Could not get DataHash key from file info data for entry '%@'!", file_name);
        }
    }
    NSData *fileHash = nil;
    if (dataHash != nil && dataHash.length == 20) {
        fileHash = [self compute_datahash:dataPath withDestPath:destpath withGreylist:greylist withDomain:domain withAppID:nil withVersion:version];
        hash_ok = [dataHash bytesEqual:fileHash];
    } else if (dataHash != nil && dataHash.length == 0) {
        hash_ok = YES;
    }
    
    if (!hash_ok) {
        NSLog(@"ERROR: The hash for '%@.mddata' does not match DataHash entry in Manifest", file_name);
        NSLog(@"datahash: %@", [dataHash dataToHex]);
        NSLog(@"filehash: %@", [fileHash dataToHex]);
        ret = NO;
    }
    return ret;
}

- (void)info_plist_new:(NSString*)filePath withAFCDirectory:(AFCMediaDirectory*)afcDirectory {
    NSMutableDictionary *infoPlist = [[NSMutableDictionary alloc] init];
    // 获取设备的基本的属性值
    NSString *buildVersion = [_device deviceValueForKey:@"BuildVersion"];
    if (buildVersion != nil && ![buildVersion isEqualToString:@""] ) {
        [infoPlist setValue:buildVersion forKey:@"Build Version"];
    }
    NSString *deviceName = [_device deviceName];
    if (deviceName != nil && ![deviceName isEqualToString:@""] ) {
        [infoPlist setValue:deviceName forKey:@"Device Name"];
        [infoPlist setValue:deviceName forKey:@"Display Name"];
    }
    // guid 是随机生成
    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
    NSString *guid = [(NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref) stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (guid != nil && ![guid isEqualToString:@""] ) {
        [infoPlist setValue:guid forKey:@"GUID"];
    }
    /*NSString *udid = [deviceHandle deviceValueForKey:@"UniqueDeviceID"];
     NSLog(@"udid is %@", udid);*/
    NSString *ICCID = [_device deviceValueForKey:@"IntegratedCircuitCardIdentity"];
    if (ICCID != nil && ![ICCID isEqualToString:@""] ) {
        [infoPlist setValue:ICCID forKey:@"ICCID"];
    }
    NSString *IMEI = [_device deviceValueForKey:@"InternationalMobileEquipmentIdentity"];
    if (IMEI != nil && ![IMEI isEqualToString:@""] ) {
        [infoPlist setValue:IMEI forKey:@"IMEI"];
    }
    NSMutableArray *installappArray = [[NSMutableArray alloc] init];
    NSArray *appArray = [_device installedApplications];
    for (AMApplication *item in appArray) {
        [installappArray addObject:[item bundleid]];
    }
    if (appArray != nil && [appArray count] > 0) {
        [infoPlist setObject:installappArray forKey:@"Installed Applications"];
    }
    [installappArray release];
    NSDate *nowdate = [NSDate date];
    [infoPlist setObject:nowdate forKey:@"Last Backup Date"];
    NSString *phoneNumber = [_device deviceValueForKey:@"PhoneNumber"];
    if (phoneNumber != nil && ![phoneNumber isEqualToString:@""] ) {
        [infoPlist setValue:phoneNumber forKey:@"Phone Number"];
    }
//    NSString *phonerescueVersion = [[IMBSoftwareInfo singleton] productVersion];
//    [infoPlist setValue:phonerescueVersion forKey:@"PhoneRescue Version"];
    NSString *productType = [_device deviceValueForKey:@"ProductType"];
    if (productType != nil && ![productType isEqualToString:@""] ) {
        [infoPlist setValue:productType forKey:@"Product Type"];
    }
    NSString *productVersion = [_device deviceValueForKey:@"ProductVersion"];
    if (productVersion != nil && ![productVersion isEqualToString:@""] ) {
        [infoPlist setValue:productVersion forKey:@"Product Version"];
    }
    NSString *serialNumber = [_device deviceValueForKey:@"SerialNumber"];
    if (serialNumber != nil && ![serialNumber isEqualToString:@""] ) {
        [infoPlist setValue:serialNumber forKey:@"Serial Number"];
    }
    NSString *targetIdentifier = [_device deviceValueForKey:@"UniqueDeviceID"];
    if (targetIdentifier != nil && ![targetIdentifier isEqualToString:@""] ) {
        [infoPlist setValue:targetIdentifier forKey:@"Target Identifier"];
    }
    NSString *targetType = @"Device";
    [infoPlist setValue:targetType forKey:@"Target Type"];
    NSString *uniqueIdentifier = [targetIdentifier uppercaseString];
    if (uniqueIdentifier != nil && ![uniqueIdentifier isEqualToString:@""] ) {
        [infoPlist setValue:uniqueIdentifier forKey:@"Unique Identifier"];
    }
    
    // 读取设备中文件的
    AFCFileReference *fileHandle = nil;
    const uint32_t bufsz = 10240;
    char *buff = (char*)malloc(bufsz);
    uint32_t done = 0;
    
    NSMutableData *fileData = nil;
    if ([afcDirectory fileExistsAtPath:@"/Books/iBooksData.plist"]) {
        fileHandle = [afcDirectory openForRead:@"/Books/iBooksData.plist"];
        
        fileData = [[NSMutableData alloc] init];
        while (1) {
            memset(buff, 0, bufsz);
            afc_long n = [fileHandle readN:bufsz bytes:buff];
            if (n==0) break;
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [fileData appendData:b2];
            [b2 release];
            done += n;
        }
        [fileHandle closeFile];
        [infoPlist setObject:fileData forKey:@"iBooks Data"];
        [fileData release];
    }
    
    if ([afcDirectory fileExistsAtPath:@"/Books/iBooksData2.plist"]) {
        fileHandle = [afcDirectory openForRead:@"/Books/iBooksData2.plist"];
        
        fileData = [[NSMutableData alloc] init];
        while (1) {
            memset(buff, 0, bufsz);
            afc_long n = [fileHandle readN:bufsz bytes:buff];
            if (n==0) break;
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [fileData appendData:b2];
            [b2 release];
            done += n;
        }
        [fileHandle closeFile];
        [infoPlist setObject:fileData forKey:@"iBooks Data 2"];
        [fileData release];
    }
    
    if ([afcDirectory fileExistsAtPath:@"/Books/iBooksData3.plist"]) {
        fileHandle = [afcDirectory openForRead:@"/Books/iBooksData3.plist"];
        
        fileData = [[NSMutableData alloc] init];
        while (1) {
            memset(buff, 0, bufsz);
            afc_long n = [fileHandle readN:bufsz bytes:buff];
            if (n==0) break;
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [fileData appendData:b2];
            [b2 release];
            done += n;
        }
        [fileHandle closeFile];
        [infoPlist setObject:fileData forKey:@"iBooks Data 3"];
        [fileData release];
    }
    
    // 读取iTunesFile里面的数据
    NSArray *itunesFiles = [NSArray arrayWithObjects:@"ApertureAlbumPrefs", @"IC-Info.sidb", @"IC-Info.sidv", @"PhotosFolderAlbums", @"PhotosFolderName", @"PhotosFolderPrefs", @"iPhotoAlbumPrefs", @"iTunesApplicationIDs", @"iTunesPrefs", @"iTunesPrefs.plist", nil];
    
    NSString *tempFilePath;
    NSMutableDictionary *itunesFileDic = [[NSMutableDictionary alloc] init];
    for (int i =  0; i < [itunesFiles count]; i++) {
        tempFilePath = [NSString stringWithFormat:@"/iTunes_Control/iTunes/%@", [itunesFiles objectAtIndex:i]];
        
        if ([afcDirectory fileExistsAtPath:tempFilePath]) {
            fileData = [[NSMutableData alloc] init];
            fileHandle = [afcDirectory openForRead:tempFilePath];
            
            while (1) {
                memset(buff, 0, bufsz);
                afc_long n = [fileHandle readN:bufsz bytes:buff];
                if (n==0) break;
                NSData *b2 = [[NSData alloc]
                              initWithBytesNoCopy:buff length:n freeWhenDone:NO];
                [fileData appendData:b2];
                [b2 release];
                done += n;
            }
            [fileHandle closeFile];
            [itunesFileDic setObject:fileData forKey:(NSString*)[itunesFiles objectAtIndex:i]];
            [fileData release];
        }
    }
    if (itunesFileDic != nil && [[itunesFileDic allKeys] count] > 0) {
        [infoPlist setObject:itunesFileDic forKey:@"iTunes Files"];
    }
    [itunesFileDic release];
    itunesFileDic = nil;
    
    NSString * itunesSettings = [_device deviceValueForKey:nil inDomain:@"com.apple.iTunes"];
    [infoPlist setValue:itunesSettings forKey:@"iTunes Settings"];
    NSString *itunesInfoFilePath = @"/Applications/iTunes.app/Contents/Info.plist";
    NSDictionary *itunesInfoDic = [NSDictionary dictionaryWithContentsOfFile:itunesInfoFilePath];
    NSArray *allKey = [itunesInfoDic allKeys];
    if ([allKey containsObject:@"CFBundleVersion"]) {
        [infoPlist setValue:[itunesInfoDic valueForKey:@"CFBundleVersion"] forKey:@"iTunes Version"];
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
    [infoPlist writeToFile:filePath atomically:YES];
    [infoPlist release];
    infoPlist = nil;
}

- (void)status_plist_new:(NSString*)filePath withIsFullBackup:(BOOL)isFullBackup {
    NSString *statusplist = filePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:statusplist]) {
        [fm removeItemAtPath:statusplist error:nil];
    }
    NSMutableDictionary *stDict = [[NSMutableDictionary alloc] init];
    [stDict setObject:[NSString generateGUID] forKey:@"UUID"];
    [stDict setObject:[NSNumber numberWithBool:(isFullBackup ? YES : NO)] forKey:@"IsFullBackup"];
    [stDict setObject:@"2.4" forKey:@"Version"];
    [stDict setObject:@"new" forKey:@"BackupState"];
    [stDict setObject:[NSDate date] forKey:@"Date"];
    [stDict setObject:@"finished" forKey:@"SnapshotState"];
    [stDict writeToFile:statusplist atomically:YES];
    [stDict release];
    stDict = nil;
    
}

- (void)status_plist_write:(NSString*)backup_dir withStatus:(BOOL)status {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *status_path = [[backup_dir stringByAppendingPathComponent:@"Status"] stringByAppendingPathExtension:@"plist"];
    if ([fm fileExistsAtPath:status_path]) {
        [fm removeItemAtPath:status_path error:nil];
    }
    
    NSDictionary *status_plist = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:status], @"Backup Success", nil];
    [status_plist writeToFile:status_path atomically:YES];
}

- (BOOL)status_plist_read:(NSString*)backupPath {
    BOOL ret = NO;
    NSString *file_path = [[backupPath stringByAppendingPathComponent:@"Status"] stringByAppendingPathExtension:@"plist"];
    NSDictionary *status_dict = [NSDictionary dictionaryWithContentsOfFile:file_path];
    if (status_dict == nil) {
        NSLog(@"Could not read Status.plist!");
        return NO;
    }
    if ([status_dict.allKeys containsObject:@"Backup Success"]) {
        ret = [[status_dict objectForKey:@"Backup Success"] boolValue];
    } else {
        NSLog(@"status_plist_read: ERROR could not get Backup Success key from Status.plist!");
    }
    return ret;
}

- (id)mobilebackup_receive {
    id msgObj = [self readXMLReply];
    return msgObj;
}

- (BOOL)mobilebackup_send:(id)message {
    BOOL ret = NO;
    if (message != nil) {
        ret = [self sendXMLRequest:message];
    }
    return ret;
}

- (BOOL)mobilebackup_send_message:(NSString*)message withOptions:(NSDictionary*)options {
    if (message == nil && options == nil)
        return NO;
    
    if (options != nil && [options isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    BOOL ret = NO;
    
    if (message != nil) {
        NSMutableDictionary *dict = nil;
        if (options != nil) {
            dict = [options mutableDeepCopy];
        } else {
            dict = [[NSMutableDictionary alloc] init];
        }
        [dict setObject:message forKey:@"BackupMessageTypeKey"];
        ret = [self send_dlmsg_to_device:dict];
        [dict release];
        dict = nil;
    } else {
        ret = [self send_dlmsg_to_device:options];
    }
    if (!ret) {
        NSLog(@"ERROR: Could not send message %@ (%d)!", message, ret);
    }
    return ret;
}

- (BOOL)mobilebackup_receive_message:(NSString*)message withReslut:(NSDictionary*)result {
    if (message == nil)
        return NO;
    BOOL ret = NO;
    NSDictionary *dic = nil;
    id readObj = [self readXMLReply];
    if ([readObj isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary*)readObj;
    }
    
    if (dic != nil) {
        NSArray *allkeys = dic.allKeys;
        if (allkeys != nil && allkeys.count > 0) {
            if ([allkeys containsObject:@"BackupMessageTypeKey"]) {
                NSString *str = (NSString*)[dic objectForKey:@"BackupMessageTypeKey"];
                if (str != nil && [str isEqualToString:message]) {
                    ret = YES;
                }
            }
        }
    }
    if (ret) {
        result = dic;
    }
    return ret;
}

- (BOOL)mobilebackup_request_backup:(NSDictionary*)backup_manifest withBasePath:(NSString*)base_path withProtoVersion:(NSString*)proto_version {
    if ([NSString isNilOrEmpty:base_path] || [NSString isNilOrEmpty:proto_version]) {
        return NO;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (backup_manifest != nil) {
        [dic setObject:backup_manifest forKey:@"BackupManifestKey"];
    }
    [dic setObject:base_path forKey:@"BackupComputerBasePathKey"];
    [dic setObject:@"BackupMessageBackupRequest" forKey:@"BackupMessageTypeKey"];
    [dic setObject:proto_version forKey:@"BackupProtocolVersion"];
    
    BOOL ret = NO;
    NSMutableDictionary *msgDic = nil;
    if ([self mobilebackup_send_message:nil withOptions:dic]) {
        [dic release];
        dic = nil;
        if ([self mobilebackup_receive_message:@"BackupMessageBackupReplyOK" withReslut:msgDic]) {
            if (msgDic != nil && [msgDic.allKeys containsObject:@"BackupProtocolVersion"]) {
                NSString *str = (NSString*)[msgDic objectForKey:@"BackupProtocolVersion"];
                if (![NSString isNilOrEmpty:str] && [str isEqualToString:proto_version]) {
                    if ([self mobilebackup_send_message:nil withOptions:msgDic]) {
                        ret = YES;
                    }
                }
            }
        }
    }
    return ret;
}

- (BOOL)mobilebackup_send_backup_file_received {
    return [self mobilebackup_send_message:@"kBackupMessageBackupFileReceived" withOptions:nil];
}

- (BOOL)mobilebackup_request_restore:(NSDictionary*)backup_manifest withMobileBackupFlags:(int)flags withProtoVersion:(NSString*)proto_version {
    if (backup_manifest == nil || [NSString isNilOrEmpty:proto_version]) {
        return NO;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    // construct request plist
    [dic setObject:backup_manifest forKey:@"BackupManifestKey"];
    [dic setObject:@"kBackupMessageRestoreRequest" forKey:@"BackupMessageTypeKey"];
    [dic setObject:proto_version forKey:@"BackupProtocolVersion"];
    // add flags
    [dic setObject:[NSNumber numberWithBool:(flags & MB_RESTORE_NOTIFY_SPRINGBOARD)] forKey:@"BackupNotifySpringBoard"];
    [dic setObject:[NSNumber numberWithBool:(flags & MB_RESTORE_PRESERVE_SETTINGS)] forKey:@"BackupPreserveSettings"];
    [dic setObject:[NSNumber numberWithBool:(flags & MB_RESTORE_PRESERVE_CAMERA_ROLL)] forKey:@"BackupPreserveCameraRoll"];
    // send reques
    BOOL ret = NO;
    NSMutableDictionary *msgDic = nil;
    if ([self mobilebackup_send_message:nil withOptions:dic]) {
        [dic release];
        dic = nil;
        if ([self mobilebackup_receive_message:@"BackupMessageRestoreReplyOK" withReslut:msgDic]) {
            if (msgDic != nil && [msgDic.allKeys containsObject:@"BackupProtocolVersion"]) {
                NSString *str = (NSString*)[msgDic objectForKey:@"BackupProtocolVersion"];
                if (![NSString isNilOrEmpty:str] && [str isEqualToString:proto_version]) {
                    if ([self mobilebackup_send_message:nil withOptions:msgDic]) {
                        ret = YES;
                    }
                }
            }
        }
    }
    return ret;
}

- (NSDictionary*)mobilebackup_receive_restore_file_received {
    NSDictionary *outputResult = nil;
    if ([self mobilebackup_receive_message:@"BackupMessageRestoreFileReceived" withReslut:outputResult]) {
        return outputResult;
    } else {
        return nil;
    }
}

- (NSDictionary*)mobilebackup_receive_restore_application_received {
    NSDictionary *outputResult = nil;
    if ([self mobilebackup_receive_message:@"BackupMessageRestoreApplicationReceived" withReslut:outputResult]) {
        return outputResult;
    } else {
        return nil;
    }
}

- (BOOL)mobilebackup_send_restore_complete {
    BOOL ret = NO;
    ret = [self mobilebackup_send_message:@"BackupMessageRestoreComplete" withOptions:nil];
    if (!ret) {
        return NO;
    }
    
    NSArray *dlmsg = nil;
    id msgObj = [self mobilebackup_receive];
    if (msgObj == nil || ![msgObj isKindOfClass:[NSArray class]] || [(NSArray*)msgObj count] == 2) {
        if (msgObj) {
            NSLog(@"ERROR: Did not receive DLMessageDisconnect.");
        }
        if (msgObj != nil) {
            NSLog(@"ERROR: Error plist.");
        }
        return NO;
    }
    id obj = [dlmsg objectAtIndex:0];
    NSString *msg = nil;
    if (obj != nil && [obj isKindOfClass:[NSString class]]) {
        msg = (NSString*)obj;
    }
    
    if ([NSString isNilOrEmpty:msg] && [msg isEqualToString:@"DLMessageDisconnect"]) {
        ret = YES;
    } else {
        NSLog(@"ERROR: Malformed plist received:");
        ret = NO;
    }
    return ret;
}

- (BOOL)mobilebackup_send_error:(NSString*)reason {
    if ([NSString isNilOrEmpty:reason]) {
        return NO;
    }
    BOOL ret = NO;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:reason, @"BackupErrorReasonKey", nil];
    ret = [self mobilebackup_send_message:@"BackupMessageError" withOptions:dict];
    return ret;
}

- (NSData*)compute_datahash:(NSString*)path withDestPath:(NSString*)dest_path withGreylist:(BOOL)greylist withDomain:(NSString*)domain withAppID:(NSString*)appid withVersion:(NSString*)version {
    NSData *retData = nil;
    CC_SHA1_CTX sha1;
    CC_SHA1_Init(&sha1);
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        return nil;
    }
    
    NSFileHandle *fHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (fHandle != nil) {
        int bufferLen = 16384;
        while (YES) {
            @autoreleasepool {
                NSData *buf = [fHandle readDataOfLength:bufferLen];
                uint32_t n = (uint32_t)buf.length;
                if (n == 0) {
                    break;
                }
                CC_SHA1_Update(&sha1, buf.bytes, n);
            }
        }
        [fHandle closeFile];
        NSData *tmpData = [dest_path dataUsingEncoding:NSASCIIStringEncoding];
        CC_SHA1_Update(&sha1, tmpData.bytes, (CC_LONG)tmpData.length);
        tmpData = [@";" dataUsingEncoding:NSASCIIStringEncoding];
        CC_SHA1_Update(&sha1, tmpData.bytes, (CC_LONG)tmpData.length);
        if (greylist) {
            tmpData = [@"true" dataUsingEncoding:NSASCIIStringEncoding];
        } else {
            tmpData = [@"false" dataUsingEncoding:NSASCIIStringEncoding];
        }
        
        CC_SHA1_Update(&sha1, tmpData.bytes, (CC_LONG)tmpData.length);
        
        tmpData = [@";" dataUsingEncoding:NSASCIIStringEncoding];
        
        CC_SHA1_Update(&sha1, tmpData.bytes, (CC_LONG)tmpData.length);
        
        if (![NSString isNilOrEmpty:domain]) {
            
            tmpData = [domain dataUsingEncoding:NSASCIIStringEncoding];
            
        } else {
            
            tmpData = [@"(null)" dataUsingEncoding:NSASCIIStringEncoding];
            
        }
        
        CC_SHA1_Update(&sha1, tmpData.bytes, (CC_LONG)tmpData.length);
        
        tmpData = [@";" dataUsingEncoding:NSASCIIStringEncoding];
        
        CC_SHA1_Update(&sha1, tmpData.bytes, (CC_LONG)tmpData.length);
        
        if (![NSString isNilOrEmpty:appid]) {
            
            tmpData = [appid dataUsingEncoding:NSASCIIStringEncoding];
            
        } else {
            
            tmpData = [@"(null)" dataUsingEncoding:NSASCIIStringEncoding];
            
        }
        
        CC_SHA1_Update(&sha1, tmpData.bytes, (CC_LONG)tmpData.length);
        
        tmpData = [@";" dataUsingEncoding:NSASCIIStringEncoding];
        
        CC_SHA1_Update(&sha1, tmpData.bytes, (CC_LONG)tmpData.length);
        
        if (![NSString isNilOrEmpty:version]) {
            
            tmpData = [version dataUsingEncoding:NSASCIIStringEncoding];
            
        } else {
            
            tmpData = [@"(null)" dataUsingEncoding:NSASCIIStringEncoding];
            
        }
        
        CC_SHA1_Update(&sha1, tmpData.bytes, (CC_LONG)tmpData.length);
        
        uint8_t hash[20] = { 0x00 };
        
        CC_SHA1_Final(hash, &sha1);
        
        retData = [NSData dataWithBytes:hash length:CC_SHA1_DIGEST_LENGTH];
        
    }
    
    return nil;
    
}

- (BOOL)mobilebackup2_version_exchange:(NSArray*)local_versions withRemoteVersion:(double*)remote_version {
    BOOL ret = NO;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:local_versions forKey:@"SupportedProtocolVersions"];
    if (![self mobilebackup2_send_message:@"Hello" withOptions:dict]) {
        [dict release];
        dict = nil;
        ret = NO;
    } else {
        [dict release];
        dict = nil;
        ret = YES;
    }
    if (!ret) {
        *remote_version = 0.0;
        return ret;
    }
    
    NSDictionary *respDict = [self internal_mobilebackup2_receive_message:@"Response"];
    if (respDict) {
        // heck if we received an error
        uint64_t val = 0;
        if ([respDict.allKeys containsObject:@"ErrorCode"]) {
            val = [[respDict objectForKey:@"ErrorCode"] unsignedLongLongValue];
        }
        if (val != 0) {
//            if (val == 1) {
//                [_logHandle writeInfoLog:@"ERROR: no common version"];
//            } else {
//                [_logHandle writeInfoLog:@"ERROR: reply not ok."];
//            }
            ret = NO;
        } else {
            ret = YES;
        }
        if (ret) {
            if ([respDict.allKeys containsObject:@"ProtocolVersion"]) {
                double tmpVal = [[respDict objectForKey:@"ProtocolVersion"] doubleValue];
                *remote_version = tmpVal;
            } else {
                *remote_version = 0.0;
                ret = NO;
            }
        }
    } else {
        ret = NO;
    }
    return ret;
}

- (NSDictionary*)internal_mobilebackup2_receive_message:(NSString*)message {
    if ([NSString isNilOrEmpty:message]) {
        return nil;
    }
    NSDictionary *result = nil;
    
    // receive DLMessageProcessMessage
    NSDictionary *dict = nil;
    id retMsg = [self receive_process_message];
    if (retMsg != nil && [retMsg isKindOfClass:[NSDictionary class]]) {
        dict = (NSDictionary*)retMsg;
    } else {
        return nil;
    }
    
    NSString *str = nil;
    if ([dict.allKeys containsObject:@"MessageName"]) {
        str = (NSString*)[dict objectForKey:@"MessageName"];
    }
    
    if (![NSString isNilOrEmpty:str] && [str isEqualToString:message]) {
        result = dict;
    } else {
//        [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROR: MessageName value does not match '%@'!", message]];
        result = nil;
    }
    return result;
}

- (BOOL)mobilebackup2_send_request:(NSString*)request withTarUDID:(NSString*)targetUDID withSourUDID:(NSString*)sourceUDID withOptions:(NSDictionary*)options {
    if ([NSString isNilOrEmpty:request] || [NSString isNilOrEmpty:targetUDID]) {
        return NO;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:targetUDID forKey:@"TargetIdentifier"];
    if (![NSString isNilOrEmpty:sourceUDID]) {
        [dict setObject:sourceUDID forKey:@"SourceIdentifier"];
    }
    if (options != nil) {
        [dict setObject:options forKey:@"Options"];
    }
    if ([request isEqualToString:@"Unback"] && options != nil) {
        if ([options.allKeys containsObject:@"Password"]) {
            id node = [options objectForKey:@"Password"];
            [dict setObject:node forKey:@"Password"];
        }
    }
    if ([request isEqualToString:@"EnableCloudBackup"] && options != nil) {
        if ([options.allKeys containsObject:@"CloudBackupState"]) {
            id node = [options objectForKey:@"CloudBackupState"];
            [dict setObject:node forKey:@"CloudBackupState"];
        }
    }
    BOOL ret = [self mobilebackup2_send_message:request withOptions:dict];
    [dict release];
    dict = nil;
    return ret;
}

- (BOOL)mobilebackup2_send_message:(NSString*)message withOptions:(id)options {
    if ([NSString isNilOrEmpty:message] && options == nil) {
        return NO;
    }
    
    BOOL ret = NO;
    if (![NSString isNilOrEmpty:message]) {
        NSMutableDictionary *dict = nil;
        if (options != nil) {
            dict = [options mutableDeepCopy];
        } else {
            dict = [[NSMutableDictionary alloc] init];
        }
        [dict setObject:message forKey:@"MessageName"];
        // send it as DLMessageProcessMessage
        ret = [self send_dlmsg_to_device:dict];
        [dict release];
        dict = nil;
    } else {
        ret = [self send_dlmsg_to_device:options];
    }
    return ret;
}

- (NSArray*)mobilebackup2_receive_message {
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    NSArray *message = nil;
    NSString *dlmessage = nil;
    id readObj = [self readXMLReply];
    if (readObj != nil && [readObj isKindOfClass:[NSArray class]]) {
        message = (NSArray*)readObj;
        [retArray addObject:message];
    }
    if (message != nil) {
        dlmessage = [self getMessage:message];
        if (![NSString isNilOrEmpty:dlmessage]) {
            [retArray addObject:dlmessage];
        }
    }
    return retArray;
}

- (BOOL)mobilebackup2_send_status_response:(int)statusCode withStatus1:(NSString*)status1 withStatus2:(id)status2 {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"DLMessageStatusResponse"];
    [array addObject:[NSNumber numberWithInt:statusCode]];
    if (![NSString isNilOrEmpty:status1]) {
        [array addObject:status1];
    } else {
        [array addObject:@"___EmptyParameterString___"];
    }
    if (status2) {
        [array addObject:status2];
    } else {
        [array addObject:@"___EmptyParameterString___"];
    }
    BOOL ret = [self sendXMLRequest:array];
    [array release];
    array = nil;
    return ret;
}

- (BOOL)mb2_status_check_snapshot_state:(NSString*)path withUDID:(NSString*)udid withMatches:(NSString*)matches {
    BOOL ret = NO;
    NSDictionary *statusDict = nil;
    NSString *file_path = [[path stringByAppendingPathComponent:udid] stringByAppendingPathComponent:@"Status.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file_path]) {
        statusDict = [NSDictionary dictionaryWithContentsOfFile:file_path];
        if (statusDict == nil) {
//            [_logHandle writeInfoLog:@"Could not read Status.plist!"];
            return ret;
        }
        if ([statusDict.allKeys containsObject:@"SnapshotState"]) {
            id sObj = [statusDict objectForKey:@"SnapshotState"];
            if (sObj != nil && [sObj isKindOfClass:[NSString class]]) {
                NSString *sval = (NSString*)sObj;
                if ([sval isEqualToString:matches]) {
                    ret = YES;
                }
            }
        }
    }
    return ret;
}

- (void)mb2_handle_send_files:(NSArray*)message withBackupDir:(NSString*)backupdir {
    int fileCnt = 0;
    if (message == nil || message.count < 2 || [NSString isNilOrEmpty:backupdir]) {
        return;
    }
    NSArray *files = [message objectAtIndex:1];
    if (files != nil) {
        fileCnt = (int)files.count;
    } else {
        fileCnt = 0;
    }
    NSDictionary *errorsDict = nil;
    NSMutableArray *errArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < fileCnt; i++) {
        id val = [files objectAtIndex:i];
        if (val == nil || ![val isKindOfClass:[NSString class]]) {
            continue;
        }
        NSString *str = (NSString*)val;
        if (![NSString isNilOrEmpty:str]) {
            if (![self mb2_handle_send_file:backupdir withPath:str withErrsArray:errArray]) {
                break;
            }
        }
    }
    if (errArray.count > 0) {
        errorsDict = [[errArray objectAtIndex:0] retain];
    } else {
        errorsDict = nil;
    }
    [errArray release];
    errArray = nil;
    
    // send terminating 0 dword
    uint32_t zero = 0;
    [self sendRaw:(char*)&zero withLength:4];
    if (!errorsDict) {
        NSMutableDictionary *emptydict = [[NSMutableDictionary alloc] init];
        [self mobilebackup2_send_status_response:0 withStatus1:nil withStatus2:emptydict];
        [emptydict release];
        emptydict = nil;
    } else {
//        [_logHandle writeInfoLog:[NSString stringWithFormat:@"errorsDict:%@",errorsDict]];
        [self mobilebackup2_send_status_response:-13 withStatus1:@"Multi status" withStatus2:errorsDict];
        [errorsDict release];
        errorsDict = nil;
    }
}

- (BOOL)mb2_handle_send_file:(NSString*)backupDir withPath:(NSString*)path withErrsArray:(NSMutableArray*)errsArray {
    NSString *localFile = [backupDir stringByAppendingPathComponent:path];
    uint32_t nlen = 0;
    struct stat fst;
    char buf[32768];
    
    FILE *f = NULL;
    int errcode = -1;
    __int64_t total;
    __int64_t sent;
    BOOL result = NO;
    uint32_t length;
    
    NSData *pathData = [path toDataByEncoding:NSUTF8StringEncoding];
    // send path
    uint32_t sendLen = [self sendRawData:pathData];
    if (sendLen != pathData.length) {
        goto leave_proto_err;
    }
    if (stat([localFile cStringUsingEncoding:NSUTF8StringEncoding], &fst) < 0) {
        if (errno != ENOENT) {
            [self setLastError:[NSString stringWithFormat:@"%s: stat failed on '%@': %d", __func__, localFile, errno]];
        }
        errcode = errno;
        goto leave;
    }
    
    total = (long)fst.st_size;
    if (total == 0) {
        errcode = 0;
        goto leave;
    }
    
    f = fopen([localFile cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    if (f) {
        sent = 0;
        //NSData *sendData = nil;
        while (sent < total) {
            length = ((total - sent) < (__int64_t)sizeof(buf)) ? (uint32_t)(total-sent) : (uint32_t)sizeof(buf);
            // send data size (file size + 1)
            nlen = htonl(length+1);
            memcpy(buf, &nlen, sizeof(nlen));
            buf[4] = CODE_FILE_DATA;
            int sendCnt = [self sendRaw:buf withLength:5];
            if (sendCnt != 5) {
                goto leave_proto_err;
            }
            // send file contents
            size_t r = fread(buf, 1, sizeof(buf), f);
            if (r <= 0) {
                errcode = errno;
                goto leave;
            }
            sendCnt = [self sendRaw:buf withLength:(uint32)r];
            if (sendCnt != r) {
                goto leave_proto_err;
            }
            sent += r;
        }
        fclose(f);
        f = NULL;
        errcode = 0;
    }
leave:;
    if (errcode == 0) {
        result = YES;
        nlen = 1;
        nlen = htonl(nlen);
        memcpy(buf, &nlen, 4);
        buf[4] = CODE_SUCCESS;
        [self sendRaw:buf withLength:5];
    } else {
        char *errdesc = strerror(errcode);
        NSMutableDictionary *errDict = [[NSMutableDictionary alloc] init];
        [self mb2_multi_status_add_file_error:errDict withPath:path withErrorCode:[self errno_to_device_error:errcode] withErrorMessage:[NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding]];
        [errsArray addObject:errDict];
        [errDict release];
        errDict = nil;
        length = (uint32_t)strlen(errdesc);
        nlen = htonl(length+1);
        memcpy(buf, &nlen, 4);
        buf[4] = CODE_ERROR_LOCAL;
        uint32_t slen = 5;
        memcpy(buf+slen, errdesc, length);
        slen += length;
        int sendCnt = [self sendRaw:buf withLength:slen];
//        if (sendCnt != slen) {
//            [_logHandle writeInfoLog:[NSString stringWithFormat:@"could only send %d from %d", sendCnt, slen]];
//        }
    }
leave_proto_err:;
    if (f) {
        fclose(f);
        f = NULL;
    }
    return result;
}

- (uint32_t)mb2_handle_receive_files:(NSArray*)message withBackupDir:(NSString*)backupdir {
    if (message == nil || message.count < 4 || [NSString isNilOrEmpty:backupdir]) {
        return NO;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    uint64_t backup_real_size = 0;
    uint64_t backup_total_size = 0;
    uint32_t blocksize = 0;
    uint32_t bdone;
    uint32_t rlen;
    char buf[32768];
    uint32_t nlen = 0;
    NSString *fname = nil;
    NSString *dname = nil;
    NSString *bname = nil;
    char code = 0;
    char lastCode = 0;
    uint32_t r = 0;
    uint32_t file_count = 0;
    
    id node = nil;
    node = [message objectAtIndex:3];
    if (node != nil && [node isKindOfClass:[NSNumber class]]) {
        backup_total_size = [node unsignedIntValue];
    }
    
    if (backup_total_size > 0) {
        //NSLog(@"Receiving files");
    }
    
    while (YES) {
        ScanStatus *scanStatus =[ScanStatus shareInstance];
        [_condition lock];
        if (scanStatus.isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_quitFlag) {
            break;
        }
        nlen = [self mb2_receive_filename:&dname];
        if (!nlen) {
            break;
        }
        nlen = [self mb2_receive_filename:&fname];
        if (!nlen) {
            break;
        }
        if (bname != nil) {
            bname = nil;
        }
        bname = [backupdir stringByAppendingPathComponent:fname];
        r = 0;
        nlen = 0;
        r = [self receiveRaw:(char*)&nlen withLength:sizeof(nlen)];
        if (r != 4) {
//            [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROR: %s: could not receive code length!", __func__]];
            break;
        }
        //nlen = [BigOrLittleEndian uint32ToLittleEndian:nlen];
        nlen = ntohl(nlen);
        lastCode = code;
        code = 0;
        r = [self receiveRaw:(char*)&code withLength:1];
        if (r != 1) {
//            [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROR: %s: could not receive code!", __func__]];
            break;
        }
        // TODO remove this
        if ((code != CODE_SUCCESS) && (code != CODE_FILE_DATA) && (code != CODE_ERROR_REMOTE)) {
//            [_logHandle writeInfoLog:[NSString stringWithFormat:@"Found new flag %02x", code]];
        }
        if ([fm fileExistsAtPath:bname]) {
            [fm removeItemAtPath:bname error:nil];
        }
        
        FILE *f = fopen([bname cStringUsingEncoding:NSUTF8StringEncoding], "wb");
        while (f && (code == CODE_FILE_DATA)) {
            blocksize = nlen - 1;
            bdone = 0;
            rlen = 0;
            while (bdone < blocksize) {
                if ((blocksize - bdone) < sizeof(buf)) {
                    rlen = blocksize - bdone;
                } else {
                    rlen = sizeof(buf);
                }
                r = [self receiveRaw:buf withLength:rlen];
                if ((int)r <= 0) {
                    break;
                }
                fwrite(buf, 1, r, f);
                bdone += r;
            }
            if (bdone == blocksize) {
                backup_real_size += blocksize;
            }
            if (backup_total_size > 0) {
                //NSLog(@"backup real size is %lld, backup total size is %lld", backup_real_size, backup_total_size);
            }
            [_condition lock];
            if (scanStatus.isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_quitFlag) {
                break;
            }
            nlen = 0;
            r = [self receiveRaw:(char*)&nlen withLength:sizeof(nlen)];
            nlen = ntohl(nlen);
            if (nlen > 0) {
                lastCode = code;
                r = [self receiveRaw:(char*)&code withLength:1];
            } else {
                break;
            }
        }
        if (f) {
            fclose(f);
            file_count++;
        } else {
//            [_logHandle writeInfoLog:[NSString stringWithFormat:@"Error opening '%@' for writing: %s", bname, strerror(errno)]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithCString:strerror(errno) encoding:NSUTF8StringEncoding], @"errorReason", [NSNumber numberWithInt:-36], @"errorId", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
            _quitFlag = YES;
            return 0;
        }
        if (nlen == 0) {
            break;
        }
        
        // check if an error message was received
        if (code == CODE_ERROR_REMOTE) {
            char *msg = (char*)malloc(nlen);
            r = [self receiveRaw:msg withLength:nlen - 1];
            msg[r] = 0x00;
            // If sent using CODE_FILE_DATA, end marker will be CODE_ERROR_REMOTE which is not an error!
            if (lastCode != CODE_FILE_DATA) {
//                [_logHandle
//                 writeInfoLog:[NSString stringWithFormat:@"Received an error message from device: %s", msg]];
            }
            free(msg);
            msg = NULL;
        }
    }
    
    // if there are leftovers to read, finish up cleanly
    if ((int)nlen - 1 > 0) {
//        [_logHandle writeInfoLog:@"Discarding current data hunk."];
        char *tmpbuf = (char*)malloc(nlen-1);
        r = [self receiveRaw:tmpbuf withLength:(nlen - 1)];
        free(tmpbuf);
        if ([fm fileExistsAtPath:bname]) {
            [fm removeItemAtPath:bname error:nil];
        }
    }
    
    // TODO error handling?!
    NSMutableDictionary *emptyDict = [[NSMutableDictionary alloc] init];
    [self mobilebackup2_send_status_response:0 withStatus1:nil withStatus2:emptyDict];
    [emptyDict release];
    emptyDict = nil;
    return file_count;
}

- (uint32_t)mb2_receive_filename:(NSString**)filename {
    uint32_t nlen = 0;
    uint32_t rlen = 0;
    while (YES) {
        ScanStatus *scanStatus =[ScanStatus shareInstance];
        [_condition lock];
        if (scanStatus.isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_quitFlag) {
            break;
        }
        nlen = 0;
        rlen = 0;
        rlen = [self receiveRaw:(char*)&nlen withLength:sizeof(nlen)];
        nlen = ntohl(nlen);
        if ((nlen == 0) && (rlen == 4)) {
            return 0;
        } else if (rlen == 0) {
            continue;
        } else if (nlen > 4096) {
//            [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROR: %s: too large filename length (%d)!", __func__, nlen]];
            return 0;
        }
        
        char *buff = NULL;
        int times = 3;
        while (!buff && times) {
            buff = (char*)malloc(nlen+1);
            times--;
        }
        if (!buff) {
            return 0;
        }
        rlen = 0;
        rlen = [self receiveRaw:buff withLength:nlen];
        if (rlen != nlen) {
//            [_logHandle writeInfoLog:[NSString stringWithFormat:@"ERROR: %s: could not read filename.", __func__]];
            free(buff);
            buff = NULL;
            return 0;
        }
        buff[rlen] = 0x00;
        *filename = [NSString stringWithCString:buff encoding:NSUTF8StringEncoding];
        free(buff);
        buff = NULL;
        break;
    }
    return nlen;
}

- (void)mb2_handle_list_directory:(NSArray*)message withBackupDir:(NSString*)backupDir {
    if (message.count < 2 || [NSString isNilOrEmpty:backupDir]) {
        return;
    }
    id obj = nil;
    obj = [message objectAtIndex:1];
    NSString *str = nil;
    if (obj && [obj isKindOfClass:[NSString class]]) {
        str = (NSString*)obj;
    }
    if ([NSString isNilOrEmpty:str]) {
//        [_logHandle writeInfoLog:(@"ERROR: Malformed DLContentsOfDirectory message.")];
        // TODO error handing
        return;
    }
    NSString *path = [backupDir stringByAppendingPathComponent:str];
    NSMutableDictionary *dirDict = [[NSMutableDictionary alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray* fnArray = [fm contentsOfDirectoryAtPath:path error:nil];
    for (NSString* fileName in fnArray) {
        if ([fileName isEqualToString:@"."] || [fileName isEqualToString:@".."]) {
            continue;
        }
        NSMutableDictionary *fdict = [[NSMutableDictionary alloc] init];
        struct stat st;
        NSString* fullPath = [path stringByAppendingPathComponent:fileName];
        stat([fullPath UTF8String], &st);
        NSString *ftype = @"DLFileTypeUnknown";
        if (S_ISDIR(st.st_mode)) {
            ftype = @"DLFileTypeDirectory";
        } else if (S_ISREG(st.st_mode)) {
            ftype = @"DLFileTypeRegular";
        }
        [fdict setObject:ftype forKey:@"DLFileType"];
        [fdict setObject:[NSNumber numberWithUnsignedInt:(uint32_t)(st.st_size)] forKey:@"DLFileSize"];
        [fdict setObject:[NSNumber numberWithLong:st.st_mtime] forKey:@"DLFileModificationDate"];
        [dirDict setObject:fdict forKey:fileName];
        [fdict release];
        fdict = nil;
    }
    
    // TODO error handling
    BOOL ret = [self mobilebackup2_send_status_response:0 withStatus1:nil withStatus2:dirDict];
    [dirDict release];
    dirDict = nil;
    if (!ret) {
//        [_logHandle writeInfoLog:@"Could not send status response."];
    }
}

- (void)mb2_handle_make_directory:(NSArray*)message withBackupDir:(NSString*)backupDir {
    if (message.count < 2 || [NSString isNilOrEmpty:backupDir]) {
        return;
    }
    
    NSString *str = nil;
    int errcode = 0;
    char *errdesc = NULL;
    id obj = [message objectAtIndex:1];
    if (obj != nil && [obj isKindOfClass:[NSString class]]) {
        str = (NSString*)obj;
    }
    NSString *newPath = [backupDir stringByAppendingPathComponent:str];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err = nil;
    if ([fm createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:&err]) {
        errdesc = strerror((int)err.code);
        if (errno != EEXIST) {
            // NSLog(@"createDirectoryAtPath: %s (%d).", errdesc, errno);
        }
        errcode = [self errno_to_device_error:(int)err.code];
        //         NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding], @"errorReason", [NSNumber numberWithInt:errcode], @"errorId", nil];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
    }else {
//        [_logHandle writeInfoLog:[NSString stringWithFormat:@"err:%@",err]];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:err, @"errorReason", [NSNumber numberWithInt:-111], @"errorId", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
        return;
    }
    
    if (![self mobilebackup2_send_status_response:errcode withStatus1:[NSString stringWithCString:errdesc encoding:NSUTF8StringEncoding] withStatus2:NULL]) {
//        [_logHandle writeInfoLog:@"Could not send status response."];
    };
}

- (void)mb2_set_overall_progress_from_message:(NSArray*)message withIdentifier:(NSString*)identifier {
    double progress = 0.0;
    id obj = nil;
    if ([identifier isEqualToString:@"DLMessageDownloadFiles"]) {
        obj = [message objectAtIndex:3];
    } else if ([identifier isEqualToString:@"DLMessageUploadFiles"]) {
        obj = [message objectAtIndex:2];
    } else if ([identifier isEqualToString:@"DLMessageMoveFiles"] || [identifier isEqualToString:@"DLMessageMoveItems"]) {
        obj = [message objectAtIndex:3];
    } else if ([identifier isEqualToString:@"DLMessageRemoveFiles"] || [identifier isEqualToString:@"DLMessageRemoveItems"]) {
        obj = [message objectAtIndex:3];
    }
    
    if (obj != nil && [obj isKindOfClass:[NSNumber class]]) {
        progress = [obj doubleValue];
        if (progress > 0.0) {
            // TODU notification progress
//            [_logHandle writeInfoLog:[NSString stringWithFormat:@"progress:%f", progress]];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:progress], @"BRProgress", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_BACKUP_PROGRESS object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_RESTORE_PROGRESS object:nil userInfo:dic];
        }
    }
}

- (void)mb2_multi_status_add_file_error:(NSMutableDictionary*)status_dict withPath:(NSString*)path withErrorCode:(int)errorCode withErrorMessage:(NSString*)errorMessage {
    if (status_dict == nil) {
        return;
    }
    NSDictionary *filedict = [NSDictionary dictionaryWithObjectsAndKeys: errorMessage, @"DLFileErrorString", [NSNumber numberWithInt:errorCode], @"DLFileErrorCode", nil];
    [status_dict setObject:filedict forKey:path];
}

- (int)errno_to_device_error:(int)errno_value {
    switch (errno_value) {
        case ENOENT:
            return -6;
        case EEXIST:
            return -7;
        default:
            return -errno_value;
    }
}

@end

@implementation AMDevice
@synthesize connected = _connected;
@synthesize udid=_udid;
@synthesize deviceName=_deviceName;
@synthesize lasterror=_lasterror;
@synthesize isWifiConnection=_isWifiConnection;
@synthesize deviceClass = _deviceClass;
@synthesize productType = _productType;
@synthesize productVersion = _productVersion;
@synthesize serialNumber = _serialNumber;
@synthesize isNeedInputPassCode = _isNeedInputPassCode;
@synthesize totalDiskCapacity = _totalDiskCapacity;
@synthesize totalDataAvailable = _totalDataAvailable;
@synthesize fromiTunes = _fromiTunes;
@synthesize isValid = _isValid;
@synthesize isUnlock = _isUnlock;
@synthesize isConnected = _isConnected;

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void)clearLastError
{
	[_lasterror release];
	_lasterror = nil;
}

- (void)setIsConnected:(BOOL *)isConnected
{
    if (_isConnected == NULL) {
        BOOL *isConneted = malloc(sizeof(BOOL));
        _isConnected = isConneted;
    }
    if (*isConnected) {
        *_isConnected = YES;
    }else{
        *_isConnected = NO;
    }
}

-(BOOL *)isConnected
{
    return _isConnected;
}

- (void)setLastError:(NSString*)msg
{
	[self clearLastError];
	_lasterror = [msg retain];
}

- (bool)checkStatus:(int)ret from:(const char *)func
{
	if (ret != 0) {
        NSString *retStr = [NSString stringWithFormat:@"%x",ret];
        if ([@"e8000025" isEqualToString:retStr]) {
            _isNeedInputPassCode = TRUE;
        }
		[self setLastError:[NSString stringWithFormat:@"%s failed: %x",func,ret]];
		return NO;
	}
	[self clearLastError];
	return YES;
}

- (bool)isDevice:(am_device) d
{
	return _device == d;
}

- (void)forgetDevice
{
	_device = nil;
}

//TODO:AMDeviceStartService 失败
- (am_service)_startService:(NSString*)name isSecure:(BOOL)isSecure
{
	am_service result;
	uint32_t dummy = 0;
    mach_error_t ret = 0;
    if (isSecure) {
        if ([name isEqualToString:@"com.apple.mobilebackup2"]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"UnlockEscrowBag"];
            ret = AMDeviceSecureStartService(_device, (CFStringRef)name, dict, &result);
            [dict release];
            dict = nil;
        } else {
            ret = AMDeviceSecureStartService(_device, (CFStringRef)name, 0, &result);
        }
    } else {
        ret = AMDeviceStartService(_device,(CFStringRef)name, &result, &dummy);
    }
	if (ret == 0) return result;
//    usleep(20);
//    [self _startService:name isSecure:isSecure];
	NSLog(@"AMDeviceStartService failed: %#x,%#x,%#x", err_get_system(ret), err_get_sub(ret), err_get_code(ret));
	return 0;
}

- (int)checkDeviceConnectStatus {
//    IMBLogManager *logmanager = [IMBLogManager singleton];
    int ret = AMDeviceConnect(_device);
    if (ret != 0) {
//        [logmanager writeInfoLog:[NSString stringWithFormat:@"AMDeviceConnect Is Failed, AMDeviceConnect: %d",ret]];
        //        ret = 100000;
        return ret;
    }
    
    ret = AMDeviceIsPaired(_device);
    if (ret == 0) {
        ret = AMDevicePair(_device);
        if (ret == -402653158) {
            AMDeviceDisconnect(_device);
            _isNeedInputPassCode = TRUE;
//            [logmanager writeInfoLog:@"Need Input Passcode."];
            //                throw new IPhoneNeedInputPasscodeException();在界面上显示出来;
            return ret;
        }
        if (ret != 0) {
            ret = AMDeviceDisconnect(_device);
            return ret;
        }
    }else {
//        [logmanager writeInfoLog:[NSString stringWithFormat:@"AMDeviceIsPaired is Failed, AMDeviceIsPaired: %d",ret]];
    }
    ret = AMDeviceValidatePairing(_device);
    if (ret != 0) {
        ret = AMDeviceDisconnect(_device);
        if (ret == -402653156)
        {
            _isNeedInputPassCode = TRUE;
//            [logmanager writeInfoLog:@"Need Input Passcode."];
            //            throw new IPhoneNeedInputPasscodeException();
            return ret;
        }
//        [logmanager writeInfoLog:[NSString stringWithFormat:@"AMDeviceValidatePairing Is Failed, AMDeviceValidatePairing: %d", ret]];
        return ret;
    }
    ret = AMDeviceStartSession(_device);
    if (ret != 0)
    {
//        [logmanager writeInfoLog:[NSString stringWithFormat:@"AMDeviceStartSession Is Failed, AMDeviceStartSession: %d", ret]];
        AMDeviceStopSession(_device);
        AMDeviceDisconnect(_device);
        return ret;
    }
    
    am_service result;
	uint32_t dummy = 0;
    ret = AMDeviceStartService(_device,(CFStringRef)@"com.apple.afc", &result, &dummy);//OpenAfcStartService();
    //    AMDServiceConnectionInvalidate(result);
    if (ret != 0)
    {
//        [logmanager writeInfoLog:@"Open afc service is error."];
        if (ret == -402653158) {
            AMDeviceStopSession(_device);
            AMDeviceDisconnect(_device);
//            [logmanager writeInfoLog:@"Need Input Passcode."];
            //            throw new IPhoneNeedInputPasscodeException();
            return ret;
        }
    }
    AMDeviceStopSession(_device);
    AMDeviceDisconnect(_device);
    return ret;
}

- (BOOL)enableWifi:(BOOL)state {
    BOOL result = NO;
    if ([self deviceConnect]) {
        if ([self startSession]) {
            int wifi = 0;
            if (state) {
                wifi = 2;
            }else {
                wifi = 0;
            }
            
//            uint32_t wifiVal = 0;
            @try {
//                AMDeviceGetWirelessBuddyFlags(_device, &wifiVal);
//                if (wifiVal != 2) {
                    AMDeviceSetWirelessBuddyFlags(_device, wifi);
                    result = YES;
//                }
            }
            @catch (NSException *exception) {
                NSLog(@"set wireless failed");
            }
            [self stopSession];
        }
        [self deviceDisconnect];
    }
    return result;
}

- (BOOL)getWifiState {
    BOOL wifiState = NO;
    if ([self deviceConnect]) {
        if ([self startSession]) {
            int result = 0;
            uint32_t wifi = 0;
            result = AMDeviceGetWirelessBuddyFlags(_device, &wifi);
            if (wifi == 0 || wifi == 1) {
                wifiState = NO;
            }else {
                wifiState = YES;
            }
            [self stopSession];
        }
        [self deviceDisconnect];
    }
    return wifiState;
}

- (bool)deviceConnect
{
	if (![self checkStatus:AMDeviceConnect(_device) from:"AMDeviceConnect"]) return NO;
	_connected = YES;
	[self clearLastError];
    _fromiTunes = TRUE;
	return YES;
}

- (bool)deviceDisconnect
{
	if ([self checkStatus:AMDeviceDisconnect(_device) from:"AMDeviceDisconnect"]) {
		_connected = NO;
		return YES;
	}
	return NO;
}

- (bool)startSession
{
	if ([self checkStatus:AMDeviceStartSession(_device) from:"AMDeviceStartSession"]) {
		_insession = YES;
		return YES;
	}
	return NO;
}

- (bool)stopSession
{
	if ([self checkStatus:AMDeviceStopSession(_device) from:"AMDeviceStopSession"]) {
		_insession = NO;
		return YES;
	}
	return NO;
}


- (void)dealloc
{
	if (_device) {
		if (_insession) [self stopSession];
		if (_connected) [self deviceDisconnect];
	}
	[_deviceName release];
	[_udid release];
	[_lasterror release];
    [_totalDiskCapacity release];
    [_totalDataAvailable release];
    [_deviceClass release];
    [_productType release];
    [_productVersion release];
    [_serialNumber release];
    free(_isConnected);
	[super dealloc];
}

- (BOOL)cancelBackupRestore{
    return (AMSCancelBackupRestore((CFStringRef)[self udid]) == 0);
}

// the application is dying, time to shut down - can't rely on
// dealloc because of reference counting
- (void)applicationWillTerminate:(NSNotification*)notification
{
	if (_device) {
		if (_insession) [self stopSession];
		if (_connected) [self deviceDisconnect];
	}
}

- (id)deviceValueForKey:(NSString*)key inDomain:(NSString*)domain
{
	BOOL opened_connection = NO;
	BOOL opened_session = NO;
	id result = nil;

	// first, check for a connection
	if (!_connected) {
		if (![self deviceConnect]) goto bail;
		opened_connection = YES;
	}

	// one way or another, we have a connection, look for a session
	if (!_insession) {
		if (![self startSession]) goto bail;
		opened_session = YES;
	}

	// ok we have a session running, just query and set up to return
	result = (id)AMDeviceCopyValue(_device,(CFStringRef)domain,(CFStringRef)key);

bail:
	if (opened_session) [self stopSession];
	if (opened_connection) [self deviceDisconnect];
	return [result autorelease];
}

- (BOOL)reDeviceName:(NSString *)newDeviceName
{
    BOOL opened_connection = NO;
	BOOL opened_session = NO;
	mach_error_t result = 0;
    
	// first, check for a connection
	if (!_connected) {
        if (![self deviceConnect]) {
            goto bail;
        }
		opened_connection = YES;
	}
    
	// one way or another, we have a connection, look for a session
	if (!_insession) {
        if (![self startSession]) {
            goto bail;
        }
		opened_session = YES;
	}
    
	// rename device
    result = AMDeviceSetValue(_device, nil, (CFStringRef)@"DeviceName", newDeviceName);
	//result = (id)AMDeviceCopyValue(_device,(CFStringRef)domain,(CFStringRef)key);
    
bail:
	if (opened_session) [self stopSession];
	if (opened_connection) [self deviceDisconnect];
	return (result == 0?YES:NO);
}

- (id)deviceValueForKey:(NSString*)key
{
	return [self deviceValueForKey:key inDomain:nil];
}

- (id)allDeviceValuesForDomain:(NSString*)domain
{
	return [self deviceValueForKey:nil inDomain:domain];
}

/*
- (NSString*)productType
{
	return [self deviceValueForKey:@"ProductType"];
}

- (NSString*)deviceClass
{
	return [self deviceValueForKey:@"DeviceClass"];
}

- (NSString*)productVersion
{
	return [self deviceValueForKey:@"ProductVersion"];
}

- (NSString*)serialNumber
{
	return [self deviceValueForKey:@"SerialNumber"];
}
*/

- (NSString*)description
{
	return [NSString stringWithFormat:@"AMDevice('%@')", _deviceName];
}

- (int)getDeviceRet {
    return deviceRet;
}

// 系统得到消息，然后构建AMDevice对象
- (id)initWithDevice:(am_device)device orBust:(NSString**)msg
{
	if (self=[super init]) {
		_device = device;
        deviceRet = [self checkDeviceConnectStatus];
        if (deviceRet != 0) {
            if (deviceRet == -402653052) {
                return self;
            }else {
                *msg = self.lasterror;
                _device = nil;
                [self release];
                return nil;
            }
        }
//		if (![self deviceConnect]) {
//			*msg = self.lasterror;
//			_device = nil;
//			[self release];
//			return nil;
//		}
//        [self deviceDisconnect];
        
		// we can access device values once we are connected - at 5.0.1, the behaviour
        // seemed to change slightly, and we need a session established as well, so we
        // use our regular method rather than directly calling AMDeviceCopyValue()
        //
        // Could there be a UserAssignedDeviceName ?
        //
        
		_deviceName = [[self deviceValueForKey:@"DeviceName"] retain];
        _udid = [[self deviceValueForKey:@"UniqueDeviceID"] retain];
        _productType = [[self deviceValueForKey:@"ProductType"] retain];
        _deviceClass = [[self deviceValueForKey:@"DeviceClass"] retain];
        _productVersion = [[self deviceValueForKey:@"ProductVersion"] retain];
        _serialNumber = [[self deviceValueForKey:@"SerialNumber"] retain];
        _totalDiskCapacity = [[self deviceValueForKey:@"TotalDiskCapacity" inDomain:@"com.apple.disk_usage"] retain];
        _totalDataAvailable = [[self deviceValueForKey:@"TotalDataAvailable" inDomain:@"com.apple.disk_usage"] retain];
        /*
        _deviceFamily = UnknownDevice;
        if (_productType) {
            NSRange range = [_productType rangeOfString:@"iPhone"];
            if (range.length > 0) {
                _deviceFamily = iPhone;
            } else {
                range = [_productType rangeOfString:@"iPod"];
                if (range.length > 0) {
                    _deviceFamily = iPod_Touch;
                } else {
                    range = [_productType rangeOfString:@"iPad"];
                    if (range.length > 0) {
                        _deviceFamily = iPad;
                    }
                }
            }
        }
        */
        
        
        
		// NSLog(@"AMDeviceGetInterfaceType() returns %d",AMDeviceGetInterfaceType(device));
		// NSLog(@"AMDeviceGetInterfaceSpeed() returns %.0fK",AMDeviceGetInterfaceSpeed(device)/1024.0);
		// NSLog(@"AMDeviceGetConnectionID() returns %d",AMDeviceGetConnectionID(device));

		// apparently we need to disconnect whenever we aren't doing anything or
		// the connection will time-out at the other end???
	}
	return self;
}

+ (AMDevice*)deviceFrom:(am_device)device
{
	NSString *msg = nil;
	AMDevice *result = [[[self class] alloc] initWithDevice:device orBust:&msg];
	if (result) return([result autorelease]);
	NSLog(@"Failed to create AMDevice: %@", msg);
	return nil;
}

- (AFCMediaDirectory*)newAFCMediaDirectory
{
	AFCMediaDirectory *result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			result = [[AFCMediaDirectory alloc] initWithAMDevice:self];
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (AFCCrashLogDirectory*)newAFCCrashLogDirectory
{
	AFCCrashLogDirectory *result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			result = [[AFCCrashLogDirectory alloc] initWithAMDevice:self];
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (AFCRootDirectory*)newAFCRootDirectory
{
	AFCRootDirectory *result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			result = [[AFCRootDirectory alloc] initWithAMDevice:self];
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (AFCApplicationDirectory*)newAFCApplicationDirectory:(NSString*)name
{
	AFCApplicationDirectory *result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			result = [[AFCApplicationDirectory alloc] initWithAMDevice:self andName:name];
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (AMInstallationProxy*)newAMInstallationProxyWithDelegate:(id<AMInstallationProxyDelegate>)delegate
{
	AMInstallationProxy *result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			result = [[AMInstallationProxy alloc] initWithAMDevice:self];
			result.delegate = delegate;
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (AMNotificationProxy*)newAMNotificationProxy
{
	AMNotificationProxy *result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			result = [[AMNotificationProxy alloc] initWithAMDevice:self];
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (AMSpringboardServices*)newAMSpringboardServices
{
	AMSpringboardServices *result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			result = [[AMSpringboardServices alloc] initWithAMDevice:self];
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (AMDiagnosticsRelayServices*)newAMDiagnosticsRelayServices
{
    AMDiagnosticsRelayServices *result = nil;
    if ([self deviceConnect]) {
        if ([self startSession]) {
            result = [[AMDiagnosticsRelayServices alloc] initWithAMDevice:self];
            [self stopSession];
        }
        [self deviceDisconnect];
    }
    return result;
}

- (AMSyslogRelay*)newAMSyslogRelay:(id)listener message:(SEL)message
{
	AMSyslogRelay *result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			result = [[AMSyslogRelay alloc] initWithAMDevice:self listener:listener message:message];
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (AMFileRelay*)newAMFileRelay
{
	AMFileRelay *result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			result = [[AMFileRelay alloc] initWithAMDevice:self];
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (AMMobileSync*)newAMMobileSync
{
	AMMobileSync *result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			result = [[AMMobileSync alloc] initWithAMDevice:self];
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (AMMobileBackupRestore*)newAMMobileBackupRestore
{
    AMMobileBackupRestore *result = nil;
    if ([self deviceConnect]) {
        if ([self startSession]) {
            result = [[AMMobileBackupRestore alloc] initWithAMDevice:self];
            [self stopSession];
        }
        [self deviceDisconnect];
    }
    return result;
}

- (NSArray*)installedApplications
{
	NSMutableArray* result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			CFDictionaryRef dict = nil;
			if (
				[self checkStatus:AMDeviceLookupApplications(_device, nil, &dict)
							 from:"AMDeviceLookupApplications"]
			) {
				result = [[NSMutableArray new] autorelease];
				for (NSString *key in (NSDictionary*)dict) {
					NSDictionary *info = [NSDictionary dictionaryWithDictionary: [(NSDictionary*)dict objectForKey:key]];
					// "User", "System", "Internal" ??
					if ([[info objectForKey:@"ApplicationType"] isEqual:@"User"]) {
						AMApplication *newapp = [[AMApplication alloc] initWithDictionary:info];
						[result addObject:newapp];
						[newapp release];
					}
				}
				CFRelease(dict);
//				result = [NSArray arrayWithArray:result];
			}
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (NSArray*)getSystemApplications
{
	NSMutableArray* result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			CFDictionaryRef dict = nil;
			if (
				[self checkStatus:AMDeviceLookupApplications(_device, nil, &dict)
							 from:"AMDeviceLookupApplications"]
                ) {
				result = [[NSMutableArray new] autorelease];
				for (NSString *key in (NSDictionary*)dict) {
					NSDictionary *info = [NSDictionary dictionaryWithDictionary: [(NSDictionary*)dict objectForKey:key]];
					// "User", "System", "Internal" ??
					if ([[info objectForKey:@"ApplicationType"] isEqual:@"System"]) {
						AMApplication *newapp = [[AMApplication alloc] initWithDictionary:info];
						[result addObject:newapp];
						[newapp release];
					}
				}
				CFRelease(dict);
                //				result = [NSArray arrayWithArray:result];
			}
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}




- (AMApplication*)installedApplicationWithId:(NSString*)id
{
	AMApplication* result = nil;
	if ([self deviceConnect]) {
		if ([self startSession]) {
			CFDictionaryRef dict = nil;
			if (
				[self checkStatus:AMDeviceLookupApplications(_device, nil, &dict)
							 from:"AMDeviceLookupApplications"]
			) {
				NSDictionary *info = [(NSDictionary*)dict objectForKey:id];
				if (info) {
					result = [[[AMApplication alloc] initWithDictionary:info] autorelease];
				}
				CFRelease(dict);
			}
			[self stopSession];
		}
		[self deviceDisconnect];
	}
	return result;
}

- (NSDictionary*)getDeviceInfo {
    NSMutableDictionary *deviceBaseInfo = [[NSMutableDictionary alloc] init];
    
    BOOL opened_connection = NO;
	BOOL opened_session = NO;
	id result = nil;
    
	// first, check for a connection
	if (!_connected) {
		if (![self deviceConnect]) goto bail;
		opened_connection = YES;
	}
    
	// one way or another, we have a connection, look for a session
	if (!_insession) {
		if (![self startSession]) goto bail;
		opened_session = YES;
	}
    
	// ok we have a session running, just query and set up to return
    //[deviceBaseInfo setValue:_deviceName forKey:@"DeviceName"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"DeviceName");
    [deviceBaseInfo setValue:result forKey:@"DeviceName"];
    if (_deviceName != nil) {
        [_deviceName release];
        _deviceName = nil;
    }
    _deviceName = [[self deviceValueForKey:@"DeviceName"] retain];
    
    
	result = (id)AMDeviceCopyValue(_device,(CFStringRef)@"com.apple.mobile.iTunes",(CFStringRef)@"SupportsAirTraffic");
    [deviceBaseInfo setValue:result forKey:@"AirSync"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"ProductVersion");
    [deviceBaseInfo setValue:result forKey:@"ProductVersion"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"DeviceClass");;
    [deviceBaseInfo setValue:result forKey:@"DeviceClass"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"FirmwareVersion");
    [deviceBaseInfo setValue:result forKey:@"FirmwareVersion"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"SerialNumber");
    [deviceBaseInfo setValue:result forKey:@"SerialNumber"];
    
    NSString *udid = [(id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"UniqueDeviceID") retain];
    result = [[udid substringWithRange:NSMakeRange(0, 16)] uppercaseString];
    [deviceBaseInfo setValue:result forKey:@"FirewireID"];
    
    result = udid;
    [deviceBaseInfo setValue:result forKey:@"SerialNumberForHashing"];
    [udid release];
    udid = nil;
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"ProductType");
    [deviceBaseInfo setValue:result forKey:@"ProductType"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"PhoneNumber");
    [deviceBaseInfo setValue:result forKey:@"PhoneNumber"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"UniqueDeviceID");
    [deviceBaseInfo setValue:result forKey:@"UniqueDeviceID"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"DeviceColor");
    [deviceBaseInfo setValue:result forKey:@"DeviceColor"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"ActivationState");
    [deviceBaseInfo setValue:result forKey:@"ActivationState"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"BluetoothAddress");
    [deviceBaseInfo setValue:result forKey:@"BluetoothAddress"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"RegionInfo");
    [deviceBaseInfo setValue:result forKey:@"RegionInfo"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"SIMStatus");
    [deviceBaseInfo setValue:result forKey:@"SIMStatus"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"TimeZone");
    [deviceBaseInfo setValue:result forKey:@"TimeZone"];
    
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"TimeZoneOffsetFromUTC");
    [deviceBaseInfo setValue:result forKey:@"TimeZoneOffsetFromUTC"];
     
    result = (id)AMDeviceCopyValue(_device,nil,(CFStringRef)@"WiFiAddress");
    [deviceBaseInfo setValue:result forKey:@"WiFiAddress"];
    
    //2014-8-6
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"ModelNumber");
    [deviceBaseInfo setValue:result forKey:@"ModelNumber"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"BuildVersion");
    [deviceBaseInfo setValue:result forKey:@"BuildVersion"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"HardwareModel");
    [deviceBaseInfo setValue:result forKey:@"HardwareModel"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"CPUArchitecture");
    [deviceBaseInfo setValue:result forKey:@"CPUArchitecture"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"ActivationStateAcknowledged");
    [deviceBaseInfo setValue:result forKey:@"ActivationStateAcknowledged"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"BasebandVersion");
    [deviceBaseInfo setValue:result forKey:@"BasebandVersion"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"BasebandBootloaderVersion");
    [deviceBaseInfo setValue:result forKey:@"BasebandBootloaderVersion"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"BasebandChipId");
    [deviceBaseInfo setValue:result forKey:@"BasebandChipId"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"BasebandGoldCertId");
    [deviceBaseInfo setValue:result forKey:@"BasebandGoldCertId"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"IntegratedCircuitCardIdentity");
    [deviceBaseInfo setValue:result forKey:@"IntegratedCircuitCardIdentity"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"InternationalMobileEquipmentIdentity");
    [deviceBaseInfo setValue:result forKey:@"InternationalMobileEquipmentIdentity"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"InternationalMobileSubscriberIdentity");
    [deviceBaseInfo setValue:result forKey:@"InternationalMobileSubscriberIdentity"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"MLBSerialNumber");
    [deviceBaseInfo setValue:result forKey:@"MLBSerialNumber"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"MobileSubscriberCountryCode");
    [deviceBaseInfo setValue:result forKey:@"MobileSubscriberCountryCode"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"MobileSubscriberNetworkCode");
    [deviceBaseInfo setValue:result forKey:@"MobileSubscriberNetworkCode"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"PasswordProtected");
    [deviceBaseInfo setValue:result forKey:@"PasswordProtected"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"ProductionSOC");
    [deviceBaseInfo setValue:result forKey:@"ProductionSOC"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"ProtocolVersion");
    [deviceBaseInfo setValue:result forKey:@"ProtocolVersion"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"SDIOProductInfo");
    [deviceBaseInfo setValue:result forKey:@"SDIOProductInfo"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"SupportedDeviceFamilies");
    [deviceBaseInfo setValue:result forKey:@"SupportedDeviceFamilies"];
    
    result = (id)AMDeviceCopyValue(_device, nil, (CFStringRef)@"TimeIntervalSince1970");
    [deviceBaseInfo setValue:result forKey:@"TimeIntervalSince1970"];
    
bail:
	if (opened_session) [self stopSession];
	if (opened_connection) [self deviceDisconnect];
	//return [result autorelease];
    [deviceBaseInfo autorelease];
    return deviceBaseInfo;
}

- (BOOL)CancelBackupRestore {
    return (AMSCancelBackupRestore((CFStringRef)[self udid]) == 0);
}

@end

@implementation MobileDeviceAccess

@synthesize devices=_devices;
@synthesize ConnectedDevice=_connectedDevice;

// this is (indirectly) called back by AMDeviceNotificationSubscribe()
// whenever something interesting happens
- (void)Notify:(struct am_device_notification_callback_info*)info
{
	AMDevice *d;
	switch (info->msg) {
        default: {
            NSLog(@"Ignoring unknown message: %d",info->msg);
            return;
        }

        case ADNCI_MSG_UNSUBSCRIBED: {
            return;
        }

        case ADNCI_MSG_CONNECTED: {
            int connectType = AMDeviceGetInterfaceType(info->dev);
//            AMDeviceDisconnect(info->dev);
            if (connectType == 1) {
                // 1:有线连接
//                d = [AMDevice deviceFrom:info->dev];
//                if (d != nil) {
//                    if ([d getDeviceRet] == -402653052) {
//                        return;
//                    }
//                    [_devices addObject:d];
//                    [d setIsWifiConnection:NO];
//                }
                [self connectDevice:info->dev];
            } else if (connectType == 2) {
                // 2:无线连接
                if ([_listener canSupportWifi]) {
                    d = [AMDevice deviceFrom:info->dev];
                    if (d != nil) {
                        [_devices addObject:d];
                        [d setIsWifiConnection:YES];
                        if (_listener && [_listener respondsToSelector:@selector(deviceConnected:)]) {
                            [_listener deviceConnected:d];
                        }
                    }
                }
            } else {
                // 默认有线连接
                d = [AMDevice deviceFrom:info->dev];
                if (d != nil) {
                    [_devices addObject:d];
                    [d setIsWifiConnection:NO];
                    if (_listener && [_listener respondsToSelector:@selector(deviceConnected:)]) {
                        [_listener deviceConnected:d];
                    }
                }
            }
            break;
        }

        case ADNCI_MSG_DISCONNECTED: {
            for (d in _devices) {
                if ([d isDevice:info->dev]) {
                    NSLog(@"Device udid:%@",d.udid);
                    NSLog(@"Device serialNumber:%@",d.serialNumber);
                    if (d.serialNumber == nil) {
                        NSLog(@"******");
                    }
                    [d forgetDevice];
                    NSLog(@"Device serialNumber2:%@",d.serialNumber);
                    if (_listener && [_listener respondsToSelector:@selector(deviceDisconnected:)]) {
                        NSLog(@"Device serialNumber3:%@",d.serialNumber);
                        BOOL isConnected = NO;
                        [d setIsConnected:&isConnected];
                        [_listener deviceDisconnected:d];
                    }
                   
                    [_devices removeObject:d];
                    
                    break;
                }
            }
            break;
        }
	}

	// if he's waiting for us to do something, break him
	if (_waitingInRunLoop) CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)connectDevice:(am_device)dev {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AMDevice * d = [AMDevice deviceFrom:dev];
        if (d != nil) {
            if ([d getDeviceRet] == -402653052) {
                return;
            }
            BOOL isConnected = YES;
            if ([_devices count] > 0) {
                BOOL isExist = NO;
                for (AMDevice *amDevice in _devices) {
                    if ([amDevice.serialNumber isEqualToString:d.serialNumber]) {
                        isExist = YES;
                        break;
                    }
                }
                if (!isExist) {
                    [_devices addObject:d];
                }
            }else {
                if (![_devices containsObject:d]) {
                    [_devices addObject:d];
                }
            }
            [d setIsWifiConnection:NO];
            [d setIsConnected:&isConnected];
            if (_listener && [_listener respondsToSelector:@selector(deviceConnected:)]) {
                [_listener deviceConnected:d];
            }
        }else {
            if (_listener && [_listener respondsToSelector:@selector(deviceNeedPassword:)]) {
                [_listener deviceNeedPassword:dev];
            }
        }
    });
}

// someone outside us wants to detach a device - perhaps they've closed the window.
// 
- (void)detachDevice:(AMDevice*)d
{
	[_devices removeObject:d];
}

// this is called back by AMDeviceNotificationSubscribe()
// we just punt back into a regular method
static
void notify_callback(struct am_device_notification_callback_info *info, void* arg)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[(MobileDeviceAccess*)arg Notify:info];
    [pool drain];
}

- (void)applicationWillTerminate:(NSNotification*)notification
{
	for (AMDevice *device in _devices) {
		[device applicationWillTerminate:notification];
	}
}

- (id)init
{
	if (self=[super init]) {
		_subscribed = NO;					// we are not subscribed yet
		_devices = [NSMutableArray new];	// we have no device connected
		_waitingInRunLoop = NO;			// we are not currently waiting in a runloop
		// we opened, we need to ensure that we get closed or our
		// services stay running on the ipod
		[[NSNotificationCenter defaultCenter] 
			addObserver: self
			   selector: @selector(applicationWillTerminate:)
				   name: NSApplicationWillTerminateNotification
				 object: nil];
    }
	return self;
}

- (bool)setListener:(id<MobileDeviceAccessListener>)listener
{
	_listener = listener;
	if (_listener) {
		// if we are not subscribed yet, do it now
		if (!_subscribed) {
			// try to subscribe for notifications - pass self as the callback_data
			int ret = AMDeviceNotificationSubscribe(notify_callback, 0, 0, self, &_notification);
			if (ret == 0) {
				_subscribed = YES;
			} else {
				// we should throw or something in here...
				NSLog(@"AMDeviceNotificationSubscribe failed: %d", ret);
			}
		}
	}
	return YES;
}

- (bool)stopListener {
    if (_listener) {
        int ret = AMDeviceNotificationUnsubscribe(_notification);
        if (ret == 0) {
            _subscribed = NO;
        } else {
            NSLog(@"AMDeviceNotificationUnsubscribe failed: %d", ret);
        }
        _listener = nil;
    }
    return YES;
}

- (void)dealloc
{
	NSLog(@"deallocating %@",self);

	// we must stop observing everything before we evaporate
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	// if we are currently waiting, stop now
	if (_waitingInRunLoop) CFRunLoopStop(CFRunLoopGetCurrent());

	[_devices release];
	[super dealloc];
}

- (bool)waitForConnection
{
	// we didn't manage to subscribe for notifications so there is no
	// point waiting
	if (!_subscribed) return NO;

	NSLog(@"calling CFRunLoopRun(), plug iPod in now!!!");
	_waitingInRunLoop = YES;
	CFRunLoopRun();
	_waitingInRunLoop = NO;
	NSLog(@"back from calling CFRunLoopRun()");

// while (something?) {
// 		_waitingInRunLoop = YES;
//		CFRunLoopRunInMode (@"waiting for connection", 5/*seconds*/, NO/*returnAfterSourceHandled*/);
//		_waitingInRunLoop = NO;
//		if (_device) return YES;
// }
	return YES;
}

- (NSString*)clientVersion
{
	return [NSString stringWithUTF8String:AFCGetClientVersionString()];
}

+ (MobileDeviceAccess*)singleton
{
	static MobileDeviceAccess *_singleton = nil;
	@synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[MobileDeviceAccess alloc] init];
			
		}
	}
	return _singleton;
}

@end

//add by zhangyang 2012/12/18 start

@implementation AMFileEntity
@synthesize FileType = _fileType;
@synthesize FileSize = _fileSize;
@synthesize FilePath = _filePath;
@synthesize Name = _name;

- (void) dealloc {
    [_filePath release];
    [super dealloc];
}

@end

//add by zhangyang 2012/12/18 end

static ScanStatus *scanStatus;
@implementation ScanStatus
@synthesize stopClean=_stopClean;
@synthesize skipScan=_skipScan;
@synthesize stopScan=_stopScan;
@synthesize isPause = _isPause;
@synthesize isSqliteEnd = _isSqliteEnd;
+(ScanStatus *)shareInstance{
    if (!scanStatus){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            scanStatus = [[ScanStatus alloc ] init];
        });
    }
    return scanStatus;
}
@end

@implementation AsyncState
@synthesize offset = _offset;
@synthesize fileHandle = _fileHandle;
@synthesize bufferList = _bufferList;
@synthesize readLengthList = _readLengthList;
@synthesize fileLength = _fileLength;
@synthesize isReaded = _isReaded;
@synthesize writeCountOnce = _writeCountOnce;
@synthesize condition = _condition;
@synthesize dfHandle = _dfHandle;
@synthesize buff = _buff;
@synthesize bufsz = _bufsz;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _offset = 0;
        _isReaded = NO;
        _writeCountOnce = 0;
        _fileLength = 0;
        _bufsz = 0;
        _bufferList = [[NSMutableArray alloc] init];
        _readLengthList = [[NSMutableArray alloc] init];
        _condition = [[NSCondition alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_bufferList != nil) {
        [_bufferList release];
        _bufferList = nil;
    }
    if (_readLengthList != nil) {
        [_readLengthList release];
        _readLengthList = nil;
    }
    if (_condition != nil) {
        [_condition release];
        _condition = nil;
    }
    [super dealloc];
}

@end


