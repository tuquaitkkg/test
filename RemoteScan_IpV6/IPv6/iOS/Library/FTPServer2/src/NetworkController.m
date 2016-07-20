//
//  networkController.m
//  DiddyDJ
//
//  Created by Richard Dearlove on 21/10/2008.
//  Copyright 2008 DiddySoft. All rights reserved.
//

#import "NetworkController.h"

@implementation  NetworkController



+ (BOOL) connectedToNetwork

{
	
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);	
	CFRelease(defaultRouteReachability);
	
	SCNetworkReachabilityFlags flags;
	
	BOOL mysrvRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	if (!mysrvRetrieveFlags) 
	{
		printf("Error. Could not recover network reachability flags\n");
		return 0;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	
	return (isReachable && !needsConnection) ? YES : NO;
}


@end
