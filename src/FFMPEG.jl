module FFMPEG

using Reexport, Libdl

@reexport using FFMPEG_jll

av_version(v) = VersionNumber(v >> 16, (v >> 8) & 0xff, v & 0xff)

have_avcodec()    = Libdl.dlopen_e(libavcodec)    != C_NULL
have_avformat()   = Libdl.dlopen_e(libavformat)   != C_NULL
have_avutil()     = Libdl.dlopen_e(libavutil)     != C_NULL
have_swscale()    = Libdl.dlopen_e(libswscale)    != C_NULL
have_avdevice()   = Libdl.dlopen_e(libavdevice)   != C_NULL
have_avfilter()   = Libdl.dlopen_e(libavfilter)   != C_NULL
#have_avresample() = @isdefined(libavresample) && Libdl.dlopen_e(libavresample) != C_NULL
#have_swresample() = @isdefined(libswresample) && Libdl.dlopen_e(libswresample) != C_NULL

_avcodec_version()    = have_avcodec()    ? av_version(ccall((:avcodec_version,    libavcodec),    UInt32, ())) : v"0"
_avformat_version()   = have_avformat()   ? av_version(ccall((:avformat_version,   libavformat),   UInt32, ())) : v"0"
_avutil_version()     = have_avutil()     ? av_version(ccall((:avutil_version,     libavutil),     UInt32, ())) : v"0"
_swscale_version()    = have_swscale()    ? av_version(ccall((:swscale_version,    libswscale),    UInt32, ())) : v"0"
_avdevice_version()   = have_avdevice()   ? av_version(ccall((:avdevice_version,   libavdevice),   UInt32, ())) : v"0"
_avfilter_version()   = have_avfilter()   ? av_version(ccall((:avfilter_version,   libavfilter),   UInt32, ())) : v"0"
#_avresample_version() = have_avresample() ? av_version(ccall((:avresample_version, libavresample), UInt32, ())) : v"0"
#_swresample_version() = have_swresample() ? av_version(ccall((:swresample_version, libswresample), UInt32, ())) : v"0"

function versioninfo()
    println("Using ffmpeg")
    println("AVCodecs version $(_avcodec_version())")
    println("AVFormat version $(_avformat_version())")
    println("AVUtil version $(_avutil_version())")
    println("SWScale version $(_swscale_version())")
    println("AVDevice version $(_avdevice_version())")
    println("AVFilters version $(_avfilter_version())")
    #println("AVResample version $(_avresample_version())")
    #println("SWResample version $(_swresample_version())")
end

"""
    collectexecoutput(exec::Cmd) -> Array of output lines

Takes the dominant output (stdout or stderr) from ffmpeg.
"""
function collectexecoutput(exec::Cmd)
    out_s, err_s = readexecoutput(exec)
    return (length(out_s) > length(err_s)) ? out_s : err_s
end

"""
    readexecoutput(exec::Cmd) -> (out, err)

Takes the output stdout and stderr from the input command.

Returns a Tuple of String vectors.
"""
function readexecoutput(exec::Cmd)
    out = Pipe(); err = Pipe()
    p = Base.open(pipeline(ignorestatus(exec), stdout=out, stderr=err))
    close(out.in); close(err.in)
    err_s = readlines(err); out_s = readlines(out)
    return out_s, err_s
end

"""
    exe(arg)

Execute the given command literal as an argument to the given executable.

## Examples

```jldoctest
julia> FFMPEG.exe(`-version`)
ffmpeg version 4.1 Copyright (c) 2000-2018 the FFmpeg developers
built with clang version 6.0.1 (tags/RELEASE_601/final)
[...]
```
"""
function exe(arg::Cmd; command = ffmpeg, collect = false)
    if collect
        command() do command
            collectexecoutput(`$command $arg`)
        end
    else
        command() do command
            Base.run(`$command $arg`)
        end
    end
end

exe(arg::String; kwargs...) = exe(Cmd([arg]); kwargs...)

"""
    ffmpeg_exe(arg::Cmd)
    ffmpeg_exe(args::String...)

Execute the given arguments as arguments to the `ffmpeg` executable.
"""
ffmpeg_exe(args...) = exe(args...; command = ffmpeg)

"""
    ffprobe_exe(arg::Cmd)
    ffprobe_exe(args::String...)

Execute the given arguments as arguments to the `ffprobe` executable.
"""
ffprobe_exe(args...) = exe(args...; command = ffprobe)

"""
    ffmpeg\`<ARGS>\`

Execute the given arguments as arguments to the `ffmpeg` executable.
"""
macro ffmpeg_cmd(arg)
    esc(:(ffmpeg_exe($arg)))
end

"""
    ffprobe\`<ARGS>\`

Execute the given arguments as arguments to the `ffprobe` executable.
"""
macro ffprobe_cmd(arg)
    esc(:(ffprobe_exe($arg)))
end

export exe, ffmpeg_exe, ffprobe_exe, @ffmpeg_cmd, @ffprobe_cmd, ffmpeg, ffprobe, libavcodec, libavformat, libavutil, libswscale, libavfilter, libavdevice

end # module
