//
//  EGGSystemSound.m
//  ChorizoApp
//
//  Created by Edu González on 19/1/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import "EGGSystemSound.h"
@import AVFoundation;
#define FOREVER -1

@interface EGGSystemSound ()

@property (nonatomic, strong)AVAudioPlayer *player; //es inmutable, hay que crear uno para cada sonido

@end

@implementation EGGSystemSound

+(instancetype)SharedSystemsSounds{
    
    static EGGSystemSound *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[EGGSystemSound alloc]init];
    });
    
    return shared;
}

-(void) punch{
    [self playFileNamed:@"horn2" extension:@"wav" numberOfLoops:0];
}
-(void) startMachineGun{
    [self playFileNamed:@"horn2" extension:@"wav" numberOfLoops:FOREVER];//con -1 le decimos que se repita indefinidamente
    
}
-(void) stopMachineGun{
    [self.player stop];
    
}
-(void) binLaden{
    [self playFileNamed:@"horn2" extension:@"wav" numberOfLoops:1];

}
-(void) tape{
    [self playFileNamed:@"horn2" extension:@"wav" numberOfLoops:2];
    
}
-(void) untape{
    [self playFileNamed:@"horn2" extension:@"wav" numberOfLoops:2];

}

-(void)playFileNamed:(NSString *)name
          extension:(NSString *)extension
      numberOfLoops:(NSInteger)loops{
    
    //Creamos la ruta al sonido
    NSURL *url = [[NSBundle mainBundle]URLForResource:name withExtension:extension];
    
    NSError *err = nil;
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];

    if (self.player) {
        //no hubo error
        self.player.numberOfLoops = loops;
        [self.player play];
    }else{
        //Error
        NSLog(@"Error al reproducir %@: %@",url,err);
    }
}

@end
