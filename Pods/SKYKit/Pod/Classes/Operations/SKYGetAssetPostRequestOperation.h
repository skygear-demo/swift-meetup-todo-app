//
//  SKYGetAssetPostRequestOperation.h
//  SKYKit
//
//  Copyright 2015 Oursky Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>

#import "SKYAsset.h"
#import "SKYOperation.h"

@interface SKYGetAssetPostRequestOperation : SKYOperation
NS_ASSUME_NONNULL_BEGIN

- (instancetype)initWithRequest:(SKYRequest *)request NS_UNAVAILABLE;
+ (instancetype)operationWithAsset:(SKYAsset *)asset;

@property (nonatomic, readwrite) SKYAsset *asset;

@property (nonatomic, copy) void (^_Nullable getAssetPostRequestCompletionBlock)
    (SKYAsset *_Nullable asset, NSURL *_Nullable postURL,
     NSDictionary<NSString *, NSObject *> *_Nullable extraFields, NSError *_Nullable operationError)
        ;

NS_ASSUME_NONNULL_END
@end
