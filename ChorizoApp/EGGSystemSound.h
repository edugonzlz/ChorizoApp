//
//  EGGSystemSound.h
//  ChorizoApp
//
//  Created by Edu González on 19/1/16.
//  Copyright © 2016 Edu González. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGGSystemSound : NSObject

+(instancetype)SharedSystemsSounds;

-(void) punch;
-(void) startMachineGun;
-(void) stopMachineGun;
-(void) binLaden;
-(void) tape;
-(void) untape;

@end
