[cython]

python_version = 3.12
exclude = pyx/typeshed/|pyx/test-data/|pyx/lib-rt/

# Options that affect type checking
strict = True
allow_redefinition_new = True
local_partial_types = True
disallow_any_unimported = True
warn_unreachable = True
enable_error_code = ignore-without-code,redundant-expr
enable_incomplete_feature = PreciseTupleType
# Plugins or custom behaviour
always_false = PYX
plugins = cython.plugins.proper_plugin

# Options that affect output
pretty = True
show_error_code_links = True
show_traceback = True

# Miscellaneous
sqlite_cache = True
