module FFMPEG

using BinaryProvider

const libpath = joinpath(@__DIR__, "..", "deps", "usr", "lib")

if Sys.iswindows()
    const execenv = ("PATH" => string(libpath,";", Sys.BINDIR))
elseif Sys.isapple()
    const execenv = ("DYLD_LIBRARY_PATH" => libpath)
else
    const execenv = ("LD_LIBRARY_PATH" => libpath)
end


# Load in `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    println("Deps path: $depsjl_path")
    error("FFMPEG not installed properly, run `] build FFMPEG`, restart Julia and try again")
end

include(depsjl_path)


av_version(v) = VersionNumber(v>>16,(v>>8)&0xff,v&0xff)

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

#swresample_dir = joinpath(dirname(@__FILE__), "ffmpeg", "SWResample", "v$(_swresample_version().major)")

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
    @ffmpeg arg

Runs `arg` within the build environment of FFMPEG.

## Examples

```jldoctest
julia> @ffmpeg run(`$ffmpeg -version`)
ffmpeg version 4.1 Copyright (c) 2000-2018 the FFmpeg developers
built with clang version 6.0.1 (tags/RELEASE_601/final)
[...]
```
"""
macro ffmpeg(arg)
    return quote
        withenv(execenv) do
            $arg
        end
    end
end

"""
    exe(commands...)

Execute the given commands as arguments to the `ffmpeg` executable.

## Examples

```jldoctest
julia> FFMPEG.exe("-version")
ffmpeg version 4.1 Copyright (c) 2000-2018 the FFmpeg developers
built with clang version 6.0.1 (tags/RELEASE_601/final)
[...]
```
"""
function exe(commands::AbstractString...)

    withenv(execenv) do
        Base.run(Cmd([ffmpeg, commands...]))
    end

end

export ffmpeg, @ffmpeg

end # module
