//
//  MPVViewController.swift
//  PlayerDemoIOS
//
//  Created by 周辉 on 2023/8/15.
//

import Foundation
import GLKit
import CoreMedia
import Libmpv

class MPVViewController: GLKViewController {
    var glView : GLKView!
    var glContext: EAGLContext!
    private var defaultFBO: GLint = -1

    var mpv: OpaquePointer!
    var mpvGL: OpaquePointer!

    var autoPlay: Bool = true
    var playUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        glView = self.view as! GLKView
        setupContext()
        setupMpv()
        
        if let url = playUrl, autoPlay {
            loadFile(url)
        }
    }
    func setupContext() {
        self.glContext = EAGLContext(api: .openGLES3)!
        if self.glContext == nil {
            print("create context fail ...")
            return
        }
        glView.context = self.glContext
        let isSuccess = EAGLContext.setCurrent(self.glContext)
        if !isSuccess {
            print("setup context fail")
        }
//        glView.bindDrawable()
//        glView.isOpaque = true
//        glView.enableSetNeedsDisplay = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        stop()
    }

    func setupMpv() {
        mpv = mpv_create()
        if mpv == nil {
            print("failed creating context\n")
            exit(1)
        }

        checkError(mpv_set_option_string(mpv, "cache-pause-initial", "yes"))
        checkError(mpv_set_option_string(mpv, "cache-secs", "120"))
        checkError(mpv_set_option_string(mpv, "cache-pause-wait", "3"))
        checkError(mpv_set_option_string(mpv, "keep-open", "yes"))
        checkError(mpv_set_option_string(mpv, "hwdec", machine == "x86_64" ? "no" : "auto-safe"))
        checkError(mpv_set_option_string(mpv, "vo", "libmpv"))

        checkError(mpv_initialize(mpv))

        let api = UnsafeMutableRawPointer(mutating: (MPV_RENDER_API_TYPE_OPENGL as NSString).utf8String)
        var initParams = mpv_opengl_init_params(
            get_proc_address: {
                (ctx, name) in
                return MPVViewController.getProcAddress(ctx, name)
            },
            get_proc_address_ctx: nil
        )

        withUnsafeMutablePointer(to: &initParams) { initParams in
            var params = [
                mpv_render_param(type: MPV_RENDER_PARAM_API_TYPE, data: api),
                mpv_render_param(type: MPV_RENDER_PARAM_OPENGL_INIT_PARAMS, data: initParams),
                mpv_render_param()
            ]

            if mpv_render_context_create(&mpvGL, mpv, &params) < 0 {
                puts("failed to initialize mpv GL context")
                exit(1)
            }
        }
    }


    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        guard let mpvGL else {
            return
        }

        // fill black background
        glClearColor(0, 0, 0, 0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))

        glGetIntegerv(UInt32(GL_FRAMEBUFFER_BINDING), &defaultFBO)

        var dims: [GLint] = [0, 0, 0, 0]
        glGetIntegerv(GLenum(GL_VIEWPORT), &dims)

        var data = mpv_opengl_fbo(
            fbo: Int32(defaultFBO),
            w: Int32(dims[2]),
            h: Int32(dims[3]),
            internal_format: 0
        )
        var flip: CInt = 1
        withUnsafeMutablePointer(to: &flip) { flip in
            withUnsafeMutablePointer(to: &data) { data in
                var params = [
                    mpv_render_param(type: MPV_RENDER_PARAM_OPENGL_FBO, data: data),
                    mpv_render_param(type: MPV_RENDER_PARAM_FLIP_Y, data: flip),
                    mpv_render_param()
                ]
                mpv_render_context_render(mpvGL, &params)
            }
        }
    }


    func loadFile(
        _ url: URL
    ) {
        var args = [url.absoluteString]
        var options = [String]()

        if !options.isEmpty {
            args.append(options.joined(separator: ","))
        }

        command("loadfile", args: args)
    }

    func command(
        _ command: String,
        args: [String?] = [],
        checkForErrors: Bool = true,
        returnValueCallback: ((Int32) -> Void)? = nil
    ) {
        guard mpv != nil else {
            return
        }
        var cargs = makeCArgs(command, args).map { $0.flatMap { UnsafePointer<CChar>(strdup($0)) } }
        defer {
            for ptr in cargs where ptr != nil {
                free(UnsafeMutablePointer(mutating: ptr!))
            }
        }
        print("\(command) -- \(args)")
        let returnValue = mpv_command(mpv, &cargs)
        if checkForErrors {
            checkError(returnValue)
        }
        if let cb = returnValueCallback {
            cb(returnValue)
        }
    }

    private func makeCArgs(_ command: String, _ args: [String?]) -> [String?] {
        if !args.isEmpty, args.last == nil {
            fatalError("Command do not need a nil suffix")
        }

        var strArgs = args
        strArgs.insert(command, at: 0)
        strArgs.append(nil)

        return strArgs
    }
    
    func play() {
        setFlagAsync("pause", false)
    }

    func pause() {
        setFlagAsync("pause", true)
    }

    func togglePlay() {
        command("cycle", args: ["pause"])
    }

    func stop() {
        command("stop")
    }
    
    var videoFormat: String {
        stringOrUnknown("video-format")
    }

    var videoCodec: String {
        stringOrUnknown("video-codec")
    }

    var currentVo: String {
        stringOrUnknown("current-vo")
    }

    var width: String {
        stringOrUnknown("width")
    }

    var height: String {
        stringOrUnknown("height")
    }

    var videoBitrate: Double {
        mpv.isNil ? 0.0 : getDouble("video-bitrate")
    }

    var audioFormat: String {
        stringOrUnknown("audio-params/format")
    }

    var audioCodec: String {
        stringOrUnknown("audio-codec")
    }

    var currentAo: String {
        stringOrUnknown("current-ao")
    }

    var audioChannels: String {
        stringOrUnknown("audio-params/channels")
    }

    var audioSampleRate: String {
        stringOrUnknown("audio-params/samplerate")
    }

    var duration: CMTime {
        CMTime.secondsInDefaultTimescale(mpv.isNil ? -1 : getDouble("duration"))
    }

    private func setFlagAsync(_ name: String, _ flag: Bool) {
        guard mpv != nil else { return }
        var data: Int = flag ? 1 : 0
        mpv_set_property_async(mpv, 0, name, MPV_FORMAT_FLAG, &data)
    }

    func setDoubleAsync(_ name: String, _ value: Double) {
        guard mpv != nil else { return }
        var data = value
        mpv_set_property_async(mpv, 0, name, MPV_FORMAT_DOUBLE, &data)
    }

    private func getDouble(_ name: String) -> Double {
        guard mpv != nil else { return 0.0 }
        var data = Double()
        mpv_get_property(mpv, name, MPV_FORMAT_DOUBLE, &data)
        return data
    }

    private func getInt(_ name: String) -> Int {
        guard mpv != nil else { return 0 }
        var data = Int64()
        mpv_get_property(mpv, name, MPV_FORMAT_INT64, &data)
        return Int(data)
    }

    func getString(_ name: String) -> String? {
        let cstr = mpv_get_property_string(mpv, name)
        let str: String? = cstr == nil ? nil : String(cString: cstr!)
        mpv_free(cstr)
        return str
    }
    
    private func stringOrUnknown(_ name: String) -> String {
        mpv.isNil ? "unknown" : (getString(name) ?? "unknown")
    }


    private func checkError(_ status: CInt) {
        if status < 0 {
            print("MPV API error: \(String(cString: mpv_error_string(status)))\n")
        }
    }

    private var machine: String {
        var systeminfo = utsname()
        uname(&systeminfo)
        return withUnsafeBytes(of: &systeminfo.machine) { bufPtr -> String in
            let data = Data(bufPtr)
            if let lastIndex = data.lastIndex(where: { $0 != 0 }) {
                return String(data: data[0 ... lastIndex], encoding: .isoLatin1)!
            } else {
                return String(data: data, encoding: .isoLatin1)!
            }
        }
    }
    private static func getProcAddress(_: UnsafeMutableRawPointer?, _ name: UnsafePointer<Int8>?) -> UnsafeMutableRawPointer? {
        let symbolName = CFStringCreateWithCString(kCFAllocatorDefault, name, CFStringBuiltInEncodings.ASCII.rawValue)
        let identifier = CFBundleGetBundleWithIdentifier("com.apple.opengles" as CFString)

        return CFBundleGetFunctionPointerForName(identifier, symbolName)
    }
}


/**
A protocol for making generic type constraints of optionals.

- Note: It's intentionally not including `associatedtype Wrapped` as that limits a lot of the use-cases.
*/
public protocol _DefaultsOptionalType: ExpressibleByNilLiteral {
    /**
    This is useful as you cannot compare `_OptionalType` to `nil`.
    */
    var isNil: Bool { get }
}

extension Optional: _DefaultsOptionalType {
    public var isNil: Bool { self == nil }
}

extension CMTime {
    static let defaultTimescale: CMTimeScale = 1_000_000

    static func secondsInDefaultTimescale(_ seconds: TimeInterval) -> CMTime {
        CMTime(seconds: seconds, preferredTimescale: CMTime.defaultTimescale)
    }
}
