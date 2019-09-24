using Libdl

lib = Sys.iswindows() ? "bin" : "lib"
exe = Sys.iswindows() ? ".exe" : ""
lib_path = joinpath(dirname(@__FILE__), "..", "deps", "usr", lib)
bin_path = joinpath(dirname(@__FILE__), "..", "deps", "usr", "bin")

ffmpeg = joinpath(bin_path, "ffmpeg$(exe)")
ffprobe = joinpath(bin_path, "ffprobe$(exe)")
x264 = joinpath(bin_path, "x264$(exe)")
x265 = joinpath(bin_path, "x265$(exe)")

libavcodec = joinpath(lib_path, "avcodec-58.$(Libdl.dlext)")
libavformat = joinpath(lib_path, "avformat-58.$(Libdl.dlext)")
libavutil = joinpath(lib_path, "avutil-56.$(Libdl.dlext)")
libswscale = joinpath(lib_path, "swscale-5.$(Libdl.dlext)")
libavfilter = joinpath(lib_path, "avfilter-7.$(Libdl.dlext)")
libavdevice = joinpath(lib_path, "avdevice-58.$(Libdl.dlext)")

join(stdout, readdir(lib_path), "\n")

@show isfile(ffmpeg)
@show isfile(ffprobe)
@show isfile(x264)
@show isfile(x265)

dlopen(libavcodec)
dlopen(libavformat)
dlopen(libavutil)
dlopen(libswscale)
dlopen(libavfilter)
dlopen(libavdevice)
