//
//  ImageAnnoTationView.m
//  CustomBMKAnnotationViewDemo
//
//  Created by wordtech on 17/3/16.
//  Copyright © 2017年 bwayCW. All rights reserved.
//

#import "ImageAnnoTationView.h"

@implementation ImageAnnoTationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self setBounds:CGRectMake(0.f, 0.f, 50.f, 50.f)];
        [self setBackgroundColor:[UIColor clearColor]];
        _annotationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _annotationImageView.contentMode = UIViewContentModeCenter;
        
        [self addSubview:_annotationImageView];
    }
    return  self;
}
- (void)setAnnimage:(UIImage *)annimage {
    _annimage = annimage;
    [self updateImageView];
}

- (void)updateImageView {
    if ([_annotationImageView isAnimating]) {
        [_annotationImageView stopAnimating];
    }
    
    _annotationImageView.image = _annimage;
    _annotationImageView.animationDuration = 0.5;
    _annotationImageView.animationRepeatCount = 0;
    [_annotationImageView startAnimating];
}
@end
