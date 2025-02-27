## Python

```bash
Traceback (most recent call last):
  File "/home/diehlpk/git/AiCode_DeepSeek/Stream/stream.py", line 58, in <module>
    main()
  File "/home/diehlpk/git/AiCode_DeepSeek/Stream/stream.py", line 27, in main
    B_np = np.frombuffer(B_shm.get_obj(), dtype=np.float64)
AttributeError: 'c_double_Array_100000000' object has no attribute 'get_obj'
```
