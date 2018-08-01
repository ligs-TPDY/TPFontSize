//
//  AdjustmentFontSizeView.h
//  qfxtaoguwang
//
//  Created by carnet on 2018/6/12.
//  Copyright © 2018年 qfx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backForSelectTital)(NSInteger index);

@interface AdjustmentFontSizeView : UIView
+ (AdjustmentFontSizeView *)AdjustmentFontSize:(UIView *)fatherView heightTop:(NSInteger)height;

- (void)showView;

@property (nonatomic,strong) backForSelectTital callback;

@end

@interface AdFontSizeView : UIView;

@property (nonatomic,strong) backForSelectTital callback;

@end
