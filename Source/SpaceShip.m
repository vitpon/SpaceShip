//
//  CCNode+Asteroid.m
//  SpaceShip2
//
//  Created by Theeravit Ponsuntikul on 11/28/2557 BE.
//  Copyright (c) 2557 Apportable. All rights reserved.
//

#import "SpaceShip.h"
#import "Gun.h"

@implementation SpaceShip {
    Gun *_gun;
}

- (void)didLoadFromCCB {
    [super didLoadFromCCB];
//    _gun = [[Gun alloc]init:self];
    
}

- (void)setGun {
    _gun = [[Gun alloc]init:self];
    
}

-(void)shot{
    [_gun shot3];
}


@end
