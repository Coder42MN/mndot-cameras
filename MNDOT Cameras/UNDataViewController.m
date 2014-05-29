//
//  UNDataViewController.m
//  MNDOT Cameras
//
//  Created by Rory Lonergan on 2/7/14.
//  Copyright (c) 2014 UGUF. All rights reserved.
//

#import "UNDataViewController.h"

#import "UNCamera.h"
#import "UNAddCameraViewController.h"

@implementation UNDataViewController {
    dispatch_queue_t _dataQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataLabel = nil;
	// Do any additional setup after loading the view, typically from a nib.

    NSString *label = [NSString stringWithFormat:@"net.uguf.UNDataViewController.dataQueue.%p", self];
    _dataQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleShouldRefreshNotification:)
                                                 name:@"shouldRefresh"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataLabel.text = @"unknown";

    if (_dataObject) {
        _dataLabel.text = _dataObject.displayName;
        _imageView.image = _dataObject.image;
    }

    [self reloadImage];

}

- (void)handleShouldRefreshNotification:(NSNotification *)notification {
    [self reloadImage];
}

- (void)reloadImage {
    if (!_dataQueue) {
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(_dataQueue, ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"strongSelf is nil");
            return;
        }

        NSData *data = [NSData dataWithContentsOfURL:strongSelf->_dataObject.url];
        if (!data) {
            NSLog(@"unable to load data from URL: (%@)", strongSelf->_dataObject.url);
            return;
        }

        UIImage *image = [[UIImage alloc] initWithData:data];
        if (!image) {
            NSLog(@"unable to convert data from url: (%@) to image", strongSelf->_dataObject.url);
            return;
        }

        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) {
                NSLog(@"strongSelf is nil");
                return;
            }

            strongSelf->_dataObject.image = image;
            strongSelf->_imageView.image = _dataObject.image;
        });
    });
}

- (IBAction)addCamera:(id)sender {
    NSLog(@"button");

    UNAddCameraViewController *addCameraView = [[UNAddCameraViewController alloc] init];
    [self presentViewController:addCameraView
                       animated:YES
                     completion:^{
                         NSLog(@"done");
                     }];
}

- (IBAction)deleteCamera:(id)sender {
    NSNotification *notification = [NSNotification notificationWithName:@"deleteCamera"
                                                                 object:nil
                                                               userInfo:@{@"camera": _dataObject}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)onCancel:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh noes!"
                                                    message:@"I see you didn't want to press the button"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Properties

- (void)setDataObject:(UNCamera *)dataObject {
    _dataObject = dataObject;
    if (_dataObject) {
        [self reloadImage];
    }
    else {
        _imageView = nil;
    }
}

@end
