# PlayerDemo

这个项目在 SwiftUI 中集成了 KSPlayer 和 mpv，它仅做了简单的集成，而且仅跑在 iOS 真机上测试通过，其他平台(tvOS, macOS, iPhone Simulator)均未测试。

功能：

- KSPlayer 与 mpv 两款播放器内核
- 打开文件选取视频
- 输入视频链接播放视频


通过测试发现 mpv 不能正常解码 HDR 视频，当打开 HDR 视频时候画面全是蓝色背景，声音正常输出。
而 KSPlayer 可以正常解码 HDR 视频，并且在 iPhone 上正常输出 HDR 画面，并不是 tonemapping 色调映射后的画面。

mpv 底层用了 FFmpeg，KSPlayer 这个库也用了 FFmpeg，所以直接导入 MPVKit 会冲突，所以需要手动将 mpv 需要的库导入进项目。

mpv 的使用方法是用的命令行形式，它的视频输出需要[通过 OpenGL 层进行绘制](https://github.com/FaiChou/PlayerDemo-iOS/blob/main/PlayerDemoIOS/MPV/MPVViewController.swift#L121C17-L121C42)。




Ref:

- [yatte](https://github.com/yattee/yattee)
- [MPVKit](https://github.com/cxfksword/MPVKit)
