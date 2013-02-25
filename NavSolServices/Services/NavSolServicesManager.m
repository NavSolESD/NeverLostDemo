//
//  NavSolServicesManager.m
//  NavSol Services
//
//  Created by ESD Developer on 2/19/13.
//  Copyright (c) 2013 Navigation Solutions. All rights reserved.
//

#import "NavSolServicesManager.h"

@implementation NavSolServicesManager
@synthesize tokenGuid;
@synthesize recievedData;
@synthesize tenantGuid;
@synthesize applicationGuid;
@synthesize baseServicesUrl;

- (id)init
{
    self = [super init];
    if (self)
    {
        baseServicesUrl = @"dev-services.navsol.net";
        tenantGuid = @"9F4E1CAD-83F0-44F3-AF33-398F703768A6";
        applicationGuid = @"141b2bdc-2840-4f66-a051-89bdb027958d";
    }

    return self;
}

// singleton
static NavSolServicesManager *myInstance;
+ (NavSolServicesManager*) instance
{
    if(myInstance == NULL)
    {
        myInstance = [[NavSolServicesManager alloc] init];
    }
    return myInstance;
}

// class methods
+ (void) CallService:(NavSolService *)service
{
    // if this is a POST or PUT, we need to serialize the data
    if([service.RESTmethod isEqualToString:@"POST"] || [service.RESTmethod isEqualToString:@"PUT"])
    {
        // serialize our data object to JSON
        NSData* data = [NSJSONSerialization dataWithJSONObject:service.data options:0 error:nil];

        [NavSolServicesManager CallService:[service buildUrl] method:service.RESTmethod data:nil bytes:data];
    }
    else
    {
        // this a is a GET or DELETE call - the data is included in the url query string already
        [NavSolServicesManager CallService:[service buildUrl] method:service.RESTmethod data:nil bytes:nil];
    }    
}

+ (void) CallService:(NSURL*)url method:(NSString *)method_type data:(NSString *)json_data bytes:(NSData *)bytes_array
{
    // create the request object
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    // set our header values
    [request setHTTPMethod: method_type];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];

    // if we have a token guid, put it in the header
    // a token is required for almost every service call, except for GetToken
    if ([NavSolServicesManager instance].tokenGuid != NULL )
    {
        [request setValue:[NavSolServicesManager instance].tokenGuid forHTTPHeaderField:@"Authorization"];
    }

    // if this service call is either a POST or PUT type, then
    // this message will use either the json_data OR the bytes_array, but not both.
    // if the bytes_array is populated, we just use that data. Otherwise, encode the
    // json as utf-8 and send the raw data from it
    if([method_type isEqualToString:@"POST"] || [method_type isEqualToString:@"PUT"])
    {
        if(bytes_array == NULL && json_data != NULL)
        {
            bytes_array = [json_data dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        [request setHTTPBody:bytes_array];
        [request setValue:[NSString stringWithFormat: @"%d", [bytes_array length]] forHTTPHeaderField:@"content-length"];
    }

    // start a connection
    NSLog(@"Calling service with url: %@", [url absoluteString]);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:[NavSolServicesManager instance]];
    
    if(connection) // the connection successfully opened
    {
        // build a data object to recieve the response
        [NavSolServicesManager instance].recievedData = [NSMutableData data];
    }
}

// - NSURLConnection Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // reset the data in case of redirects
    [recievedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // build up our data object
    [recievedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Success");

    NSString *requestUrl = [[connection.currentRequest URL] absoluteString];
    // check the url to see if it was a "CreateToken" call or a "SignIn" call
    NSRange createTokenRange = [requestUrl rangeOfString:@"createtoken" options:NSCaseInsensitiveSearch];
    NSRange signinRange = [requestUrl rangeOfString:@"signin" options:NSCaseInsensitiveSearch];
    // if it was a "CreateToken" call, grab the token guid from the response and assign it to the instance's
    // tokenGuid
    if( createTokenRange.location != NSNotFound){
        // attempt to deserialize the response data
        NSError *e = NULL;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:recievedData options:NSJSONReadingMutableLeaves error:&e];

        if(e)
        {
            // deserialize error - this most likely means a 500 error - either the server is down or there is a permissions error
            NSLog(@"error: %@", e);
        }
        else
        {
            // otherwise, grab the token guid data
            NSLog(@"%@", [json objectForKey:@"Data"]);
            tokenGuid = [json objectForKey:@"Data"];
        }
    }
    else if (signinRange.location != NSNotFound) // check if it was a "SignIn" call
    {
        // attempt to deserialize the response data
        NSError *e = NULL;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:recievedData options:NSJSONReadingMutableLeaves error:&e];

        if(e)
        {
            // deserialize error - this most likely means a 500 error - either the server is down or there is a permissions error
            NSLog(@"error: %@", e);
        }
        else
        {
            // otherwise grab the token guid data
            NSLog(@"%@", [[[json objectForKey:@"Data"] objectForKey:@"Token"] objectForKey:@"Guid"]);
            tokenGuid = [[[json objectForKey:@"Data"] objectForKey:@"Token"] objectForKey:@"Guid"];
        }
    }

    // post a notification for the caller to consume
    [[NSNotificationCenter defaultCenter] postNotificationName:@"serviceCallFinished" object:NULL];
}

@end
