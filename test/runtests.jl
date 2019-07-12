using FFMPEG
using Test

text_execute(f) = try
    f()
    return true
catch e
    @warn "can't execute" exception=e
    return false
end

@testset "FFMPEG.jl" begin
    @show FFMPEG.versioninfo()
    @test text_execute(() -> FFMPEG.exe("-version"))
    @test text_execute(() -> FFMPEG.exe(`-version`))
    @test text_execute(() -> FFMPEG.exe(`-version`, collect=true))
    @test text_execute(() -> FFMPEG.ffmpeg_exe(`-version`))
    @test text_execute(() -> FFMPEG.ffprobe_exe(`-version`))
    @test text_execute(() -> ffmpeg`-version`)
    @test text_execute(() -> ffprobe`-version`)
    @test text_execute(() -> @ffmpeg_env run(`$ffmpeg -version`))
end
