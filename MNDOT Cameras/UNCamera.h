//
//  UNCamera.h
//  MNDOT Cameras
//
//  Created by Rory Lonergan on 2/7/14.
//  Copyright (c) 2014 UGUF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNCamera : NSObject

- (instancetype)initWithDisplayName:(NSString *)displayName
                                url:(NSURL *)url;

@property (nonatomic, copy, readonly) NSString *displayName;
@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy) UIImage *image;

@end
