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
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    baseServicesUrl = [NavSolServicesManager instance].baseServicesUrl;

    // creating parallel arrays for services and operations
    NSArray *serviceNames = [[NSArray alloc] initWithObjects:
                             @"TokenManagement",
                             @"Search/Pois",
                             nil];

    NSArray *serviceOperations = [[NSArray alloc] initWithObjects:
                                  [[NSArray alloc] initWithObjects:
                                   [[NavSolService alloc] initWithUrl:@"/security/tokenmanagement.svc/createtoken"
                                                             withData:[NSString stringWithFormat:@"?tenantGuid=%@&applicationGuid=%@",
                                                                       [NavSolServicesManager instance].tenantGuid, [NavSolServicesManager instance].applicationGuid ]
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"CreateToken"],
                                   [[NavSolService alloc] initWithUrl:@"/security/tokenmanagement.svc/gettokenbyguid"
                                                             withData:[NSString stringWithFormat:@"?tokenguid=%@", [NavSolServicesManager instance].tokenGuid]
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"GetTokenByGuid"],
                                   nil],
                                  [[NSArray alloc] initWithObjects:
                                   [[NavSolService alloc] initWithUrl:@"/search/pois.svc/"
                                                             withData:@"?phrase=starbucks%20dallas,tx"
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"Search"],
                                   [[NavSolService alloc] initWithUrl:@"/search/pois.svc/getallsearchcategories"
                                                             withData:NULL
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"GetAllSearchCategories"],
                                   [[NavSolService alloc] initWithUrl:@"/search/pois.svc/getairport"
                                                             withData:@"?airportCode=LAX"
                                                             isSecure:false
                                                           RESTmethod:@"GET"
                                                             withName:@"GetAirport"],
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
    return [[services objectForKey:[[services allKeys] objectAtIndex:section]] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *serviceName = [[services allKeys] objectAtIndex:section];
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

    NSArray *service = [services objectForKey:[[services allKeys] objectAtIndex:indexPath.section]];
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
    NSArray *service = [services objectForKey:[[services allKeys] objectAtIndex:indexPath.section]];
    NavSolService *operation = [service objectAtIndex:indexPath.row];
    
    [self.detailViewController setDetailItem: operation];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
