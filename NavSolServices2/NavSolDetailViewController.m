//
//  NavSolDetailViewController.m
//  NavSolServices2
//
//  Created by ESD Developer on 2/21/13.
//  Copyright (c) 2013 Navigation Solutions. All rights reserved.
//

#import "NavSolDetailViewController.h"

@interface NavSolDetailViewController ()
- (void)configureView;
@end

@implementation NavSolDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(NavSolService*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
    
    // Update the view.
    [self configureView];
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem && detailsTextField) {
        serviceTextField.text = [[_detailItem buildUrl] path];
        if([[_detailItem RESTmethod] isEqualToString:@"POST"] || [[_detailItem RESTmethod] isEqualToString:@"PUT"])
        {
            NSData *tempData = [NSJSONSerialization dataWithJSONObject:[_detailItem data] options:NSJSONWritingPrettyPrinted error:NULL];
            detailsTextField.text = [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
        }
        else
        {
            detailsTextField.text = [_detailItem data];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateTextView) name:@"serviceCallFinished" object:NULL];
    
    [self configureView];
}

- (void) populateTextView
{
    [progressIndicator stopAnimating];
    NSError *e;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[[NavSolServicesManager instance] recievedData] options:NSJSONReadingMutableContainers error:&e];

    if(e){
        NSLog(@"Error: %@", e);
        detailsTextField.text = [[NSString alloc] initWithData:[[NavSolServicesManager instance] recievedData] encoding:NSUTF8StringEncoding];
    } else {
        detailsTextField.text = [NSString stringWithFormat:@"%@", jsonData];
        serviceTextField.text = [_detailItem name];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
- (IBAction)goButtonPushed:(UIButton *)sender {
    [progressIndicator startAnimating];
    [NavSolServicesManager CallService:_detailItem];
}
@end
