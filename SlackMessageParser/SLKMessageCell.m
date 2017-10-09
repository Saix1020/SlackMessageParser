//
//  SLKMessageCell3.m
//  SLKMessageDemo
//
//  Created by saix on 2017/9/26.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKMessageCell.h"

#define kHPadding 8
#define kVPadding 6

#define kHButtonWidth 42
#define kNameLabelHeight 18

@implementation SLKMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsAsync:(BOOL)isAsync
{
    if (_isAsync == isAsync) {
        return;
    }
    [self.componentView removeFromSuperview];
    _componentView = nil;
    
    _isAsync = isAsync;
}


+(CGFloat)containerWidth
{
    return [UIScreen mainScreen].bounds.size.width - kHPadding - kHButtonWidth - kHPadding - kHPadding;
}

+(CGFloat)heightOffset
{
    return kHPadding + kVPadding + kNameLabelHeight;
}

-(UIButton*)avatar
{
    if (!_avatar) {
        _avatar = [[UIButton alloc] initWithFrame:CGRectMake(kHPadding, kHPadding, kHButtonWidth, kHButtonWidth)];
        [self.contentView addSubview:_avatar];
        [_avatar setImage:[UIImage imageNamed:@"ic_launcher"] forState:UIControlStateNormal];
    }
    
    return _avatar;
}

-(UILabel*)nameDateLabel
{
    if (!_nameDateLabel) {
        _nameDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameDateLabel.font = [UIFont systemFontOfSize:15.f];
        NSMutableAttributedString* attrStr = [NSMutableAttributedString new];
        NSAttributedString* name = [[NSAttributedString alloc] initWithString:@"Sai Xu" attributes:@{
                                                                                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:16.f]
                                                                                                     }];
        NSAttributedString* date = [[NSAttributedString alloc] initWithString:@"  5:30PM" attributes:@{
                                                                                                       NSFontAttributeName : [UIFont systemFontOfSize:13.f],
                                                                                                       NSForegroundColorAttributeName : [UIColor lightGrayColor]
                                                                                                       }];
        [attrStr appendAttributedString:name];
        [attrStr appendAttributedString:date];
        _nameDateLabel.attributedText = attrStr;
        
        [self.contentView addSubview:_nameDateLabel];
        
    }
    
    return _nameDateLabel;
}

-(SLKMessageView*)componentView
{
    if (!_componentView) {
        
        if (self.isAsync) {
            _componentView = [[SLKMessageAsyncView alloc] init];

        }
        else {
            _componentView = [[SLKMessageView alloc] init];
        }
        _componentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_componentView];
    }
    
    return _componentView;
}

-(void)setComponent:(SLKMessageComponent *)component
{
    [self.componentView setComponent:component];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nameDateLabel.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame)+kHPadding, self.avatar.frame.origin.y, self.contentView.frame.size.width-(CGRectGetMaxX(self.avatar.frame)+kHPadding)-kHPadding, kNameLabelHeight);

    self.componentView.frame = CGRectMake(self.nameDateLabel.frame.origin.x, CGRectGetMaxY(self.nameDateLabel.frame)+kVPadding, self.nameDateLabel.frame.size.width, self.componentView.component.frame.size.height);

}

@end
