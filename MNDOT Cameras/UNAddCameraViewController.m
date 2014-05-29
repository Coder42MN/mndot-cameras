//
//  UNAddCameraViewController.m
//  MNDOT Cameras
//
//  Created by Rory Lonergan on 3/4/14.
//  Copyright (c) 2014 UGUF. All rights reserved.
//

#import "UNAddCameraViewController.h"

@interface UNAddCameraViewController ()

@end

@implementation UNAddCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.dot.state.mn.us/tmc/trafficinfo/cameras_map.html"]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    NSLog(@"save");
    NSString *cameraName = self.cameraName.text;
    cameraName = [cameraName uppercaseString];
    NSLog(@"User input: (%@)", self.cameraName.text);
    NSNotification *notification = [NSNotification notificationWithName:@"addCamera"
                                                                 object:nil
                                                               userInfo:@{@"cameraName": cameraName}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
