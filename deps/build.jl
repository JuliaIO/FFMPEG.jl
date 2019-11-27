using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))

# These are the two binary objects we care about
products = Product[
    ExecutableProduct(prefix, "ffmpeg", :ffmpeg),
    ExecutableProduct(prefix, "ffprobe", :ffprobe),

    LibraryProduct(prefix, ["libavcodec","avcodec"], :libavcodec),
    LibraryProduct(prefix, ["libavformat","avformat"], :libavformat),
    LibraryProduct(prefix, ["libavutil","avutil"], :libavutil),
    LibraryProduct(prefix, ["libswscale","swscale"], :libswscale),
    LibraryProduct(prefix, ["libavfilter","avfilter"], :libavfilter),
    LibraryProduct(prefix, ["libavdevice","avdevice"], :libavdevice),
]

dependencies = [
    "build_Bzip2.v1.0.6.jl",
    "build_Zlib.v1.2.11.jl",
    "build_libfdk_aac.v0.1.6.jl",
    "build_FriBidi.v1.0.5.jl",
    "build_FreeType2.v2.10.1.jl",
    "build_libass.v0.14.0.jl",
    "build_LAME.v3.100.0.jl",
    "build_Ogg.v1.3.3.jl",
    "build_libvorbis.v1.3.6.jl",
    "build_LibVPX.v1.8.1.jl",
    "build_x264.v2019.5.25.jl",
    "build_x265.v3.0.0.jl",
    "build_OpenSSL.v1.1.1+c.jl",
    "build_Opus.v1.3.1.jl",
    "build_FFMPEG.v4.1.0.jl",
]

for dependency in dependencies
    file = joinpath(@__DIR__, dependency)
    # it's a bit faster to run the build in an anonymous module instead of
    # starting a new julia process

    # Build the dependencies
    Mod = @eval module Anon end
    Mod.include(file)
end

# Finally, write out a deps.jl file
write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
