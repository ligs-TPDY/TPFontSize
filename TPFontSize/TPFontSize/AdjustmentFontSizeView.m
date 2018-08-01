//
//  AdjustmentFontSizeView.m
//  qfxtaoguwang
//
//  Created by carnet on 2018/6/12.
//  Copyright © 2018年 qfx. All rights reserved.
//

#import "AdjustmentFontSizeView.h"
#import "Masonry.h"
static NSInteger width = 200;
static NSInteger widthRight = 80;
static NSInteger height = 85;
static NSInteger aniWidthRight = 100;

@interface AdjustmentFontSizeView()
@property (nonatomic,assign) NSInteger heightTop;
@property (nonatomic,strong) AdFontSizeView *fontSizeView;
@end

@implementation AdjustmentFontSizeView
+ (AdjustmentFontSizeView *)AdjustmentFontSize:(UIView *)fatherView heightTop:(NSInteger)heightTop;
{
    AdjustmentFontSizeView *view = [[AdjustmentFontSizeView alloc]init];
    [fatherView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fatherView).offset(heightTop);
        make.left.right.bottom.mas_equalTo(fatherView);
    }];
    view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    view.hidden = YES;
    view.heightTop = heightTop;
    
    [view layoutUI];
    return view;
}
- (void)layoutUI
{
    _fontSizeView = [[AdFontSizeView alloc]init];
    [self addSubview:_fontSizeView];
    [_fontSizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    _fontSizeView.backgroundColor = [UIColor clearColor];
    
    __weak typeof(self) weakSelf = self;
    [_fontSizeView setCallback:^(NSInteger index) {
        if (weakSelf.callback) {
            weakSelf.callback(index);
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showView)];
    [self addGestureRecognizer:tap];
}
- (void)showView
{
    self.hidden = !self.hidden;
    if (!self.hidden) {
        [self layerKeyFrameAnimation];
    }
}
//动画
- (void)animate
{
    UIView *view = self.superview;
    [view setNeedsUpdateConstraints];
    [view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [view layoutIfNeeded];
    }];
}
//关键帧动画
-(void)layerKeyFrameAnimation
{
    //画一个path
    NSInteger pathY = _heightTop - [[UIApplication sharedApplication] statusBarFrame].size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width+width, pathY)];
//    [path addLineToPoint:CGPointMake(width+20, pathY)];
//    [path addLineToPoint:CGPointMake(width, pathY)];
//    [path addLineToPoint:CGPointMake(width+15, pathY)];
//    [path addLineToPoint:CGPointMake(width, pathY)];
//    [path addLineToPoint:CGPointMake(width+5, pathY)];
    [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width-aniWidthRight, pathY)];
    
    //变动的属性,keyPath后面跟的属性是CALayer的属性
    CAKeyframeAnimation *keyFA = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //动画路径
    keyFA.path = path.CGPath;
    //动画总时间
    keyFA.duration = 0.5f;
    //重复次数，小于0无限重复
    keyFA.repeatCount = 1;
    
    /*
     这个属性用以指定时间函数，类似于运动的加速度
     kCAMediaTimingFunctionLinear//线性
     kCAMediaTimingFunctionEaseIn//淡入
     kCAMediaTimingFunctionEaseOut//淡出
     kCAMediaTimingFunctionEaseInEaseOut//淡入淡出
     kCAMediaTimingFunctionDefault//默认
     */
    keyFA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    /*
     fillMode的作用就是决定当前对象过了非active时间段的行为. 比如动画开始之前,动画结束之后。如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用.
     
     下面来讲各个fillMode的意义
     kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
     kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
     kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
     kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
     //添加动画
     */
    keyFA.fillMode = kCAFillModeForwards;
    
    /*
     在关键帧动画中还有一个非常重要的参数,那便是calculationMode,计算模式.该属性决定了物体在每个子路径下是跳着走还是匀速走，跟timeFunctions属性有点类似
     其主要针对的是每一帧的内容为一个座标点的情况,也就是对anchorPoint 和 position 进行的动画.当在平面座标系中有多个离散的点的时候,可以是离散的,也可以直线相连后进行插值计算,也可以使用圆滑的曲线将他们相连后进行插值计算. calculationMode目前提供如下几种模式
     
     kCAAnimationLinear calculationMode的默认值,表示当关键帧为座标点的时候,关键帧之间直接直线相连进行插值计算;
     kCAAnimationDiscrete 离散的,就是不进行插值计算,所有关键帧直接逐个进行显示;
     kCAAnimationPaced 使得动画均匀进行,而不是按keyTimes设置的或者按关键帧平分时间,此时keyTimes和timingFunctions无效;
     kCAAnimationCubic 对关键帧为座标点的关键帧进行圆滑曲线相连后插值计算,对于曲线的形状还可以通过tensionValues,continuityValues,biasValues来进行调整自定义,这里的数学原理是Kochanek–Bartels spline,这里的主要目的是使得运行的轨迹变得圆滑;
     kCAAnimationCubicPaced 看这个名字就知道和kCAAnimationCubic有一定联系,其实就是在kCAAnimationCubic的基础上使得动画运行变得均匀,就是系统时间内运动的距离相同,此时keyTimes以及timingFunctions也是无效的.
     */
    keyFA.calculationMode = kCAAnimationPaced;
    
    //旋转的模式,auto就是沿着切线方向动，autoReverse就是转180度沿着切线动
    keyFA.rotationMode = kCAAnimationLinear;
    
    //结束后是否移除动画
    keyFA.removedOnCompletion = NO;
    
    //添加动画
    [self.fontSizeView.layer addAnimation:keyFA forKey:@""];
}

@end


@interface AdFontSizeView()
@end
@implementation AdFontSizeView
- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *view = [[UIView alloc]init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-15);
            make.right.mas_equalTo(-15);
        }];
        view.backgroundColor = [UIColor whiteColor];
        
        UISegmentedControl *se = [[UISegmentedControl alloc]initWithItems:@[@"小",@"中",@"大"]];
        [view addSubview:se];
        [se mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(height/3);
        }];
        se.tintColor = [UIColor orangeColor];
        UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [se setTitleTextAttributes:attributes forState:UIControlStateSelected];
        ///设置默认值
        NSInteger index = 0;
        se.selectedSegmentIndex = index;
        [se addTarget:self action:@selector(selectTital:) forControlEvents:UIControlEventValueChanged];
        
        UILabel *label0 = [[UILabel alloc]init];
        [view addSubview:label0];
        [label0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(se);
            make.bottom.mas_equalTo(se.mas_top).offset(-5);
            make.top.mas_equalTo(view).offset(5);
            make.width.mas_equalTo(height/3);
        }];
        label0.backgroundColor = [UIColor lightGrayColor];
        label0.text = @"T";
        label0.textAlignment = NSTextAlignmentCenter;
        label0.layer.cornerRadius = 5.0;
        label0.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc]init];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label0.mas_right).offset(5);
            make.right.mas_equalTo(se);
            make.bottom.mas_equalTo(se.mas_top);
            make.top.mas_equalTo(view);
        }];
        label.text = @"字体大小";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor lightGrayColor];
    }
    return self;
}
- (void)selectTital:(UISegmentedControl *)sender
{
    ///此处可以缓存字体大小
    if (_callback) {
        _callback(sender.selectedSegmentIndex);
    }
}
- (void)drawRect:(CGRect)rect
{
    UIColor *color = [UIColor whiteColor];
    [color set];

    UIBezierPath *path = [UIBezierPath bezierPath];
    [self setPro:path];
    [path moveToPoint:CGPointMake(width-widthRight,5)];
    [path addLineToPoint:CGPointMake(width-widthRight+5, 10)];
    [path addLineToPoint:CGPointMake(width-15, 10)];
    [path addLineToPoint:CGPointMake(width-15, height-10)];
    [path addLineToPoint:CGPointMake(10,height-10)];
    [path addLineToPoint:CGPointMake(10, 10)];
    [path addLineToPoint:CGPointMake(width-widthRight-5,10)];
    [path closePath];

    [path stroke];
}
- (void)setPro:(UIBezierPath *)path
{
    ///线宽
    path.lineWidth = 10.0;
    //线条拐角
    path.lineCapStyle = kCGLineCapRound;
    //终点处理
    path.lineJoinStyle = kCGLineCapRound;
}

@end
