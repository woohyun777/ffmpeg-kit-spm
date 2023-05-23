// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let release = "min-gpl-5.1"

let frameworks = ["ffmpegkit": "d93b94541eabc5ce69e0519ff7753e8d50006cf347b09fdd92f4298edfc91bde", "libavcodec": "ee61b08908618668e2cea7dd212a2e6ba2713f0fd544788745b24aa0c53a29c9", "libavdevice": "7e5804aed37dbd20ae3571c53424b274d4a717e00044ec6bb28618e7a877b493", "libavfilter": "f7c34efd0d2b78b0d3bff9d61154b178e9cda784c12616895f94697762cf6da4", "libavformat": "9aad01ecda35df0fa952583ba83e381537d5251dda5f9a542a61d8aae7583ac6", "libavutil": "3552ee49202b5ebfb60fc3894b2c9a3418cb84cdf55c8125c1bcaa94d3d82246", "libswresample": "875aab3c67f30bc02e360d0ace20815916946029c59ba7060c2fb9ccd91a2a1f", "libswscale": "5f922a4a24e4cf296e805b5409070514f33af4f4a8a5067de296521082f93249"]

func xcframework(_ package: Dictionary<String, String>.Element) -> Target {
    let url = "https://github.com/woohyun777/ffmpeg-kit-spm/releases/download/\(release)/\(package.key).xcframework.zip"
    return .binaryTarget(name: package.key, url: url, checksum: package.value)
}

let linkerSettings: [LinkerSetting] = [
    .linkedFramework("AudioToolbox", .when(platforms: [.iOS])),
    .linkedFramework("AVFoundation", .when(platforms: [.iOS])),
    .linkedFramework("VideoToolbox", .when(platforms: [.iOS])),
    .linkedLibrary("z"),
    .linkedLibrary("lzma"),
    .linkedLibrary("bz2"),
    .linkedLibrary("iconv")
]

let libAVFrameworks = frameworks.filter({ $0.key != "ffmpegkit" })

let package = Package(
    name: "ffmpeg-kit-spm",
    platforms: [.iOS(.v12)],
    products: [
            .library(
                name: "FFmpeg-Kit",
                type: .dynamic,
                targets: ["FFmpeg-Kit", "ffmpegkit"])
        ],
    dependencies: [],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FFmpeg-Kit",
            dependencies: frameworks.map { .byName(name: $0.key) },
            linkerSettings: linkerSettings)
    ] + frameworks.map { xcframework($0) }
)
