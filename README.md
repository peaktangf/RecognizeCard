<h1 align="center">我是一个能识别中国二代身份证的Demo 👋</h1>

## ✨ Demo

#### 一、写在开头
  身份证识别，又称OCR技术。OCR技术是光学字符识别的缩写，是通过扫描等光学输入方式将各种票据、报刊、书籍、文稿及其它印刷品的文字转化为图像信息，再利用文字识别技术将图像信息转化为可以使用的计算机输入技术。

  因为项目需要，所以这些天查阅了相关资料，想在网上看看有没有大神封装的现成的demo可以用。但是无果，网上关于ocr这一块的资料很少，比较靠谱的都是要收费的，而且价格也不便宜。但是在天朝，收费感觉心里不爽，所以就决定自己研究一番。

  先上一个最终实现的效果（如果mac不是retain屏幕的，分辨率会有影响，需要在真机上调试）

![最终实现的效果.gif](http://upload-images.jianshu.io/upload_images/1248713-37d71a75530fc59a.gif?imageMogr2/auto-orient/strip)

#### 二、需要用到的技术
搜了很多资料，发现要进行身份证号码的识别，需要用到以下几种技术:
- ###### 图像处理技术
包括灰度化处理，二值化，腐蚀，轮廊检测等等。

 1. ```灰度化处理```：图片灰度化处理就是将指定图片每个像素点的RGB三个分量通过一定的算法计算出该像素点的灰度值，使图像只含亮度而不含色彩信息。
 
![灰度图.png](http://upload-images.jianshu.io/upload_images/1248713-79e2e1d41ad25c05.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 2. ```二值化```：二值化处理就是将经过灰度化处理的图片转换为只包含黑色和白色两种颜色的图像，他们之间没有其他灰度的变化。在二值图中用255便是白色，0表示黑色。
 
![二值图.png](http://upload-images.jianshu.io/upload_images/1248713-74b6012efd2525f4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 3. ```腐蚀```：图片的腐蚀就是将得到的二值图中的黑色块进行放大。即连接图片中相邻黑色像素点的元素。通过腐蚀可以把身份证上的身份证号码连接在一起形成一个矩形区域。
 
![腐蚀图.png](http://upload-images.jianshu.io/upload_images/1248713-41959874f87fd06d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 4. ```轮廊检测```：图片经过腐蚀操作后相邻点会连接在一起形成一个大的区域，这个时候通过轮廊检测就可以把每个大的区域找出来，这样就可以定位到身份证上面号码的区域。
 
![轮廊图.png](http://upload-images.jianshu.io/upload_images/1248713-bfb20df29a04730a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- ###### 文字识别技术
通过识别图像，将图像信息转化为可以使用的计算机输入技术。比如下面这张包含一串数字的图片，通过ocr识别技术可以将图片中包含的数字信息以字符串的方式输出。

![包含数字的图片.png](http://upload-images.jianshu.io/upload_images/1248713-8b9199aed071b13e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 
#### 三、开源框架OpenCV和TesseractOCRiOS
- ###### OpenCV（完成图像处理技术）
  OpenCV是一个开源的跨平台计算机视觉和机器学习库，通俗点的说，就是他给计算机提供了一双眼睛，一双可以从图片中获取信息的眼镜，从而完成人脸识别、身份证识别、去红眼、追踪移动物体等等的图像相关的功能。[opencv官网](http://opencv.org/)

- ###### TesseractOCRiOS（完成文字识别技术）
  Tesseract是目前可用的最准确的开源OCR引擎，可以读取各种格式的图片并将他们转换成各种语言文本。而TesseractOCRiOS则是针对iOS平台封装的Tesseract引擎库。

#### 四、实战演示
- ###### 创建一个iOS项目
- ###### 用CocoPods导入上面两个库
由于OpenCV库文件比较大，所以时间会稍微久一点，耐心等待就是。

![podfile文件.png](http://upload-images.jianshu.io/upload_images/1248713-32c649f05acf5d64.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- ###### 导入完成之后运行项目，会发现报如下错误

![Bitode报错.png](http://upload-images.jianshu.io/upload_images/1248713-296ca01578ad6c92.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

由于导入的库不支持Bitcode机制，需要关掉，在工程->TARGETS->Build Setting-> Enable Bitcode设置为NO就ok。

![关掉Bitcode.png](http://upload-images.jianshu.io/upload_images/1248713-4d2b784bc23a6837.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- ###### 导入TesseractOCRiOS需要的语言包
  TesseractOCRiOS库中没有自带的语言包，需要我们自己手动导入，我们这里直接到[tesseract-ocr](https://github.com/tesseract-ocr)网站，tessdata即是我们需要用到的语言包。下载下来的语言包有400多兆。这里我们只需要用到英语语言包，所以就只导入eng.traineddata就ok，其他的都删掉。

导入语言包种需要注意几点：
 1. 语言包需要放在tessdata目录下。TesseractOCRiOS中查找语言包是在tessdata目录下进行查找的，所以我们不能单独把eng.traineddata导入项目中，而需要放在tessdata目录下导入项目中。
 2. 将tessdata导入xcode项目，需要勾选Create folder refrences。上面已经提到了语言包需要放在tessdata目录下，所以导入文件到xcode的时候需要创建文件夹的形式，而不是创建组的形式。如下图：

![导入tessdata文件夹的方式.png](http://upload-images.jianshu.io/upload_images/1248713-68f07dd7d28ec043.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- ###### 创建一个RecogizeCardManager用来管理身份证识别相关的代码。
由于OpenCV和TesseractOCRiOS库都是基于c++编写的，所以需要把RecogizeCardManager.m后缀的.m改成.mm

![RecogizeCardManager.png](http://upload-images.jianshu.io/upload_images/1248713-c4cc50713f3e0340.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- ###### RecogizeCardManager中的代码

###### .h文件
```
#import <Foundation/Foundation.h>
@class UIImage;

typedef void (^CompleateBlock)(NSString *text);

@interface RecogizeCardManager : NSObject
  
/**
*  初始化一个单例
*
*  @return 返回一个RecogizeCardManager的实例对象
*/
+ (instancetype)recognizeCardManager;

/**
*  根据身份证照片得到身份证号码
*
*  @param cardImage 传入的身份证照片
*  @param compleate 识别完成后的回调
*/
- (void)recognizeCardWithImage:(UIImage *)cardImage compleate:(CompleateBlock)compleate;

@end 
```

###### .m文件
```
#import "RecogizeCardManager.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <TesseractOCR/TesseractOCR.h>

@implementation RecogizeCardManager

+ (instancetype)recognizeCardManager {
    static RecogizeCardManager *recognizeCardManager = nil;
    static dispatch
