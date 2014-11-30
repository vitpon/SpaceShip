//
//  CCNode+Asteroid.m
//  SpaceShip2
//
//  Created by Theeravit Ponsuntikul on 11/28/2557 BE.
//  Copyright (c) 2557 Apportable. All rights reserved.
//

#import "Asteroid.h"

@implementation Asteroid{
    int _hit;
}

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"asteroid";
    _hit = 3;
}

- (void)setInvisible {
    [[OALSimpleAudio sharedInstance] playEffect:@"explosion_large.caf"];
    self.visible = NO;
    self.position = ccp(-500, -500);
}

- (void) hit{
    _hit--;
    if(_hit < 1){
        [self setInvisible];
    }
}

@end
