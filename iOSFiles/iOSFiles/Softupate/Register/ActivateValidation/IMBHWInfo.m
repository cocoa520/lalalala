//
//  IMBHWInfo.m
//  iMobieTrans
//
//  Created by Pallas on 3/28/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBHWInfo.h"

@implementation IMBHWInfo
@synthesize platformSerialNumber = _platformSerialNumber;
@synthesize cpuIds = _cpuIds;
@synthesize hardwareUUID = _hardwareUUID;
@synthesize hardwareSerialNumber = _hardwareSerialNumber;

- (id)init {
    if (self=[super init]) {
        _platformSerialNumber = [[self getPlatformSerialNumber] retain];
        _cpuIds = [[self getCpuIds] retain];
        _hardwareUUID = [[self getHardwareUUID] retain];
        _hardwareSerialNumber = [[self getHardwareSerialNumber] retain];
		nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
    }
	return self;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (nc != nil) {
        [nc removeObserver:self];
        nc = nil;
    }
    if (_platformSerialNumber != nil) {
        [_platformSerialNumber release];
        _platformSerialNumber = nil;
    }
    if (_cpuIds != nil) {
        [_cpuIds release];
        _cpuIds = nil;
    }
    if (_hardwareUUID != nil) {
        [_hardwareUUID release];
        _hardwareUUID = nil;
    }
    if (_hardwareSerialNumber != nil) {
        [_hardwareSerialNumber release];
        _hardwareSerialNumber = nil;
    }
#endif
    [super dealloc];
}

- (void)applicationWillTerminate:(NSNotification*)notification {
    [nc removeObserver:self name:NSApplicationWillTerminateNotification object:nil];
    [self dealloc];
}

+ (IMBHWInfo*)singleton {
    static IMBHWInfo *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBHWInfo alloc] init];
		}
	}
	return _singleton;
}

void objc_println(NSString* format, ... ) {
    va_list args;
    
    if (![format hasSuffix: @"\n"]) {
        format = [format stringByAppendingString: @"\n"];
    }
	
    va_start (args, format);
    NSString *body =  [[NSString alloc] initWithFormat: format
                                             arguments: args];
    va_end (args);
	
    fprintf(stderr,"%s",[body UTF8String]);
    
    [body release];
}

- (void)printSysctlInfo {
    objc_println(@"Beginning system data collection...");
    
    NSProcessInfo* pinfo = [NSProcessInfo processInfo];
    
    objc_println( @"NSProcessInfo:" );
    objc_println( @"\tProcess Name: %@", [pinfo processName] );
    objc_println( @"\tPID: %d", [pinfo processIdentifier] );
    objc_println( @"\tProcess GUID: %@", [pinfo globallyUniqueString] );
    objc_println( @"\tOS Version: %@", [pinfo operatingSystemVersionString] );
    objc_println( @"\tTotal Processors: %d", [pinfo processorCount] );
    objc_println( @"\tActive Processors: %d", [pinfo activeProcessorCount] );
    objc_println( @"\tTotal RAM: %ull bytes", [pinfo physicalMemory] );
    
    objc_println( @"sysctl:" );
    
    int mib[2];
    size_t len = 0;
    char *rstring = NULL;
    unsigned int rint = 0;
    
    /* Setup the MIB data */
    mib[0] = CTL_KERN;
    mib[1] = KERN_OSTYPE;
    
    /* Get the length of the string */
    sysctl( mib, 2, NULL, &len, NULL, 0 );
    
    /* Now allocate space for the string and grab it */
    rstring = malloc( len );
    sysctl( mib, 2, rstring, &len, NULL, 0 );
    objc_println( @"\tkern.ostype: %s", rstring );
    
    /* Make sure we clean up afterwards! */
    free( rstring );
    rstring = NULL;
    
    /* Get the kernel release number */
    mib[0] = CTL_KERN;
    mib[1] = KERN_OSRELEASE;
    sysctl( mib, 2, NULL, &len, NULL, 0 );
    rstring = malloc( len );
    sysctl( mib, 2, rstring, &len, NULL, 0 );
    objc_println( @"\tkern.osrelease: %s", rstring );
    free( rstring );
    rstring = NULL;
    
    /* Get the Mac OS X Build number */
    mib[0] = CTL_KERN;
    mib[1] = KERN_OSVERSION;
    sysctl( mib, 2, NULL, &len, NULL, 0 );
    rstring = malloc( len );
    sysctl( mib, 2, rstring, &len, NULL, 0 );
    objc_println( @"\tkern.osversion: %s", rstring );
    free( rstring );
    rstring = NULL;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MODEL;
    sysctl( mib, 2, NULL, &len, NULL, 0 );
    rstring = malloc( len );
    sysctl( mib, 2, rstring, &len, NULL, 0 );
    objc_println( @"\thw.model: %s", rstring );
    free( rstring );
    rstring = NULL;
    
    sysctlbyname( "machdep.cpu.brand_string", NULL, &len, NULL, 0 );
    rstring = malloc( len );
    sysctlbyname( "machdep.cpu.brand_string", rstring, &len, NULL, 0 );
    objc_println( @"\tmachdep.cpu.brand_string: %s", rstring );
    free( rstring );
    rstring = NULL;
    
    mib[0] = CTL_HW;
    mib[1] = HW_CPU_FREQ;
    len = sizeof( rint );
    sysctl( mib, 2, &rint, &len, NULL, 0 );
    objc_println( @"\thw.cpufrequency: %u", rint );
}

- (NSString*)getPlatformSerialNumber {
    io_registry_entry_t     rootEntry = IORegistryEntryFromPath( kIOMasterPortDefault, "IOService:/" );
    CFTypeRef serialAsCFString = NULL;
    
    serialAsCFString = IORegistryEntryCreateCFProperty( rootEntry,
                                                       CFSTR(kIOPlatformSerialNumberKey),
                                                       kCFAllocatorDefault,
                                                       0);
    
    IOObjectRelease( rootEntry );
    return (NULL != serialAsCFString) ? [(NSString*)serialAsCFString autorelease] : nil;
}

- (NSDictionary*)getCpuIds {
    NSMutableDictionary*    cpuInfo = [[NSMutableDictionary alloc] init];
    CFMutableDictionaryRef  matchClasses = NULL;
    kern_return_t           kernResult = KERN_FAILURE;
    mach_port_t             machPort;
    io_iterator_t           serviceIterator;
    
    io_object_t             cpuService;
    
    kernResult = IOMasterPort( MACH_PORT_NULL, &machPort );
    if( KERN_SUCCESS != kernResult ) {
        printf( "IOMasterPort failed: %d\n", kernResult );
    }
    
    matchClasses = IOServiceNameMatching( "processor" );
    if( NULL == matchClasses ) {
        printf( "IOServiceMatching returned a NULL dictionary" );
    }
    
    kernResult = IOServiceGetMatchingServices( machPort, matchClasses, &serviceIterator );
    if( KERN_SUCCESS != kernResult ) {
        printf( "IOServiceGetMatchingServices failed: %d\n", kernResult );
    }
    
    while( (cpuService = IOIteratorNext( serviceIterator )) ) {
        CFTypeRef CPUIDAsCFNumber = NULL;
        io_name_t nameString;
        IORegistryEntryGetNameInPlane( cpuService, kIOServicePlane, nameString );
        
        CPUIDAsCFNumber = IORegistryEntrySearchCFProperty( cpuService,
                                                          kIOServicePlane,
                                                          CFSTR( "IOCPUID" ),
                                                          kCFAllocatorDefault,
                                                          kIORegistryIterateRecursively);
        
        if( NULL != CPUIDAsCFNumber ) {
            NSString* cpuName = [NSString stringWithCString:nameString encoding:NSUTF8StringEncoding];
            [cpuInfo setObject:(NSNumber*)CPUIDAsCFNumber forKey:cpuName];
        }
        
        if( NULL != CPUIDAsCFNumber ) {
            CFRelease( CPUIDAsCFNumber );
        }
    }
    
    IOObjectRelease( serviceIterator );
    
    return [cpuInfo autorelease];
}

- (NSString*)getHardwareUUID {
    NSString *ret = nil;
    io_service_t platformExpert ;
    platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice")) ;
    
    if (platformExpert) {
        CFTypeRef serialNumberAsCFString ;
        serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR("IOPlatformUUID"), kCFAllocatorDefault, 0) ;
        if (serialNumberAsCFString) {
            ret = [(NSString *)(CFStringRef)serialNumberAsCFString copy];
            CFRelease(serialNumberAsCFString); serialNumberAsCFString = NULL;
        }
        IOObjectRelease(platformExpert); platformExpert = 0;
    }
    
    return [ret autorelease];
}

- (NSString*)getHardwareSerialNumber {
    NSString * ret = nil;
    io_service_t platformExpert ;
    platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice")) ;
    
    if (platformExpert) {
        CFTypeRef uuidNumberAsCFString ;
        uuidNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR("IOPlatformSerialNumber"), kCFAllocatorDefault, 0) ;
        if (uuidNumberAsCFString)   {
            ret = [(NSString *)(CFStringRef)uuidNumberAsCFString copy];
            CFRelease(uuidNumberAsCFString); uuidNumberAsCFString = NULL;
        }
        IOObjectRelease(platformExpert); platformExpert = 0;
    }
    
    return [ret autorelease];
}

@end
