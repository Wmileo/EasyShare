//
//  ShareModel.h
//  EasyShare
//
//  Created by ileo on 16/2/4.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareURLModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *imageURL;//图片不能过大 否则会引起分享不成功
@property (nonatomic, strong) NSString *shareURL;

@end
