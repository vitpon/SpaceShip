//
//  CCActionCallFunc+CCActionCallFuncO.h
//  SpaceShip2
//
//  Created by Theeravit Ponsuntikul on 11/28/2557 BE.
//  Copyright (c) 2557 Apportable. All rights reserved.
//

#import "CCActionInstant.h"

@interface CCActionCallFuncO : CCActionCallFunc {
    id _object;
}

@property (nonatomic, readwrite, strong) id object;

+ (id) actionWithTarget: (id) t selector:(SEL) s object:(id)object;
- (id) initWithTarget:(id) t selector:(SEL) s object:(id)object;

@end
