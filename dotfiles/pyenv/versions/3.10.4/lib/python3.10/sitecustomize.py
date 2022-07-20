try:
    import builtins
    from devtools import debug
except ImportError:
    pass
else:
    builtins.debug = debug
