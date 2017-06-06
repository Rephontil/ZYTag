//
//  ZYTagVC.m
//  dajiaochong
//
//  Created by ZhouYong on 2017/4/24.
//  Copyright © 2017年 kidstone. All rights reserved.
//

#import "ZYTagVC.h"
#import "ZYTagView.h"
#import "NSString+ZYString.h"
#import "UITextField+ZYTextField.h"
#import "UIView+ZYCustomDimension.h"
#import "MBProgressHUD+Add.h"

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


#define TagHeight    24 // 标签的高度
#define TagFont      11  //标签字体
#define maxTageNum   3  //标签的最大数目
#define maxTageTextNum   15 //标签的最大字数
#define tagVerticalGap   12 //标签竖直间距
#define tagHorizontalGap 16 //标签水平间距
#define tagMaxWidth  ([NSString calculateSizeWithString:@"这个帖子的最大的长度为十五个字" font:TagFont maxWidth:MAXFLOAT].width + 10) //布局标签时候的最大宽度
#define placeTagInputColor @"333333"

@interface ZYTagVC ()<ZYTextFieldDelegate,ZYTagViewDelegate,UITextFieldDelegate>

/**
 放置上面输入标签的母视图
 */
@property (nonatomic, strong)UIView *tagInputView;

/**
 借来用于弹出键盘，删除标签的
 */
@property (nonatomic, strong)UITextField *placeTextField;

/**
 右上角完成的按钮
 */
@property (nonatomic, strong)UIButton *rightButton;

/**
 输入标签(30号 #999999)
 */
@property (nonatomic, strong)UILabel *placeTipLabel;

/**
 标签的颜色数组(注意,初始化的时候只给了5种颜色,需要更多,请自己调整)
 */
@property (nonatomic, copy)NSArray *colorArr;

/**
 点击“X”按钮的次数(点击标签时候弹出的textfield)[deleteBackwardCount = 1为选中标签高亮,deleteBackwardCount = 2为删除该标签]
 */
@property (nonatomic, assign)NSUInteger deleteBackwardCount;

/**
 存放历史记录的标签文字数组
 */
@property (nonatomic, strong)NSMutableArray *historyTagArray;

/**
 存储标签的信息数组,里面放字典 key:标签的tag value:标签的文字内容
 */
@property (nonatomic, strong)NSMutableArray<NSMutableDictionary *> *tagInfoArray;


@property (nonatomic, strong)UIView *historyTagView;


@end

@implementation ZYTagVC

static NSString * const placeTipText = @"输入标签";

static NSString * const beyondInputTipText = @"可添加标签最多不超过3个";

static NSString * const sameTagWarning = @"不能添加相同的标签";

static NSString * const HISTORY_RECORD = @"HISTORY_RECORD";


- (NSMutableArray *)historyTagArray{
    if (_historyTagArray == nil) {
        _historyTagArray = [NSMutableArray array];
    }return _historyTagArray;
}

- (NSMutableArray<NSMutableDictionary *> *)tagInfoArray{
    if (_tagInfoArray == nil) {
        _tagInfoArray = [NSMutableArray array];
    }return _tagInfoArray;
}

/**
 输入标签的占位文字Label
 
 @return 输入标签
 */
- (UILabel *)placeTipLabel{
    if (_placeTipLabel == nil) {
        CGSize size = [NSString calculateSizeWithString:placeTipText font:TagFont maxWidth:MAXFLOAT];
        _placeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, size.width, size.height)];
        _placeTipLabel.text = placeTipText;
        _placeTipLabel.font = [UIFont systemFontOfSize:TagFont];
        _placeTipLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _placeTipLabel.textAlignment = 0;
    }
    return _placeTipLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self proInit];
}

- (void)proInit{
    [self placeTipLabel];
    
    self.title = @"添加标签";
    self.colorArr = @[@"ffada7",@"6ed8ff",@"ffb993",@"0bff12",@"559933"];
    
    self.tagInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, 120)];
    self.tagInputView.backgroundColor = [UIColor whiteColor];
    [self.tagInputView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginWithTag)]];
    [self.view addSubview:self.tagInputView];
    [self.tagInputView addSubview:self.placeTipLabel];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize rightButtonSize = [NSString calculateSizeWithString:@"完成" font:14 maxWidth:MAXFLOAT];
    rightButton.frame = CGRectMake(0, 0, rightButtonSize.width, 22);
    _rightButton = rightButton;
    rightButton.enabled = NO;
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"dfdfdf"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"ffc107"] forState:UIControlStateSelected];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:2];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    //借来弹出键盘
    self.placeTextField = [[UITextField alloc] initWithFrame:CGRectMake(-10, -10, 3, TagHeight)];
    self.placeTextField.tag = 1000;
    self.placeTextField.backgroundColor = [UIColor clearColor];
    self.placeTextField.delegate = self;
    [self.view addSubview:self.placeTextField];
    
    //常用标签部分
    NSArray *history = [[NSUserDefaults standardUserDefaults] objectForKey:HISTORY_RECORD];
    self.historyTagArray = history.mutableCopy;
    if (self.historyTagArray.count) {
        [self historyModule];
    }
    
        if (self.initialTags.count) {
            for (NSString *key in self.initialTags.allKeys) {
                [self layOutTagWithString:self.initialTags[key]];
            }
        }
}

/**
 新标签的起点坐标
 
 @return 新标签的起点坐标
 */
- (CGPoint)getStartPoint
{
    CGPoint startPoint;
    NSMutableArray *marr = [NSMutableArray array]; //统计当前桌面上面的标签数目
    for (ZYTagView *tagView in self.tagInputView.subviews) {
        if ([tagView isKindOfClass:[ZYTagView class]]) {
            [marr addObject:tagView];
        }
    }
    
    if (marr.count == 0) {  //如果桌面上没有标签
        startPoint = CGPointMake(12, 16);
    }else{
        ZYTagView *temp;
        for (ZYTagView *tagView in marr) {
            temp = (ZYTagView *)marr[0]; //假设第一个标签的tag值最大
            if (temp.tag < tagView.tag) {  //找出tag值最大的标签
                temp = tagView;
            }
        }
        //如果有标签,新的标签的起点为
        startPoint = CGPointMake(temp.right + tagHorizontalGap, temp.top);
    }
    NSLog(@"%@",NSStringFromCGPoint(startPoint));
    return startPoint;
}

/**
 找出最后一个绘制的标签
 
 @return 最后一个标签
 */
- (ZYTagView *)lastTag
{
    NSMutableArray *marr = [NSMutableArray array]; //统计当前桌面上面的标签数目
    for (ZYTagView *tagView in self.tagInputView.subviews) {
        if ([tagView isKindOfClass:[ZYTagView class]]) {
            [marr addObject:tagView];
        }
    }
    ZYTagView *temp;
    for (ZYTagView *tagView in marr) {
        temp = (ZYTagView *)marr[0]; //假设第一个标签的tag值最大
        if (temp.tag < tagView.tag) {  //找出tag值最大的标签
            temp = tagView;
        }
    }
    return temp;
}

/**
 验证最后一个标签是否合法
 
 @return BOOL
 */
- (BOOL)isLastTagLegal
{
    ZYTagView *temp = [self lastTag];
    if ([NSString isZYBlankString:temp.textField.text]) {
        return NO;
    }else{
        return YES;
    }
}

/**
 移除最后一个非法的标签
 */
- (void)removeLastIllegalTag
{
    //如果最后一个标签不合法
    if (![self isLastTagLegal]) {
        [[self lastTag] removeFromSuperview];
    }
}

/**
 移除最后一个标签(不管是否合法)
 */
- (void)removeLastTag
{
    [[self tagArray].lastObject hide];
}


/**
 获取桌面上标签的个数
 
 @return 标签个数
 */
- (NSUInteger)tagCount
{
    return [[self tagArray] count];
}


/**
 获取桌面上的标签
 
 @return 桌面上的标签数组
 */
- (NSMutableArray<ZYTagView *> *)tagArray
{
    NSMutableArray *tagArr = [NSMutableArray array];
    for (ZYTagView *tagView in self.tagInputView.subviews) {
        if ([tagView isKindOfClass:[ZYTagView class]]) {
            [tagArr addObject:tagView];
        }
    }return tagArr;
}


/**
 移除桌面上的所有标签
 */
- (void)removeAllTagsFromTable{
    for (ZYTagView *tagView in [self tagArray]) {
        [tagView hide];
    }
}


/**
 是否存在已经绘制完成的标签
 
 @return BOOL
 */
- (BOOL)isCompletedTagExist{
    BOOL state = NO;
    for (ZYTagView *tagView in [self tagArray]) {
        if (![tagView.textField.textColor isEqual:[UIColor colorWithHexString:placeTagInputColor]]) {
            state = YES;
        }
    }
    return state;
}


/**
 验证桌面上的标签是否都完成了绘制,如果完成了绘制，ZYTagView的textfield文字颜色会与编辑时候的@“333333”不一样。
 
 @return BOOL
 */
- (BOOL)isAllTagCompleted{
    BOOL state = YES;
    UIColor *tempColor = [UIColor colorWithHexString:placeTagInputColor]; //要对比的颜色
    for (ZYTagView *tagView in [self tagArray]) {
        if ([tagView.textField.textColor isEqual:tempColor]) {
            state = NO;
        }
    }
    
    return state;
}


/**
 获取桌面上已经完成的标签
 
 @return 已完成的标签数组🏷
 */
- (NSMutableArray<ZYTagView *> *)completedTagArray{
    NSMutableArray<ZYTagView *> *completedTagArray = [NSMutableArray array];
    for (ZYTagView *tagView in [self tagArray]) {
        if (![tagView.textField.textColor isEqual:[UIColor colorWithHexString:placeTagInputColor]]) {
            [completedTagArray addObject:tagView];
        }
    }
    
    return completedTagArray;
}

/**
 将标签选中的状态改为未选中状态
 */
- (void)refreshTagViewToUnSelected{
    for (ZYTagView *tagView in [self tagArray]) {
        if (tagView.selected) {
            tagView.selected = NO;
        }
    }
}


/**
 完成标签绘制
 
 @param tagView 标签
 @param text 标签内容
 */
- (void)showTagView:(ZYTagView *)tagView text:(NSString *)text
{
    //判断是否需要换行显示标签
    NSString *currentStr = text;
    if (currentStr.length > maxTageTextNum) {
        currentStr = [currentStr substringToIndex:maxTageTextNum];
    }
    tagView.textField.text = currentStr;
#pragma mark editingTagW为标签的宽度，宽度为文字的宽度加上文字距离左右两边的间隙10
    CGFloat editingTagW = [NSString calculateSizeWithString:currentStr font:TagFont maxWidth:MAXFLOAT].width + 10;
    
    CGPoint startP = tagView.origin;
    //设置tagView的frame
    if (startP.x + editingTagW >= DEF_SCREEN_WIDTH) {
        tagView.frame = CGRectMake(12, startP.y + tagVerticalGap + TagHeight, editingTagW, TagHeight);
    }else{
        tagView.frame = CGRectMake(startP.x, startP.y, editingTagW, TagHeight);
    }
    [self outLineTagView:tagView WithTag:tagView.tag];
    tagView.textField.enabled = NO;
}


/**
 给绘制好的标签描边
 
 @param tagView 标签
 @param tag 标签索引
 */
- (void)outLineTagView:(ZYTagView *)tagView
               WithTag:(NSUInteger)tag
{
    UIColor *color = [UIColor colorWithHexString:self.colorArr[tag]];
    tagView.textField.textColor = color;
    tagView.backGroundLayer.fillColor = [UIColor clearColor].CGColor;
    tagView.backGroundLayer.strokeColor = color.CGColor;
    tagView.roundLayer.fillColor = [UIColor clearColor].CGColor;
    tagView.roundLayer.strokeColor = color.CGColor;
    tagView.textField.font = [UIFont systemFontOfSize:TagFont];
    [self refreshRightBtnState];
}

/**
 刷新当前选中标签的状态
 
 @param tagView 标签
 @param tag 标签索引
 */
- (void)refreshSelectedTagViewState:(ZYTagView *)tagView
                            WithTag:(NSUInteger)tag
{
    tagView.textField.textColor = [UIColor colorWithHexString:@"ffffff"];
    tagView.backGroundLayer.fillColor = [UIColor colorWithHexString:self.colorArr[tag]].CGColor;
    tagView.backGroundLayer.strokeColor = [UIColor colorWithHexString:self.colorArr[tag]].CGColor;
    tagView.roundLayer.fillColor = [UIColor whiteColor].CGColor;
    tagView.roundLayer.strokeColor = [UIColor whiteColor].CGColor;
    
}

/**
 将标签从高亮选中状态切换到普通状态
 
 @param tagView  标签
 @param tag 标签的索引
 */
- (void)recoverHighlightedTagView:(ZYTagView *)tagView
                  toNormalWithTag:(NSUInteger)tag
{
    tagView.textField.textColor = [UIColor colorWithHexString:self.colorArr[tag]];
    tagView.backGroundLayer.fillColor = [UIColor whiteColor].CGColor;
    tagView.backGroundLayer.strokeColor = [UIColor colorWithHexString:self.colorArr[tag]].CGColor;
    tagView.roundLayer.fillColor = [UIColor whiteColor].CGColor;
    tagView.roundLayer.strokeColor = [UIColor colorWithHexString:self.colorArr[tag]].CGColor;
    
}


/**
 开始绘制标签
 */
- (void)beginWithTag
{
    [self refreshRightBtnState];
    [self refreshTagViewToUnSelected];
    
    //点击了空白区域，将所有高亮的标签还原初始的样子
    self.placeTipLabel.hidden = YES;
    for (ZYTagView *view in [self tagArray]) {
        [self recoverHighlightedTagView:view toNormalWithTag:view.tag];
    }
    //如果最后一个标签还没有写完就点击了空白区域，先判断这个标签是否合法，如果合法就绘制边框，否则删除之。
    if (![self isLastTagLegal] ) {
        [self removeLastIllegalTag];
    }else if([self isRepeatedTag]){
        [self removeLastTag];
        [self showCenterMessage:sameTagWarning showTime:1.5];
    }else{
        [self showTagView:[self lastTag] text:[self lastTag].textField.text];
    }
    
    if ([self tagCount] < maxTageNum) { //标签少于3个，继续添加标签
        CGPoint startP = [self getStartPoint];
        ZYTagView *tagView = [[ZYTagView alloc] initWithFrame:CGRectMake(startP.x, startP.y, tagMaxWidth, TagHeight)];
        tagView.tag = [self tagCount];
        tagView.delegate = self;
        tagView.textField.delegate = self;
        tagView.textField.font = [UIFont systemFontOfSize:TagFont];
        tagView.textField.textColor = [UIColor colorWithHexString:@"333333"];
        tagView.backGroundLayer.fillColor = [UIColor clearColor].CGColor;
        tagView.roundLayer.fillColor = [UIColor clearColor].CGColor;
        [tagView.textField becomeFirstResponder];
        [tagView.textField addTarget:self action:@selector(textFieldBeginChange:) forControlEvents:UIControlEventEditingChanged];
        [self.tagInputView addSubview:tagView];
        
    }else{
        if ([self isAllTagCompleted]) { //如果已经有3个标签，并且3个标签都已经绘制好了，这个时候点击空白区域可以弹出箭头用来删除标签了
            [self deletePlaceTF];
        }
    }
    
    //把之前进入要删除的标签状态取消掉
    self.deleteBackwardCount = 0;
}

/**
 当桌面已经有3个标签，并且都已经绘制完毕，这个时候点击桌面空白区域，弹出键盘可以删除标签了
 */
- (void)deletePlaceTF{
    CGPoint deleteTFP = [self getStartPoint];
    UITextField *deleteTF = [[UITextField alloc] initWithFrame:CGRectMake(deleteTFP.x, deleteTFP.y + 3, 3, TagHeight - 6)];
    deleteTF.backgroundColor = [UIColor clearColor];
    deleteTF.textColor = [UIColor clearColor];
    deleteTF.delegate = self;
    deleteTF.tag = 1001; //做特殊标记
    [self.tagInputView addSubview:deleteTF];
    [deleteTF addTarget:self action:@selector(textFieldBeginChange:) forControlEvents:UIControlEventEditingChanged];
    [deleteTF becomeFirstResponder];
}


/**
 重新布局标签（当删除标签或者从历史记录添加标签的时候需要对剩下的标签重新布局）
 
 @param string 标签内容
 */
- (void)layOutTagWithString:(NSString *)string
{
    self.placeTipLabel.hidden = YES;
    CGPoint startP = [self getStartPoint];
    ZYTagView *tagView = [[ZYTagView alloc] initWithFrame:CGRectMake(startP.x, startP.y, tagMaxWidth, TagHeight)];
    tagView.tag = [self tagCount];
    tagView.delegate = self;
    tagView.textField.text = string;
    tagView.textField.font = [UIFont systemFontOfSize:TagFont];
    [self.tagInputView addSubview:tagView];
    tagView.textField.enabled = NO;
    
    CGFloat editingTagW = [NSString calculateSizeWithString:string font:TagFont maxWidth:MAXFLOAT].width + 10;
    
    //设置tagView的frame
    if (startP.x + editingTagW >= DEF_SCREEN_WIDTH) {
        tagView.frame = CGRectMake(12, startP.y + tagVerticalGap + TagHeight, editingTagW, TagHeight);
    }else{
        tagView.frame = CGRectMake(startP.x, startP.y, editingTagW, TagHeight);
    }
    
    [self outLineTagView:tagView WithTag:tagView.tag];
    [self refreshRightBtnState];
    
}


/**
 验证未完成绘制的这个标签是否与历史标签文字重复了
 
 @return BOOL
 */
- (BOOL)isRepeatedTag{
    
    BOOL state = NO;
    //获取桌面上的标签
    NSMutableArray<ZYTagView *> *tagArr = [self tagArray].mutableCopy;
    //如果桌面上只有当前这个标签,则不会有重复的
    if (tagArr.count == 1) {
        state = NO;
    }else{
        //找到最后一个标签
        ZYTagView *lastTag = [self lastTag];
        [tagArr removeLastObject]; //除掉当前正在编辑的这个标签,和之前已经添加好的标签做对比
        //在桌面上的标签中遍历,查看是否有存在的标签文字和最后一个标签的文字相同
        for (ZYTagView *tagView in tagArr) {
            if ([tagView.textField.text isEqualToString:lastTag.textField.text]) {
                state = YES;
            }
        }
    }
    
    return state;
}

/**
 标签Tag正在被编辑，检测标签的输入字数
 
 @param textField textField description
 */
- (void)textFieldBeginChange:(UITextField *)textField
{
    if (textField.tag == 1001) {
        if (textField.text.length > 0) {
            textField.text = @"";
            [self showCenterMessage:beyondInputTipText showTime:1.5];
        }
    }else{
        
        if (textField.text.length > maxTageTextNum) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提醒"
                                                                           message:@"标签不能超过15个字"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        //判断是否需要换行显示标签
        NSString *currentStr = textField.text;
        if (currentStr.length > maxTageTextNum) {
            currentStr = [currentStr substringToIndex:maxTageTextNum];
        }
        
        ZYTagView *tagView = [self lastTag];
        // tagView.textField.text = currentStr;
#pragma mark editingTagW为标签的宽度，宽度为文字的宽度加上文字距离左右两边的间隙10
        CGFloat editingTagW = [NSString calculateSizeWithString:currentStr font:TagFont maxWidth:MAXFLOAT].width + 10;
        
        CGPoint startP = tagView.origin;
        //设置tagView的frame
        if (startP.x + editingTagW >= DEF_SCREEN_WIDTH) {
            tagView.frame = CGRectMake(12, startP.y + tagVerticalGap + TagHeight, tagMaxWidth, TagHeight);
        }else{
            tagView.frame = CGRectMake(startP.x, startP.y, tagMaxWidth, TagHeight);
        }
        
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1000 || textField.tag == 1001) {
        return NO;
    }else{
        if (![self isLastTagLegal]) {
            [self removeLastIllegalTag];
            [self showCenterMessage:@"请至少输入一个字符" showTime:1.5];
        }else if([self isRepeatedTag]){
            [self showCenterMessage:sameTagWarning showTime:1.5];
            [self removeLastTag];
        }else{
            //对合法标签进行描边
            [self showTagView:[self lastTag] text:textField.text];
        }
        //如果按下回车键生成标签后，标签总数少于3个，则自动进入下一个标签的编辑状态
        if ([self tagCount] < maxTageNum) {
            [self beginWithTag];
        }
        
    }
    
    return YES;
}


#pragma mark ZYTagViewDelegate
- (void)tagViewDidTouch:(ZYTagView *)tagView atIndex:(NSUInteger)index
{
    if (![self isLastTagLegal]) {
        [self removeLastIllegalTag];
    }else if([self isRepeatedTag]){
        [self removeLastTag];
    }else{
        [self showTagView:[self lastTag] text:[self lastTag].textField.text];
        
    }
    for (ZYTagView *view in self.tagInputView.subviews) {
        if ([view isKindOfClass:[ZYTagView class]]) {
            if (view.tag == tagView.tag) {
                [self refreshSelectedTagViewState:view WithTag:view.tag];
            }else{
                [self recoverHighlightedTagView:view toNormalWithTag:view.tag];
            }
        }
    }
    [self refreshRightBtnState];
    
    //创建一个占位的textField调出键盘，text设置为一个字符，监测到text变为@“”就认为点了删除按钮，输入其他字符串屏蔽，保持_placeholderTF.text == @"删"
    [self.placeTextField becomeFirstResponder];
    self.placeTextField.text = @"删";
    [self refreshTagViewToUnSelected];
    tagView.selected = YES;
}


#pragma mark ZYTextFieldDelegate
- (void)textFieldDidDeleteBackward:(UITextField *)textField
{
    if (textField.tag == 1000) {
        if ([NSString isZYBlankString:textField.text]) {
            for (ZYTagView *tagView in [self tagArray]) {
                if (tagView.selected) {
                    [tagView hide];
                }
            }
        }
        [self refreshRightBtnState]; //删除一个标签之后,需要刷新一下完成按钮的状态
        NSArray<ZYTagView *> *tagArray = [NSArray arrayWithArray:[self tagArray]];  //剩余标签转移
        [self removeAllTagsFromTable]; //移除掉桌面上的所有标签,重新布局
        
        for (ZYTagView *tagView in tagArray) {
            [self layOutTagWithString:tagView.textField.text];
        }
        
    }else if(textField.tag == 1001){
        if ([NSString isZYBlankString:textField.text]) {
            self.deleteBackwardCount++;
            if (self.deleteBackwardCount == 1) {
                [self refreshSelectedTagViewState:[self lastTag] WithTag:[self lastTag].tag];
            }else if (self.deleteBackwardCount == 2){
                self.deleteBackwardCount = 0;
                [[self lastTag] hide];
                [textField removeFromSuperview];
                [self beginWithTag];
            }
        }
        
    }else{
        //如果正在绘制的标签里面有内容，一直按“X”键，需要先将内容清掉，才会响应删除标签的事件
        if ([NSString isZYBlankString:textField.text]) {
            self.deleteBackwardCount++;
            ZYTagView *tagView = [self completedTagArray].lastObject;
            if (self.deleteBackwardCount == 1) {
                [self refreshSelectedTagViewState:tagView WithTag:tagView.tag];
            }else if (self.deleteBackwardCount == 2){
                self.deleteBackwardCount = 0;
                [tagView hide];
                [self beginWithTag];
            }
            
        }
        
    }
}

- (void)refreshRightBtnState{
    if ([self isCompletedTagExist]) {
        self.rightButton.selected = YES;
        self.rightButton.enabled = YES;
    }else{
        self.rightButton.selected = NO;
        self.rightButton.enabled = NO;
    }
}

#pragma mark完成标签的添加
- (void)rightButtonClick:(UIButton *)button
{
    if (![self isLastTagLegal]) {
        [self removeLastIllegalTag];
    }else if([self isRepeatedTag]){
        [self removeLastTag];
    }else{
        [self showTagView:[self lastTag] text:[self lastTag].textField.text];
        
    }
    
    //获取桌面上的标签
    NSArray<ZYTagView *> *tagArr = [self tagArray];
    
    //将标签信息传递给外面使用
    for (ZYTagView *tagView in tagArr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *key = [NSString stringWithFormat:@"%ld",tagView.tag];
        NSString *str = [NSString stringWithFormat:@"%@",tagView.textField.text];
        
        [dic setObject:str forKey:key];
        [self.tagInfoArray addObject:dic];
    }
    
    NSLog(@"%@",self.tagInfoArray);
    //遍历桌面上的所有标签,添加到常用标签里面
    for (ZYTagView *tagView in tagArr) {
        if (![NSString isZYBlankString:tagView.textField.text]) {
            
            if (![self isTheSameToHistoryRecord:self.historyTagArray compareToString:tagView.textField.text]) {
                //将这个新的记录放在历史记录的第一位
                [self.historyTagArray insertObject:tagView.textField.text atIndex:0];
                if (self.historyTagArray.count > maxTageNum) {  //如果历史记录大于3条,则将最后一个历史记录删除之
                    [self.historyTagArray removeLastObject];
                }
            }
        }
    }
    
    //存储标签到本地
    NSArray *history = [NSArray arrayWithArray:self.historyTagArray];
    [[NSUserDefaults standardUserDefaults] setObject:history forKey:HISTORY_RECORD];
    
    if (self.tagBlock) {
        self.tagBlock(self.tagInfoArray);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



/////////////////////////////////////////////////////////////////////////////
//////////                                                         //////////
//////////               常 用 标 签 部 分                           //////////
//////////                                                         //////////
/////////////////////////////////////////////////////////////////////////////
/**
 Description 判断历史记录中的文字是否有与被添加的标签文字相同,传入self.historyTagArray
 
 @param historyRecord 历史记录的标签
 @param string 要比较的文字
 @return bool
 */
- (BOOL)isTheSameToHistoryRecord:(NSArray<NSString *> *)historyRecord compareToString:(NSString *)string
{
    BOOL state = NO;
    for (NSString *str in historyRecord) {
        if ([str isEqualToString:string]) {
            state = YES;
        }
    }
    return state;
}

- (void) historyModule
{
    UIView *historyTagView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tagInputView.bottom, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - self.tagInputView.bottom)];
    self.historyTagView = historyTagView;
    historyTagView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:historyTagView];
    
    UILabel *historyLabel = ({
        UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 100, 30)];
        historyLabel.text = @"常用标签:";
        historyLabel.textColor = [UIColor colorWithHexString:@"666666"];
        historyLabel.font = [UIFont systemFontOfSize:13];
        [historyLabel sizeToFit];
        historyLabel;
    });
    [historyTagView addSubview:historyLabel];
    
    for (NSString *tagString in self.historyTagArray) {
        [self layOutHistoryTagWithString:tagString];
    }
    
}

/**
 新历史记录标签的起点坐标
 
 @return 新历史记录标签的起点坐标
 */
- (CGPoint)getHistoryTagStartPoint
{
    CGPoint startPoint;
    NSMutableArray *marr = [NSMutableArray array]; //统计当前桌面上面的标签数目
    for (ZYTagView *tagView in self.historyTagView.subviews) {
        if ([tagView isKindOfClass:[ZYTagView class]]) {
            [marr addObject:tagView];
            
        }
    }
    
    if (marr.count == 0) {  //如果桌面上没有标签
        startPoint = CGPointMake(12, 37);
    }else{
        ZYTagView *temp;
        for (ZYTagView *tagView in marr) {
            temp = (ZYTagView *)marr[0]; //假设第一个标签的tag值最大
            if (temp.tag < tagView.tag) {  //找出tag值最大的标签
                temp = tagView;
            }
        }
        //如果有标签,新的标签的起点为
        startPoint = CGPointMake(temp.right + tagHorizontalGap, temp.top);
    }
    return startPoint;
}

/**
 获取桌面上历史标签的个数
 
 @return 标签个数
 */
- (NSUInteger)historyTagCount
{
    NSMutableArray *marr = [NSMutableArray array]; //统计当前桌面上历史标签数目
    for (ZYTagView *tagView in self.historyTagView.subviews) {
        if ([tagView isKindOfClass:[ZYTagView class]]) {
            [marr addObject:tagView];
        }
    }
    return [marr count];
}


/**
 从历史记录里面添加的标签是否与桌面上的标签重复
 
 @return BOOL
 */
- (BOOL)isRepeatedTagWithString:(NSString *)string{
    
    BOOL state = NO;
    //获取桌面上的标签
    NSMutableArray<ZYTagView *> *tagArr = [self tagArray].mutableCopy;
    //如果桌面上只有当前这个标签,则不会有重复的
    if (tagArr.count == 0) {
        state = NO;
    }else{
        //在桌面上的标签中遍历,查看是否有存在的标签文字和最后一个标签的文字相同
        for (ZYTagView *tagView in tagArr) {
            if ([tagView.textField.text isEqualToString:string]) {
                state = YES;
            }
        }
    }
    
    return state;
}


/**
 布局历史标签
 
 @param string 历史标签的文字
 */
- (void)layOutHistoryTagWithString:(NSString *)string
{
    CGPoint startP = [self getHistoryTagStartPoint];
    ZYTagView *tagView = [[ZYTagView alloc] initWithFrame:CGRectMake(startP.x, startP.y, tagMaxWidth, TagHeight)];
    tagView.tag = [self historyTagCount];
    tagView.backgroundColor = [UIColor clearColor];
    tagView.textField.text = string;
    tagView.type = TagTypeHistory;
    tagView.delegate = self;
    tagView.textField.font = [UIFont systemFontOfSize:TagFont];
    [self.historyTagView addSubview:tagView];
    tagView.textField.enabled = NO;
    
    CGFloat editingTagW = [NSString calculateSizeWithString:string font:TagFont maxWidth:MAXFLOAT].width + 10;
    //设置tagView的frame
    if (startP.x + editingTagW >= DEF_SCREEN_WIDTH) {
        tagView.frame = CGRectMake(12, startP.y + tagVerticalGap + TagHeight, editingTagW, TagHeight);
    }else{
        tagView.frame = CGRectMake(startP.x, startP.y, editingTagW, TagHeight);
    }
    
    [self outLineTagView:tagView WithTag:tagView.tag];
}


/**
 点击历史标签的代理方法
 
 @param tagView 历史标签🏷
 */
- (void)tagViewDidTouch:(ZYTagView *)tagView
{
    [self.placeTextField becomeFirstResponder];
    if ([self tagCount] < maxTageNum) {
        if (![self isLastTagLegal] ) {  //如果最后一个标签不合法，表示点击空白区域后，点击了历史标签
            [self removeLastIllegalTag];
            if (![self isRepeatedTagWithString:tagView.textField.text]) {
                [self layOutTagWithString:tagView.textField.text];
            }else{
                [self showCenterMessage:sameTagWarning showTime:1.5];
            }
        }else{ //如果最后一个标签合法，则表示正在绘制的标签没有完成，又点击了历史标签
            //先对未完成的标签做判断
            if ([self isRepeatedTag]) {
                [self removeLastTag]; //如果重复就删除之
            }else{
                //先将这个合法的标签绘制出来
                [self showTagView:[self lastTag] text:[self lastTag].textField.text];
                
                //再将 非重复的历史标签添加上去
                if (![self isRepeatedTagWithString:tagView.textField.text]) {
                    [self layOutTagWithString:tagView.textField.text];
                }else{
                    [self showCenterMessage:sameTagWarning showTime:1.5];
                }
                
            }
            
        }
    }else{
        if (![self isLastTagLegal] ){ //如果点击历史标签添加到标签的时候，出现了非法标签，则表明在点击添加标签的空白区域后，生成一个非法标签，然后又点击历史标签，先将这个空白标签移除，然后看看正在添加的历史标签与已存在的标签是否有重复
            [self removeLastIllegalTag];
            if (![self isRepeatedTagWithString:tagView.textField.text]) {
                [self layOutTagWithString:tagView.textField.text];
            }else{
                [self showCenterMessage:sameTagWarning showTime:1.5];
            }
        }else{
            [self showCenterMessage:beyondInputTipText showTime:1.5];
        }
        
    }
    
    [self refreshRightBtnState];
}

- (void)showCenterMessage:(NSString *)message showTime:(CGFloat)showTime
{
    [MBProgressHUD removePreHUDInView:self.view];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithFrame:self.view.bounds];
    hud.userInteractionEnabled = NO;
    [self.view addSubview:hud];
    hud.yOffset = -self.view.height/2+200;
    [hud show:YES];
    hud.labelText = message;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:showTime];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"ZYTagVC被系统回收了♻️****");
}


@end
