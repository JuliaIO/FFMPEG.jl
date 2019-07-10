# FFMPEG

[![Build Status](https://travis-ci.com/JuliaIO/FFMPEG.jl.svg?branch=master)](https://travis-ci.com/JuliaIO/FFMPEG.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/JuliaIO/FFMPEG.jl?svg=true)](https://ci.appveyor.com/project/JuliaIO/FFMPEG-jl)
[![Codecov](https://codecov.io/gh/JuliaIO/FFMPEG.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaIO/FFMPEG.jl)
[![Build Status](https://api.cirrus-ci.com/github/JuliaIO/FFMPEG.jl.svg)](https://cirrus-ci.com/github/JuliaIO/FFMPEG.jl)

This package simply offers:

```julia
# a simple way to invoke ffmpeg:
FFMPEG.exe("-version")
@ffmpeg_env run(`$ffmpeg -version`) # note the $ffmpeg
ffmpeg_exe("-version")
ffmpeg_exe(`-version`)
ffprobe_exe("-version") # we wrap FFPROBE too!
# the AV libraries:
FFMPEG.libavcodec
FFMPEG.libavformat
FFMPEG.libavutil
FFMPEG.libswscale
FFMPEG.libavdevice
FFMPEG.libavfilter

# and for good measure:
FFMPEG.versioninfo()
```

For a high level API to the AV libraries in `libav`, have a look at [VideoIO.jl](https://github.com/JuliaIO/VideoIO.jl/).

This package is made to be included into packages that just need the ffmpeg binaries + executables, and don't want to take on the 3.6 second load time of VideoIO.
