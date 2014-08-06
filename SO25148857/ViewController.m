//
//  ViewController.m
//  SO25148857
//
//  Created by Brian Nickel on 8/6/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

#import "ViewController.h"
#import "OutputViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *whiteLabel;


@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 200, 200)];
    [path appendPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)] bezierPathByReversingPath]];
    self.textView.textContainer.exclusionPaths = @[path];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.overlayView.bounds;
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5].CGColor;
    [self.overlayView.layer addSublayer:shapeLayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.textView.editable = YES;
}

- (UIImage *)renderImage
{
    UIImage *image = self.imageView.image;
    UIGraphicsBeginImageContextWithOptions(image.size, YES, 0);
    
    [image drawAtPoint:CGPointZero];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGFloat scale = image.size.width / CGRectGetWidth(self.textView.frame);
    CGContextScaleCTM(context, scale, scale);
    [self drawLayer:self.textView.layer recursivelyInContext:context];
    
    CGContextRestoreGState(context);
    

    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.textView.editable = NO;
    [[segue destinationViewController] view];
    [[[segue destinationViewController] imageView] setImage:[self renderImage]];
}

- (void)drawLayer:(CALayer *)layer recursivelyInContext:(CGContextRef)context
{
    [layer drawInContext:context];
    for (CALayer *sublayer in layer.sublayers) {
        [self drawLayer:sublayer recursivelyInContext:context];
    }
}


@end
