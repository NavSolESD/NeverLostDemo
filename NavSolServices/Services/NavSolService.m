//
//  NavSolService.m
//  NavSolServices2
//
//  Created by ESD Developer on 2/21/13.
//  Copyright (c) 2013 Navigation Solutions. All rights reserved.
//

#import "NavSolService.h"

@implementation NavSolService
@synthesize relativeUrl;
@synthesize data;
@synthesize isSecure;
@synthesize RESTmethod;
@synthesize name;

- (id) initWithUrl:(NSString *)url withData:(id)dataString isSecure:(BOOL)security RESTmethod:(NSString*)method withName:(NSString*)serviceName
{
    self = [super init];
    if (self)
    {
        relativeUrl = url;
        data = dataString;
        isSecure = security;
        RESTmethod = method;
        name = serviceName;
    }

    return self;
}

-(NSURL*) buildUrl
{
    NSURL *url = NULL;
    if ([RESTmethod isEqualToString:@"POST"] || [RESTmethod isEqualToString:@"PUT"])
    {
        // POST/PUT doesn't include the data in the query string
        url = [[NSURL alloc] initWithString:
               [NSString stringWithFormat:@"%@%@%@",
                isSecure ? @"https://" : @"http://",
                [NavSolServicesManager instance].baseServicesUrl,
                relativeUrl]];
    }
    else
    {
        // GET/DELETE includes the data in the query string
        url = [[NSURL alloc] initWithString:
               [NSString stringWithFormat:@"%@%@%@%@",
                isSecure ? @"https://" : @"http://",
                [NavSolServicesManager instance].baseServicesUrl,
                relativeUrl,
                data]];
    }

    return url;
}

@end
