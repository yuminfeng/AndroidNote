﻿视频播放相关内容总结
===

##Surface简介
- `Surface`就是“表面”的意思。在`SDK`的文档中，对`Surface`的描述是这样的：“`Handle onto a raw buffer that is being managed by the screen compositor`”，翻译成中文就是“由屏幕显示内容合成器`(screen compositor)`所管理的原生缓冲器的句柄”，这句话包括下面两个意思：
    - 通过Surface（因为Surface是句柄）就可以获得原生缓冲器以及其中的内容。就像在C语言中，可以通过一个文件的句柄，就可以获得文件的内容一样；
    - 原生缓冲器（rawbuffer）是用于保存当前窗口的像素数据的。
- 简单的说`Surface`对应了一块屏幕缓冲区，每个`Window`对应一个`Surface`，任何`View`都是画在`Surface`上的，传统的`view`共享一块屏幕缓冲区，所有的绘制必须在`UI`线程中进行
- 我们不能直接操作Surface实例，要通过SurfaceHolder，在SurfaceView中可以通过getHolder()方法获取到SurfaceHolder实例。
- `Surface`是一个用来画图形的地方，但是我们知道画图都是在一个`Canvas`对象上面进行的，*`Surface`中的`Canvas`成员，是专门用于提供画图的地方，就像黑板一样，其中的原始缓冲区是用来保存数据的地方，`Surface`本身的作用类似一个句柄，得到了这个句柄就可以得到其中的`Canvas`、原始缓冲区以及其他方面的内容，所以简单的说`Surface`是用来管理数据的(句柄)*。


##SurfaceView简介      
- 简单的说`SurfaceView`就是一个有`Surface`的`View`里面内嵌了一个专门用于绘制的`Surface`,`SurfaceView`控制这个`Surface`的格式和尺寸以及绘制位置.`SurfaceView`是一个`View`也许不够严谨，然而从定义中 `public class SurfaceView extends View`显示`SurfaceView`确实是派生自`View`，但是`SurfaceView`却有着自己的`Surface`，源码：
    ```java
    if (mWindow == null) {  
    mWindow = new MyWindow(this);  
    mLayout.type = mWindowType;  
	mLayout.gravity = Gravity.LEFT|Gravity.TOP;  
	mSession.addWithoutInputChannel(mWindow, mWindow.mSeq, mLayout,  
	mVisible ? VISIBLE : GONE, mContentInsets);  
    }  
    ```
    很明显，每个`SurfaceView`创建的时候都会创建一个`MyWindow`，`new MyWindow(this)`中的`this`正是`SurfaceView`自身，因此将`SurfaceView`和`window`绑定在一起，而前面提到过每个`window`对应一个`Surface`，所以`SurfaceView`也就内嵌了一个自己的`Surface`，可以认为`SurfaceView`是来控制`Surface`的位置和尺寸。传统`View`及其派生类的更新只能在`UI`线程，然而`UI`线程还同时处理其他交互逻辑，这就无法保证`view`更新的速度和帧率了，而`SurfaceView`可以用独立的线程来进行绘制，因此可以提供更高的帧率，例如游戏，摄像头取景等场景就比较适合用`SurfaceView`来实现。
- `Surface`是纵深排序`(Z-ordered)`的，这表明它总在自己所在窗口的后面。
- `Surfaceview`提供了一个可见区域，只有在这个可见区域内的`Surface`部分内容才可见，可见区域外的部分不可见，所以可以认为**`SurfaceView`就是展示`Surface`中数据的地方**,`Surface`就是管理数据的地方，`SurfaceView`就是展示数据的地方，只有通过`SurfaceView`才能展现`Surface`中的数据。
	![image](https://github.com/CharonChui/AndroidNote/blob/master/Pic/SurfaceView.gif)   
- `Surface`的排版显示受到视图层级关系的影响，它的兄弟视图结点会在顶端显示。这意味者`Surface`的内容会被它的兄弟视图遮挡，这一特性可以用来放置遮盖物`(overlays)`(例如，文本和按钮等控件)。注意，如果`Surface`上面有透明控件，那么它的每次变化都会引起框架重新计算它和顶层控件的透明效果，这会影响性能。surfaceview变得可见时，surface被创建；surfaceview隐藏前，surface被销毁。这样能节省资源。如果你要查看 surface被创建和销毁的时机，可以重载surfaceCreated(SurfaceHolder)和 surfaceDestroyed(SurfaceHolder)。**`SurfaceView`的核心在于提供了两个线程：`UI`线程和渲染线程**,两个线程通过“双缓冲”机制来达到高效的界面适时更新。

##SurfaceHolder简介
显示一个`Surface`的抽象接口，使你可以控制`Surface`的大小和格式以及在`Surface`上编辑像素，和监视`Surace`的改变。这个接口通常通过`SurfaceView`类实现。简单的说就是我们无法直接操作`Surface`只能通过`SurfaceHolder`这个接口来获取和操作`Surface`。
SurfaceHolder`中提供了一些`lockCanvas()`：获取一个Canvas对象，并锁定之。所得到的Canvas对象，其实就是Surface中一个成员。加锁的目的其实就是为了在绘制的过程中，Surface中的数据不会被改变。lockCanvas是为了防止同一时刻多个线程对同一canvas写入。


*从设计模式的角度来看,`Surface、SurfaceView、SurfaceHolder`实质上就是`MVC(Model-View-Controller)`，`Model`就是模型或者说是数据模型，更简单的可以理解成数据，在这里也就是`Surface`，`View`就是视图，代表用户交互界面，这里就是`SurfaceView`,`SurfaceHolder`就是`Controller.`*

---

- 邮箱 ：charon.chui@gmail.com  
- Good Luck! 


