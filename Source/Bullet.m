//
//  CCNode+Asteroid.m
//  SpaceShip2
//
//  Created by Theeravit Ponsuntikul on 11/28/2557 BE.
//  Copyright (c) 2557 Apportable. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet{
}

- (void)setInvisible {
    self.visible = NO;
    self.position = ccp(-100, -100);
}
@end
