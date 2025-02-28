## Python

```bash
Traceback (most recent call last):
  File "/home/diehlpk/git/AiCode_DeepSeek/Stream/stream.py", line 58, in <module>
    main()
  File "/home/diehlpk/git/AiCode_DeepSeek/Stream/stream.py", line 27, in main
    B_np = np.frombuffer(B_shm.get_obj(), dtype=np.float64)
AttributeError: 'c_double_Array_100000000' object has no attribute 'get_obj'
```

## Julia

```bash
ERROR: LoadError: UndefVarError: `nthreads` not defined in local scope
Stacktrace:
 [1] stream_triad!(A::Vector{Float64}, B::Vector{Float64}, C::Vector{Float64}, scalar::Float64)
   @ Main ~/git/AiCode_DeepSeek/Stream/stream.jl:5
 [2] main()
   @ Main ~/git/AiCode_DeepSeek/Stream/stream.jl:35
 [3] top-level scope
   @ ~/git/AiCode_DeepSeek/Stream/stream.jl:58
in expression starting at /home/diehlpk/git/AiCode_DeepSeek/Stream/stream.jl:58
```