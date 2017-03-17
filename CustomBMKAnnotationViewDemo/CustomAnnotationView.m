//
//  CustomAnnotationView.m
//  CustomBMKAnnotationViewDemo
//
//  Created by wordtech on 17/3/16.
//  Copyright © 2017年 bwayCW. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier customView:(UIView *)detailView {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self setBounds:CGRectMake(0.f, 0.f, 142.f, 120.f)];
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(40, -80);//设置中心点偏移
        [self addSubview:detailView];
    }
    return self;
}

@end
