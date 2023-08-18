# PlayerDemo

这个项目在 SwiftUI 中集成了 KSPlayer 和 mpv，它仅做了简单的集成，而且仅跑在 iOS 真机上测试通过，其他平台(tvOS, macOS, iPhone Simulator)均未测试。

功能：

- KSPlayer 与 mpv 两款播放器
- 打开文件选取视频
- 输入视频链接播放视频


通过测试发现 mpv 不能正常解码 HDR 视频，当打开 HDR 视频时候画面全是蓝色背景，声音正常输出。
而 KSPlayer 可以正常解码 HDR 视频，并且在 iPhone 上正常输出 HDR 画面，并不是 tonemapping 色调映射后的画面。

mpv 底层用了 FFmpeg，KSPlayer 这个库也用了 FFmpeg，所以直接导入 MPVKit 会冲突，所以需要手动将 mpv 需要的库导入进项目。

mpv 的使用方法是用命令行形式，它的视频输出需要[通过 OpenGL 层进行绘制](https://github.com/FaiChou/PlayerDemo-iOS/blob/main/PlayerDemoIOS/MPV/MPVViewController.swift#L121C17-L121C42)。而且在 SwiftUI 中需要使用 delegate + Represental 形式进行交互，比如播放暂停以及获取播放进度视频参数等。

而 KSPlayer 提供了一个完整的播放器，拿来即用，直接提供一个 url 即可。而且 KSPlayer 内部使用了 AVPlayer 和 Metal 两个播放器内核，可以实现 HDR 视频的播放。

个人猜测 KSPlayer 支持 HDR 是因为它用 Metal，而 mpv 用的 OpenGL，如果使用 Metal 重构 OpenGL 这层视频渲染逻辑应该也可以支持 HDR。

这里有一个 [hdr-fix 的 mpv 分支](https://github.com/plexinc/mpv/tree/alex/hdr-fix)，但在 Apple Silicon 上编译失败，也没有找到已经编译好的 framework。

所以暂时就这样吧。


Ref:

- [yatte](https://github.com/yattee/yattee)
- [MPVKit](https://github.com/cxfksword/MPVKit)
