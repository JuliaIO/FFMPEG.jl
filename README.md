# FFMPEG

[![Build Status](https://travis-ci.com/JuliaIO/FFMPEG.jl.svg?branch=master)](https://travis-ci.com/JuliaIO/FFMPEG.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/JuliaIO/FFMPEG.jl?svg=true)](https://ci.appveyor.com/project/JuliaIO/FFMPEG-jl)
[![Codecov](https://codecov.io/gh/JuliaIO/FFMPEG.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaIO/FFMPEG.jl)
[![Build Status](https://api.cirrus-ci.com/github/JuliaIO/FFMPEG.jl.svg)](https://cirrus-ci.com/github/JuliaIO/FFMPEG.jl)

This package simply offers:

```julia
# simple way to invoke ffmpeg:
FFMPEG.exe("-version")
FFMPEG.run(FFMPEG.ffmpeg, "-version")
# the AV libraries:
FFMPEG.libavcodec
FFMPEG.libavformat
FFMPEG.libavutil
FFMPEG.libswscale
FFMPEG.libavdevice
FFMPEG.libavfilter

# and for good measures:
FFMPEG.versioninfo()
```
