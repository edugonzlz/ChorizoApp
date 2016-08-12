//
//  ViewController.m
//  ChorizoApp
//
//  Created by Edu González on 21/11/15.
//  Copyright © 2015 Edu González. All rights reserved.
//

#import "ViewController.h"
#import "EGGSystemSound.h"

@interface ViewController ()

@property (strong, nonatomic)UIImageView *lastChorizo;
@property (strong, nonatomic)NSArray *showSprite;
@property (strong, nonatomic)NSArray *hideSprite;
@property (strong, nonatomic)UIImageView *tapeView;
@property (nonatomic)CGPoint lastTouch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"Chorizo App";
    
    //Sprites
    
    self.showSprite = @[[UIImage imageNamed:@"tape1.png"], [UIImage imageNamed:@"tape2.png"], [UIImage imageNamed:@"tape3.png"], [UIImage imageNamed:@"tape4.png"]];
    self.hideSprite = @[[UIImage imageNamed:@"tape4.png"], [UIImage imageNamed:@"tape3.png"], [UIImage imageNamed:@"tape2.png"], [UIImage imageNamed:@"tape1.png"]];

    
    // Creamos los reconocedores
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(didTap:)];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(didPan:)];
    
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(didSwipe:)];
    
    // Añadir los gesture recognizers a  la vista
    [self.view addGestureRecognizer:tap];
    [self.view addGestureRecognizer:pan];
    [self.view addGestureRecognizer:swipe];
    
}

#pragma  mark - Actions
-(void) didTap:(UITapGestureRecognizer *) tap{
    
    if (tap.state == UIGestureRecognizerStateRecognized) {
        UIImageView *chorizo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chorizo.png"]];
        
        chorizo.bounds = CGRectMake(0, 0, 60, 60);
        chorizo.center = [tap locationInView:self.imageView];
        [self.imageView addSubview:chorizo];
        
        [self playPunch];
    }
}

-(void) didPan:(UIPanGestureRecognizer *)pan{
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint currentPosition = [pan locationInView:self.imageView];
        CGRect lastChorizo = self.lastChorizo.frame;
        
        //si el dedo esta fuera de la frame del chorizo
        if (!CGRectContainsPoint(lastChorizo, currentPosition)) {
            
            UIImageView *chorizo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chorizo.png"]];
            
            chorizo.frame = CGRectMake([pan locationInView:self.imageView].x, [pan locationInView:self.imageView].y, 60, 60);
            chorizo.center = [pan locationInView:self.imageView];
            [self.imageView addSubview:chorizo];
            
            self.lastChorizo = chorizo;
        }
    }else if (pan.state == UIGestureRecognizerStateBegan){
        [[EGGSystemSound SharedSystemsSounds]startMachineGun];

    }else if (pan.state == UIGestureRecognizerStateEnded){
        [[EGGSystemSound SharedSystemsSounds]stopMachineGun];

    }
}

-(void) didSwipe:(UISwipeGestureRecognizer *) swipe{
    
    if (swipe.state == UIGestureRecognizerStateRecognized) {
        if (!self.tapeView) {
            
            //ponemos la cinta
            self.tapeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tape4.png"]];
            self.tapeView.animationImages = self.showSprite;
            self.tapeView.animationDuration = 0.2;
            self.tapeView.animationRepeatCount = 1;
            
            self.tapeView.center = [swipe locationInView:self.imageView];
            [self.imageView addSubview:self.tapeView];
            
            [self.tapeView startAnimating];
            
            [[EGGSystemSound SharedSystemsSounds]tape];
            
        }else{
            
            //quitamos la cinta
            self.tapeView.animationImages = self.hideSprite;
            self.tapeView.image = nil;
            
            [self.tapeView startAnimating];
            
            [[EGGSystemSound SharedSystemsSounds]untape];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tapeView removeFromSuperview];
                self.tapeView = nil;
            });
        }
    }
}

#pragma mark Shake

//borrar todas las subviews, todos los chorizos y demas con una sacudida
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
        for (UIView *view in self.imageView.subviews) {
            [view removeFromSuperview];
        }
        self.tapeView = nil;
        [[EGGSystemSound SharedSystemsSounds]binLaden];

    }
}
-(BOOL)canBecomeFirstResponder{
    
    return YES;
}

#pragma mark Sound

-(void)playPunch{
    
    [[EGGSystemSound SharedSystemsSounds]punch];
}

@end
