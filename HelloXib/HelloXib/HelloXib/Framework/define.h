//
//  define.h
//  XibFrameWork
//
//  Created by Uran on 2018/2/12.
//  Copyright © 2018年 Uran. All rights reserved.
//

#ifndef define_h
#define define_h

// 取得 Bundle Path
#define BundlePath [[NSBundle mainBundle] pathForResource:@"XibBundle" ofType:@"bundle"]
/* 根據 BundlePath 有無 判斷 是 自己的 Bundle 還是 main Bundle */
#define BundleSelf BundlePath ? [NSBundle bundleWithPath:BundlePath] : [NSBundle mainBundle]


#endif /* define_h */
