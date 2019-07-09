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
    @test text_execute(()-> FFMPEG.exe("-version"))
    @test text_execute(()-> FFMPEG.run(FFMPEG.ffmpeg, "-version"))
end
