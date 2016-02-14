//
//  ShareCenter.m
//  EasyShare
//
//  Created by ileo on 16/2/2.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import "ShareCenter.h"

@interface ShareCenter()

@property (nonatomic, copy) NSArray *handlers;

@end

@implementation ShareCenter

+(instancetype)sharedInstance{
    static id sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (id)copyWithZone:(NSZone*)zone{
    return self;
}

-(void)configHandlers:(NSArray *)handlers{
    self.handlers = handlers;
}

-(BOOL)handleOpenURL:(NSURL *)url{

    __block BOOL isHandle = NO;
    [self.handlers enumerateObjectsUsingBlock:^(id<ShareHandle>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([url.absoluteString hasPrefix:[obj handleURLPrefix]]) {
            isHandle = [obj handleOpenURL:url];
            *stop = YES;
        }
    }];
    return isHandle;
}

-(void)shareURL:(ShareURLModel *)model withPlatform:(Share_Platform)platform{
    [self.handlers enumerateObjectsUsingBlock:^(id<ShareHandle>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj handlePlatforms] containsObject:@(platform)]) {
            [obj shareURL:model withPlatform:platform];
            *stop = YES;
        }
    }];
}

@end

