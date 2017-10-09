//
//  SLKMessageView.h
//  SLKMessageParser
//
//  Created by saix on 2017/10/9.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLKMessageComponent;

@interface SLKMessageView : UIView
@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) SLKMessageComponent* component;

@property(nonatomic, strong) NSMutableArray* linkRects;
@property(nonatomic, strong) NSMutableArray* codeRects;


-(void)_setComponent:(SLKMessageComponent *)component;
-(void)drawComponet;
@end
