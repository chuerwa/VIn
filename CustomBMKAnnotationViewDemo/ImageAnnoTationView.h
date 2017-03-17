//
//  ImageAnnoTationView.h
//  CustomBMKAnnotationViewDemo
//
//  Created by wordtech on 17/3/16.
//  Copyright © 2017年 bwayCW. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface ImageAnnoTationView : BMKAnnotationView
@property (nonatomic, strong)  UIImage *annimage;
@property (nonatomic, strong) UIImageView *annotationImageView;
@end
