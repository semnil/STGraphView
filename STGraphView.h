//
//  STGraphView.h
//  STGraphView
//
//  Created by Shinone Tetsuya on 2013/02/24.
//  Copyright (c) 2013 Shinone Tetsuya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum STGraphViewType : NSInteger {
    STGraphViewTypeLine,
    STGraphViewTypeBar,
    STGraphViewTypePie
} STGraphViewType;

typedef enum STGraphViewMode : NSInteger {
    STGraphViewModeNormal,
    STGraphViewModeCumulative,      // value level cumulation
    STGraphViewModeCumulativeAll    // source level cumulation
} STGraphViewMode;

@protocol STGraphViewDelegate
@required
- (int)numberOfSource;
- (int)numberOfValueWithSource:(int)source;
- (float)valueOfIndex:(int)index withSource:(int)source;
- (UIColor *)lineColorOfValueWithSource:(int)source;
- (UIColor *)fillColorOfValueWithSource:(int)source;
@optional
@end

@interface STGraphView : UIView
{
    id _delegate;
    int _graphType;
    int _graphMode;
    float _borderWidth;
    // Line graph parameters
    float _lineWidth;
    float _labelWidth;
    
    float _paddingLeft;
    float _paddingRight;
    float _paddingTop;
    float _paddingBottom;
    
    float _labelTextSize;
    
    NSString *_unitSring;
}

@property (assign, nonatomic) id <STGraphViewDelegate>delegate;
@property (assign, nonatomic) int graphType;
@property (assign, nonatomic) int graphMode;
@property (assign, nonatomic) float paddingLeft;
@property (assign, nonatomic) float paddingRight;
@property (assign, nonatomic) float paddingTop;
@property (assign, nonatomic) float paddingBottom;
@property (retain, nonatomic) NSString *unitSring;

- (void)setPaddingWithWidth:(float)width height:(float)height;

@end
