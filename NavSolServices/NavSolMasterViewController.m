//
//  NavSolMasterViewController.m
//  NavSolServices2
//
//  Created by ESD Developer on 2/21/13.
//  Copyright (c) 2013 Navigation Solutions. All rights reserved.
//

#import "NavSolMasterViewController.h"
#import "NavSolDetailViewController.h"

@interface NavSolMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation NavSolMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Navigation Solutions", @"Navigation Solutions");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    baseServicesUrl = [NavSolServicesManager instance].baseServicesUrl;

    // creating parallel arrays for services and operations
    serviceNames = [[NSArray alloc] initWithObjects:
                             @"Security/TokenManagement",
                             @"Security/Registration",
                             @"Security/PasswordManagement",
                             @"Security/Authentication",
                             @"Search/Pois",
                             @"Search/Events",
                             @"Search/PopularLocations",
                             @"TripPlanning/CodeManagement",
                             @"TripPlanning/TripManagement",
                             @"TripPlanning/PoiManagement",
                             @"Member/MemberProperty",
                             nil];

    // a 2d array of all the operations, ordered by service 
    NSArray *serviceOperations = [[NSArray alloc] initWithObjects:
                                  [[NSArray alloc] initWithObjects: // Security/TokenManagement
                                   [[NavSolService alloc] initWithUrl:@"/security/tokenmanagement/createtoken"
                                                             withData:[NSString stringWithFormat:@"?tenantGuid=%@&applicationGuid=%@",
                                                                       [NavSolServicesManager instance].tenantGuid, [NavSolServicesManager instance].applicationGuid ]
                                                             isSecure:true
                                                           RESTmethod:@"GET"
                                                             withName:@"CreateToken"],
                                   [[NavSolService alloc] initWithUrl:@"/security/tokenmanagement/gettokenbyguid"
                                                             withData:[NSString stringWithFormat:@"?tokenguid=%@", @"not-a-guid"]
                                                             isSecure:true
                                                           RESTmethod:@"GET"
                                                             withName:@"GetTokenByGuid"],
                                   nil],
                                  [[NSArray alloc] initWithObjects: // Security/Registration
                                   [[NavSolService alloc] initWithUrl:@"/security/registration/register"
                                                             withData:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"exampleUser", @"examplePassword", @"example@sxsw.com", nil]
                                                                                                  forKeys:[NSArray arrayWithObjects:@"username", @"password", @"emailAddress", nil]]
                                                             isSecure:true
                                                           RESTmethod:@"PUT"
                                                             withName:@"Register"],
                                   [[NavSolService alloc] initWithUrl:@"/security/registration/isvalidemailaddressusername"
                                                             withData:[NSString stringWithFormat:@"?emailaddress=%@&username=%@",@"uniqueExample@sxsw.com",@"SXSW"]
                                                             isSecure:true
                                                           RESTmethod:@"GET"
                                                             withName:@"IsValidEmailAddressUsername"],
                                   nil],
                                  [[NSArray alloc] initWithObjects: // Security/PasswordManagement
                                   [[NavSolService alloc] initWithUrl:@"/security/passwordmanagement/changepassword"
                                                             withData:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"examplePassword", @"newExamplePassword", nil]
                                                                                                  forKeys:[NSArray arrayWithObjects:@"password", @"newPassword", nil]]
                                                             isSecure:true
                                                           RESTmethod:@"POST"
                                                             withName:@"ChangePassword"],
                                   nil],
                                  [[NSArray alloc] initWithObjects: // Security/Authentication
                                   [[NavSolService alloc] initWithUrl:@"/security/authentication/signin"
                                                             withData:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"exampleUser", @"examplePassword", nil]
                                                                                                  forKeys:[NSArray arrayWithObjects:@"username", @"password", nil]]
                                                             isSecure:true
                                                           RESTmethod:@"POST"
                                                             withName:@"SignIn"],
                                   [[NavSolService alloc] initWithUrl:@"/security/authentication/signout"
                                                             withData:[[NSDictionary alloc] init]
                                                             isSecure:true
                                                           RESTmethod:@"POST"
                                                             withName:@"SignOut"],
                                   nil],
                                  [[NSArray alloc] initWithObjects: // Search/Pois
                                   [[NavSolService alloc] initWithUrl:@"/search/pois/"
                                                             withData:@"?phrase=starbucks%20dallas,tx"
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"Search"],
                                   [[NavSolService alloc] initWithUrl:@"/search/pois/getallsearchcategories"
                                                             withData:@""
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"GetAllSearchCategories"],
                                   [[NavSolService alloc] initWithUrl:@"/search/pois/getairport"
                                                             withData:@"?code=LAX"
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"GetAirport"],
                                   nil],
                                  [[NSArray alloc] initWithObjects: // Search/Events
                                   [[NavSolService alloc] initWithUrl:@"/search/events/"
                                                             withData:@"?categoryId=8427"
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"Search"],
                                   [[NavSolService alloc] initWithUrl:@"/search/events/geteventparameters"
                                                             withData:@"?startDate=2012-03-12T12:00:00&endDate=2012-08-12T00:12:00"
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"GetEventParameters"],
                                   [[NavSolService alloc] initWithUrl:@"/search/events/geteventdata"
                                                             withData:@"?eventId=13920"
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"GetEventData"],
                                   nil],
                                  [[NSArray alloc] initWithObjects: // Search/PopularLocations
                                   [[NavSolService alloc] initWithUrl:@"/search/popularlocations/"
                                                             withData:@"?categoryId=5923"
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"Search"],
                                   [[NavSolService alloc] initWithUrl:@"/search/popularlocations/getallpopularlocations"
                                                             withData:@""
                                                             isSecure:true
                                                           RESTmethod:@"GET"
                                                             withName:@"GetAllPopularLocations"],
                                   nil],
                                  [[NSArray alloc] initWithObjects: // TripPlanning/CodeManagement
                                   [[NavSolService alloc] initWithUrl:@"/tripplanning/codemanagement/getalltrips"
                                                             withData:@""
                                                             isSecure:true
                                                           RESTmethod:@"GET"
                                                             withName:@"GetAllTrips"],
                                   [[NavSolService alloc] initWithUrl:@"/tripplanning/codemanagement/getmembercode"
                                                             withData:@""
                                                             isSecure:true
                                                           RESTmethod:@"GET"
                                                             withName:@"GetMemberCode"],
                                   [[NavSolService alloc] initWithUrl:@"/tripplanning/codemanagement/savetrips"
                                                             withData:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"tripName", @"32424", @"pois", nil]
                                                                                                  forKeys:[NSArray arrayWithObjects:@"name", @"id", @"pois", nil]]
                                                             isSecure:true
                                                           RESTmethod:@"POST"
                                                             withName:@"SaveTrips"],
                                   nil],
                                  [[NSArray alloc] initWithObjects: // TripPlanning/TripManagement
                                   [[NavSolService alloc] initWithUrl:@"/tripplanning/tripmanagement/addtrip"
                                                             withData:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"TestTrip", nil]
                                                                                                  forKeys:[NSArray arrayWithObjects:@"name", nil]]
                                                             isSecure:true
                                                           RESTmethod:@"PUT"
                                                             withName:@"AddTrip"],
                                   [[NavSolService alloc] initWithUrl:@"/tripplanning/tripmanagement/removetrip"
                                                             withData:@"?tripid=23422134"
                                                             isSecure:true
                                                           RESTmethod:@"DELETE"
                                                             withName:@"RemoveTrip"],
                                   [[NavSolService alloc] initWithUrl:@"/tripplanning/tripmanagement/renametrip"
                                                             withData:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"23423", @"newTripName", nil]
                                                                                                  forKeys:[NSArray arrayWithObjects:@"tripid", @"name", nil]]
                                                             isSecure:true
                                                           RESTmethod:@"POST"
                                                             withName:@"RenameTrip"],
                                   [[NavSolService alloc] initWithUrl:@"/tripplanning/tripmanagement/setcurrenttrip"
                                                             withData:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"45641", nil]
                                                                                                  forKeys:[NSArray arrayWithObjects:@"tripid", nil]]
                                                             isSecure:true
                                                           RESTmethod:@"POST"
                                                             withName:@"SetCurrentTrip"],
                                   nil],
                                  [[NSArray alloc] initWithObjects: // TripPlanning/PoiManagement
                                   [[NavSolService alloc] initWithUrl:@"/tripplanning/poimanagement/removepoifromtrip"
                                                             withData:@"?tripid=345322&poiid=23256771"
                                                             isSecure:true
                                                           RESTmethod:@"DELETE"
                                                             withName:@"RemovePoiFromTrip"],
                                   [[NavSolService alloc] initWithUrl:@"/tripplanning/poimanagement/addpoitotrip"
                                                             withData:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"poiid", nil]
                                                                                                  forKeys:[NSArray arrayWithObjects:@"23534623", nil] ]
                                                             isSecure:true
                                                           RESTmethod:@"PUT"
                                                             withName:@"AddPoiToTrip"],
                                   nil],
                                  [[NSArray alloc] initWithObjects: // Member/MemberProperty
                                   [[NavSolService alloc] initWithUrl:@"/member/memberproperty/get"
                                                             withData:@"?propertyKey=name"
                                                             isSecure:true
                                                           RESTmethod:@"GET"
                                                             withName:@"Get"],
                                   [[NavSolService alloc] initWithUrl:@"/member/memberproperty/set"
                                                             withData:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"name", @"JohnSmith", nil] forKeys:[NSArray arrayWithObjects:@"propertyKey", @"propertyValue", nil]]
                                                             isSecure:true
                                                           RESTmethod:@"POST"
                                                             withName:@"Set"],
                                   [[NavSolService alloc] initWithUrl:@"/member/memberproperty/remove"
                                                             withData:@"?propertyKey=name"
                                                             isSecure:true
                                                           RESTmethod:@"DELETE"
                                                             withName:@"Remove"],
                                   [[NavSolService alloc] initWithUrl:@"/member/memberproperty/getall"
                                                             withData:@""
                                                             isSecure:true
                                                           RESTmethod:@"GET"
                                                             withName:@"GetAll"],
                                   nil],
                                  nil];
    services = [[NSDictionary alloc] initWithObjects:serviceOperations forKeys:serviceNames];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [services count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[services objectForKey:[serviceNames objectAtIndex:section]] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *serviceName = [serviceNames objectAtIndex:section];
    return serviceName;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }

    NSArray *service = [services objectForKey:[serviceNames objectAtIndex:indexPath.section]];
    cell.textLabel.text = [[service objectAtIndex:indexPath.row] name];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[NavSolDetailViewController alloc] initWithNibName:@"NavSolDetailViewController" bundle:nil];
    }
    NSArray *service = [services objectForKey:[serviceNames objectAtIndex:indexPath.section]];
    NavSolService *operation = [service objectAtIndex:indexPath.row];
    
    [self.detailViewController setDetailItem: operation];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
