//
//  networkController.h
//  DiddyDJ
//
//  Created by Richard Dearlove on 21/10/2008.
//  Copyright 2008 DiddySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>


@interface NetworkController : NSObject {

}
+ (BOOL) connectedToNetwork;
@end
