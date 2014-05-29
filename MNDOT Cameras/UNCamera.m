//
//  UNCamera.m
//  MNDOT Cameras
//
//  Created by Rory Lonergan on 2/7/14.
//  Copyright (c) 2014 UGUF. All rights reserved.
//

#import "UNCamera.h"

@implementation UNCamera

- (instancetype)init {
    NSException *exception = [NSException exceptionWithName:@"DesignatedInitializer"
                                                     reason:@"custom init method must be used"
                                                   userInfo:nil];
    @throw exception;
}

- (instancetype)initWithDisplayName:(NSString *)displayName
                                url:(NSURL *)url {
    if (!displayName || [displayName length] < 1) {
        NSLog(@"displayName is nil or zero length");
        return nil;
    }
    else if (!url) {
        NSLog(@"url is nil");
        return nil;
    }

    self = [super init];
    if (self) {
        _displayName = [displayName copy];
        _url = [url copy];
    }

    return self;
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;

    // objects
    result = prime * result + [_displayName hash];
    result = prime * result + [_url hash];

    return result;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }

    UNCamera *other = object;
    if ([self hash] != [other hash]) {
        return NO;
    }
    if (![_displayName isEqualToString:other.displayName]) {
        return NO;
    }
    if (![_url isEqual:other.url]) {
        return NO;
    }

    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.displayName
                  forKey:@"displayName"];
    [aCoder encodeObject:self.url
                  forKey:@"url"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSString *displayName = [aDecoder decodeObjectOfClass:[NSString class]
                                                   forKey:@"displayName"];
    NSURL *url = [aDecoder decodeObjectOfClass:[NSURL class]
                                        forKey:@"url"];
    return [[UNCamera alloc] initWithDisplayName:displayName
                                             url:url];
}

@end
