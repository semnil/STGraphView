//
//  STGraphView.h
//  STGraphView
//
//  Created by Shinone Tetsuya on 2013/02/24.
//  Copyright (c) 2013 Shinone Tetsuya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STGraphViewDelegate
@required
- (int)numberOfValue;
- (int)valueOfIndex:(int)index;
- (UIColor *)lineColorOfValue;
- (UIColor *)fillColorOfValue;
@optional
@end

@interface STGraphView : UIView
{
    id _delegate;
    float _paddingWidth;
    float _paddingHeight;
}

@property (assign, nonatomic) id <STGraphViewDelegate>delegate;
@property (assign, nonatomic) float paddingWidth;
@property (assign, nonatomic) float paddingHeight;

- (void)setPaddingWithWidth:(float)width height:(float)height;

@end
