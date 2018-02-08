//
//  CocosSudo.m
//  CleanMac-OC
//
//  Created by iMobie on 11/28/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "CocosSudo.h"

#import <Cocoa/Cocoa.h>
#import "GeneralUtility.h"
#include <sys/stat.h>
#include <unistd.h>
#include <Security/Authorization.h>
#include <Security/AuthorizationTags.h>
#import "AuthorizationUtility.h"

char *addfiletopath(const char *path, const char *filename)
{
	char *outbuf;
	char *lc;
    
	lc = (char *)path + strlen(path) - 1;
	if (lc < path || *lc != '/')
	{
		lc = NULL;
	}
	while (*filename == '/')
	{
		filename++;
	}
	outbuf = malloc(strlen(path) + strlen(filename) + 1 + (lc == NULL ? 1 : 0));
	sprintf(outbuf, "%s%s%s", path, (lc == NULL) ? "/" : "", filename);
	
	return outbuf;
}

int isexecfile(const char *name)
{
	struct stat s;
	return (!access(name, X_OK) && !stat(name, &s) && S_ISREG(s.st_mode));
}

char *which(const char *filename)
{
	char *path, *p, *n;
	
	path = getenv("PATH");
	if (!path)
	{
		return NULL;
	}
    
	p = path = strdup(path);
	while (p) {
		n = strchr(p, ':');
		if (n)
		{
			*n++ = '\0';
		}
		if (*p != '\0')
		{
			p = addfiletopath(p, filename);
			if (isexecfile(p))
			{
				free(path);
				return p;
			}
			free(p);
		}
		p = n;
	}
	free(path);
	return NULL;
}

int sudoprivilege(char *executable, char *commandArgs[], char *icon, char *prompt) {
    int retVal = 1;
    
    OSStatus status;
    AuthorizationRef authRef;
    
    AuthorizationUtility *utility = [AuthorizationUtility singleton];
    if (utility.authorizationRef != NULL && utility.status == errAuthorizationSuccess) {
        authRef = utility.authorizationRef;
        status = utility.status;
    }
    else{
        AuthorizationItem right = { "com.imobie.MacClean", 0, NULL, 0 };
        AuthorizationRights rightSet = { 1, &right };
        
        AuthorizationEnvironment myAuthorizationEnvironment;
        AuthorizationItem kAuthEnv[2];
        myAuthorizationEnvironment.items = kAuthEnv;
        
        if (icon == NULL || strlen(icon) == 0) {
            NSString *iconPath = [[NSBundle mainBundle] pathForResource:@"CleanMyDri" ofType:@"tiff"];
            icon = [GeneralUtility convertStringToCstring:iconPath];
        }
        
        if (prompt && icon)
        {
            
            kAuthEnv[0].name = kAuthorizationEnvironmentPrompt;
            kAuthEnv[0].valueLength = strlen(prompt);
            kAuthEnv[0].value = prompt;
            kAuthEnv[0].flags = 0;
            
            kAuthEnv[1].name = kAuthorizationEnvironmentIcon;
            kAuthEnv[1].valueLength = strlen(icon);
            kAuthEnv[1].value = icon;
            kAuthEnv[1].flags = 0;
            
            myAuthorizationEnvironment.count = 2;
        }
        else if (prompt)
        {
            kAuthEnv[0].name = kAuthorizationEnvironmentPrompt;
            kAuthEnv[0].valueLength = strlen(prompt);
            kAuthEnv[0].value = prompt;
            kAuthEnv[0].flags = 0;
            
            myAuthorizationEnvironment.count = 1;
        }
        else if (icon)
        {
            kAuthEnv[0].name = kAuthorizationEnvironmentIcon;
            kAuthEnv[0].valueLength = strlen(icon);
            kAuthEnv[0].value = icon;
            kAuthEnv[0].flags = 0;
            
            myAuthorizationEnvironment.count = 1;
        }
        else
        {
            myAuthorizationEnvironment.count = 0;
        }
        
        if (AuthorizationCreate(NULL, &myAuthorizationEnvironment/*kAuthorizationEmptyEnvironment*/, kAuthorizationFlagDefaults, &authRef) != errAuthorizationSuccess)
        {
            NSLog(@"Could not create authorization reference object.");
            status = errAuthorizationBadAddress;
        }
        else
        {
            status = AuthorizationCopyRights(authRef, &rightSet, &myAuthorizationEnvironment/*kAuthorizationEmptyEnvironment*/,
                                             kAuthorizationFlagDefaults | kAuthorizationFlagPreAuthorize
                                             | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagExtendRights,
                                             NULL);
        }
        
    }
    
    if (status == errAuthorizationSuccess)
    {
#pragma clang diagnostic ignored "-Wdeprecated"
        status = AuthorizationExecuteWithPrivileges(authRef, executable, 0, commandArgs, NULL);
        if (status == errAuthorizationSuccess)
        {
            utility.authorizationRef = authRef;
            utility.status = status;
            [utility setNeedAuthorize:NO];  // Add song
            retVal = 0;
        }
    }
    else
    {
        [utility setNeedAuthorize:YES];
        AuthorizationFree(authRef, kAuthorizationFlagDestroyRights);
        authRef = NULL;
        if (status != errAuthorizationCanceled)
        {
            // pre-auth failed
            NSLog(@"Pre-auth failed");
        }
    }
    
    return retVal;
}

int cocoasudo(char *executable, char *commandArgs[], char *icon, char *prompt, excutecallback callback)
{
	int retVal = 1;
	
	OSStatus status;
	AuthorizationRef authRef;
	
    AuthorizationUtility *utility = [AuthorizationUtility singleton];
    if (utility.authorizationRef != NULL && utility.status == errAuthorizationSuccess) {
        authRef = utility.authorizationRef;
        status = utility.status;
    }
    else{
        AuthorizationItem right = { "com.imobie.MacClean", 0, NULL, 0 };
        AuthorizationRights rightSet = { 1, &right };
        
        AuthorizationEnvironment myAuthorizationEnvironment;
        AuthorizationItem kAuthEnv[2];
        myAuthorizationEnvironment.items = kAuthEnv;
        
        if (icon == NULL || strlen(icon) == 0) {
            NSString *iconPath = [[NSBundle mainBundle] pathForResource:@"CleanMyDri" ofType:@"tiff"];
            icon = [GeneralUtility convertStringToCstring:iconPath];
        }
        
        if (prompt && icon)
        {
            
            kAuthEnv[0].name = kAuthorizationEnvironmentPrompt;
            kAuthEnv[0].valueLength = strlen(prompt);
            kAuthEnv[0].value = prompt;
            kAuthEnv[0].flags = 0;
            
            kAuthEnv[1].name = kAuthorizationEnvironmentIcon;
            kAuthEnv[1].valueLength = strlen(icon);
            kAuthEnv[1].value = icon;
            kAuthEnv[1].flags = 0;
            
            myAuthorizationEnvironment.count = 2;
        }
        else if (prompt)
        {
            kAuthEnv[0].name = kAuthorizationEnvironmentPrompt;
            kAuthEnv[0].valueLength = strlen(prompt);
            kAuthEnv[0].value = prompt;
            kAuthEnv[0].flags = 0;
            
            myAuthorizationEnvironment.count = 1;
        }
        else if (icon)
        {
            kAuthEnv[0].name = kAuthorizationEnvironmentIcon;
            kAuthEnv[0].valueLength = strlen(icon);
            kAuthEnv[0].value = icon;
            kAuthEnv[0].flags = 0;
            
            myAuthorizationEnvironment.count = 1;
        }
        else
        {
            myAuthorizationEnvironment.count = 0;
        }
        
        if (AuthorizationCreate(NULL, &myAuthorizationEnvironment/*kAuthorizationEmptyEnvironment*/, kAuthorizationFlagDefaults, &authRef) != errAuthorizationSuccess)
        {
            NSLog(@"Could not create authorization reference object.");
            status = errAuthorizationBadAddress;
        }
        else
        {
            status = AuthorizationCopyRights(authRef, &rightSet, &myAuthorizationEnvironment/*kAuthorizationEmptyEnvironment*/,
                                             kAuthorizationFlagDefaults | kAuthorizationFlagPreAuthorize
                                             | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagExtendRights,
                                             NULL);
        }

    }
    
	if (status == errAuthorizationSuccess)
	{

		FILE *ioPipe;
		char buffer[1024] = {'\0'};
		size_t bytesRead = 0;

#pragma clang diagnostic ignored "-Wdeprecated"
		status = AuthorizationExecuteWithPrivileges(authRef, executable, 0, commandArgs, &ioPipe);
        if (!ioPipe) {
            retVal = 1;
            return retVal;
        }
		/* Just pipe processes' stdout to our stdout for now; hopefully can add stdin pipe later as well */
		for (;;)
		{
			bytesRead = fread(buffer, sizeof(char), 1024, ioPipe);
			if (bytesRead < 1) break;
            if (callback != NULL) {
                callback(buffer);
            }
			// write(STDOUT_FILENO, buffer, bytesRead * sizeof(char));
		}
		
		pid_t pid;
		int pidStatus;
		do {
			pid = wait(&pidStatus);
		} while (pid != -1);
		
		if (status == errAuthorizationSuccess)
		{
            utility.authorizationRef = authRef;
            utility.status = status;
            [utility setNeedAuthorize:NO];  // Add song
			retVal = 0;
		}
        fclose(ioPipe);
	}
	else
	{
        [utility setNeedAuthorize:YES];
        AuthorizationFree(authRef, kAuthorizationFlagDestroyRights);
        authRef = NULL;
		if (status != errAuthorizationCanceled)
		{
			// pre-auth failed
			NSLog(@"Pre-auth failed");
		}
	}
	
	return retVal;
}

void usage(char *appNameFull)
{
	char *appName = strrchr(appNameFull, '/');
	if (appName == NULL)
	{
		appName = appNameFull;
	}
	else {
		appName++;
	}
	fprintf(stderr, "usage: %s [--icon=icon.tiff] [--prompt=prompt...] command\n  --icon=[filename]: optional argument to specify a custom icon\n  --prompt=[prompt]: optional argument to specify a custom prompt\n", appName);
}

int sudo(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    int retVal = 1;
    int programArgsStartAt = 0;
    char *icon = NULL;
    char *prompt = NULL;
    
    for (; programArgsStartAt < argc; programArgsStartAt++)
    {
        if (!strncmp("--icon=", argv[programArgsStartAt], 7))
        {
            icon = argv[programArgsStartAt] + 7;
        }
        else if (!strncmp("--prompt=", argv[programArgsStartAt], 9))
        {
            prompt = argv[programArgsStartAt] + 9;
            size_t promptLen = strlen(prompt);
            char *newPrompt = malloc(sizeof(char) * (promptLen + 2));
            strcpy(newPrompt, prompt);
            newPrompt[promptLen] = '\n';
            newPrompt[promptLen + 1] = '\n';
            newPrompt[promptLen + 2] = '\0';
            prompt = newPrompt;
        }
        else
        {
            break;
        }
    }
    
    if (programArgsStartAt >= argc)
    {
        usage(argv[0]);
    }
    else
    {
        char *executable;
        
        if (strchr(argv[programArgsStartAt], '/'))
        {
            executable = isexecfile(argv[programArgsStartAt]) ? strdup(argv[programArgsStartAt]) : NULL;
        }
        else
        {
            executable = which(argv[programArgsStartAt]);
        }
        
        if (executable)
        {
            char **commandArgs = malloc((argc - programArgsStartAt) * sizeof(char**));
            memcpy(commandArgs, argv + programArgsStartAt + 1, (argc - programArgsStartAt - 1) * sizeof(char**));
            commandArgs[argc - programArgsStartAt - 1] = NULL;
            retVal = sudoprivilege(executable, commandArgs, icon, prompt);
            free(commandArgs);
            free(executable);
        }
        else
        {
            fprintf(stderr, "Unable to find %s\n", argv[programArgsStartAt]);
            usage(argv[0]);
        }
    }
    
    if (prompt) {
        free(prompt);
    }
    
    [pool release];
    return retVal;
}

int cocosSudo(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    int retVal = 1;
    int programArgsStartAt = 0;
    char *icon = NULL;
    char *prompt = NULL;
    
    for (; programArgsStartAt < argc; programArgsStartAt++)
    {
        if (!strncmp("--icon=", argv[programArgsStartAt], 7))
        {
            icon = argv[programArgsStartAt] + 7;
        }
        else if (!strncmp("--prompt=", argv[programArgsStartAt], 9))
        {
            prompt = argv[programArgsStartAt] + 9;
            size_t promptLen = strlen(prompt);
            char *newPrompt = malloc(sizeof(char) * (promptLen + 2));
            strcpy(newPrompt, prompt);
            newPrompt[promptLen] = '\n';
            newPrompt[promptLen + 1] = '\n';
            newPrompt[promptLen + 2] = '\0';
            prompt = newPrompt;
        }
        else
        {
            break;
        }
    }
    
    if (programArgsStartAt >= argc)
    {
        usage(argv[0]);
    }
    else
    {
        char *executable;
        
        if (strchr(argv[programArgsStartAt], '/'))
        {
            executable = isexecfile(argv[programArgsStartAt]) ? strdup(argv[programArgsStartAt]) : NULL;
        }
        else
        {
            executable = which(argv[programArgsStartAt]);
        }
        
        if (executable)
        {
            char **commandArgs = malloc((argc - programArgsStartAt) * sizeof(char**));
            memcpy(commandArgs, argv + programArgsStartAt + 1, (argc - programArgsStartAt - 1) * sizeof(char**));
            commandArgs[argc - programArgsStartAt - 1] = NULL;
            retVal = sudoprivilege(executable, commandArgs, icon, prompt);
            free(commandArgs);
            free(executable);
        }
        else
        {
            fprintf(stderr, "Unable to find %s\n", argv[programArgsStartAt]);
            usage(argv[0]);
        }
    }
    
    if (prompt) {
        free(prompt);
    }
    
    [pool release];
    return retVal;
}

int useCocos(int argc, char *argv[], excutecallback callback)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	int retVal = 1;
	int programArgsStartAt = 0;
	char *icon = NULL;
	char *prompt = NULL;
    
	for (; programArgsStartAt < argc; programArgsStartAt++)
	{
		if (!strncmp("--icon=", argv[programArgsStartAt], 7))
		{
			icon = argv[programArgsStartAt] + 7;
		}
		else if (!strncmp("--prompt=", argv[programArgsStartAt], 9))
		{
			prompt = argv[programArgsStartAt] + 9;
			size_t promptLen = strlen(prompt);
			char *newPrompt = malloc(sizeof(char) * (promptLen + 2));
			strcpy(newPrompt, prompt);
			newPrompt[promptLen] = '\n';
			newPrompt[promptLen + 1] = '\n';
			newPrompt[promptLen + 2] = '\0';
			prompt = newPrompt;
		}
		else
		{
			break;
		}
	}
    
	if (programArgsStartAt >= argc)
	{
		usage(argv[0]);
	}
	else
	{
		char *executable;
        
		if (strchr(argv[programArgsStartAt], '/'))
		{
			executable = isexecfile(argv[programArgsStartAt]) ? strdup(argv[programArgsStartAt]) : NULL;
		}
		else
		{
			executable = which(argv[programArgsStartAt]);
		}
        
		if (executable)
		{
			char **commandArgs = malloc((argc - programArgsStartAt) * sizeof(char**));
			memcpy(commandArgs, argv + programArgsStartAt + 1, (argc - programArgsStartAt - 1) * sizeof(char**));
			commandArgs[argc - programArgsStartAt - 1] = NULL;
			retVal = cocoasudo(executable, commandArgs, icon, prompt, callback);
			free(commandArgs);
			free(executable);
		}
		else
		{
			fprintf(stderr, "Unable to find %s\n", argv[programArgsStartAt]);
			usage(argv[0]);
		}
	}
    
	if (prompt) {
		free(prompt);
	}
	
	[pool release];
	return retVal;
}

/*测试用例*/
int testMain(){
    
    char *(a[5]) = {"--prompt='1233'","rm","-a","-i","on"};
    int retvalue = useCocos(5, a, NULL);
    if (retvalue == 0) {
        printf("success\n");
    }
    else{
        printf("failed\n");
    }
    return retvalue;
}
