//
//  SLKMessageAsyncLayer.h
//  SLKMessageParser
//
//  Created by saix on 2017/10/9.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SLKMessageComponent.h"

@interface SLKMessageAsyncLayer : CALayer
@property (nonatomic, strong) SLKMessageComponent* messageComponent;

@end
