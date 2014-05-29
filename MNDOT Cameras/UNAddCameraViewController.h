//
//  UNAddCameraViewController.h
//  MNDOT Cameras
//
//  Created by Rory Lonergan on 3/4/14.
//  Copyright (c) 2014 UGUF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNAddCameraViewController : UIViewController

@property IBOutlet UITextField *cameraName;
@property IBOutlet UIWebView *webView;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
