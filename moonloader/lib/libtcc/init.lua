local libtcc_path = getWorkingDirectory() .. [[\lib\libtcc]]

local m = {}
m.VERSION = "1"

local ffi = require("ffi")

ffi.cdef[[
    // see libtcc.h for documentation
    typedef struct TCCState TCCState;
    typedef void *TCCReallocFunc(void *ptr, unsigned long size);
    typedef void TCCErrorFunc(void *opaque, const char *msg);
    typedef int TCCBtFunc(void *udata, void *pc, const char *file, int line, const char* func, const char *msg);
    
    void tcc_set_realloc(TCCReallocFunc *my_realloc);
    TCCState *tcc_new(void);
    void tcc_delete(TCCState *s);
    void tcc_set_lib_path(TCCState *s, const char *path);
    void tcc_set_error_func(TCCState *s, void *error_opaque, TCCErrorFunc *error_func);
    int tcc_set_options(TCCState *s, const char *str);
    int tcc_add_include_path(TCCState *s, const char *pathname);
    int tcc_add_sysinclude_path(TCCState *s, const char *pathname);
    void tcc_define_symbol(TCCState *s, const char *sym, const char *value);
    void tcc_undefine_symbol(TCCState *s, const char *sym);
    int tcc_add_file(TCCState *s, const char *filename);
    int tcc_compile_string(TCCState *s, const char *buf);
    int tcc_set_output_type(TCCState *s, int output_type);
    int tcc_add_library_path(TCCState *s, const char *pathname);
    int tcc_add_library(TCCState *s, const char *libraryname);
    int tcc_add_symbol(TCCState *s, const char *name, const void *val);
    int tcc_output_file(TCCState *s, const char *filename);
    int tcc_run(TCCState *s, int argc, char **argv);
    int tcc_relocate(TCCState *s1);
    void *tcc_get_symbol(TCCState *s, const char *name);
    void tcc_list_symbols(TCCState *s, void *ctx, void (*symbol_cb)(void *ctx, const char *name, const void *val));
    void *_tcc_setjmp(TCCState *s1, void *jmp_buf, void *top_func, void *longjmp);
    void tcc_set_backtrace_func(TCCState *s1, void* userdata, TCCBtFunc*);
    
    enum {
        TCC_OUTPUT_MEMORY     = 1, 
        TCC_OUTPUT_EXE        = 2,
        TCC_OUTPUT_OBJ        = 3,
        TCC_OUTPUT_DLL        = 4, 
        TCC_OUTPUT_PREPROCESS = 5 
    };
]]

local tcc = ffi.load(libtcc_path .. [[\libtcc]])

m.set_realloc = function(my_realloc) 
    tcc.tcc_set_realloc(my_realloc) 
end

m.new = function(output)
    local s = ffi.gc(tcc.tcc_new(), function(cdata)
        cdata:delete()
    end)
    s:set_output_type(output or m.OUTPUT.MEMORY)

    s:set_error_func(nil, function(opaque, msg)
        if opaque ~= nil then
            print("opaque", opaque)
        end
        print(ffi.string(msg))
    end)

    s:add_include_path(libtcc_path)
    s:add_library_path(libtcc_path)
    
    s:add_include_path(libtcc_path .. [[\include]])
    s:add_library_path(libtcc_path .. [[\lib]])

    s:add_include_path(libtcc_path .. [[\libtcc]])
    s:add_library_path(libtcc_path .. [[\libtcc]])
    
    s:add_library("msvcrt")
    s:add_library("kernel32")
    s:add_library("user32")
    s:add_library("ws2_32")
    
    s:add_include_path(libtcc_path .. [[\d3d9]])
    s:add_library_path(libtcc_path .. [[\d3d9]])
    s:add_library("d3d9")
    
    s:add_include_path(libtcc_path .. [[\lua]])
    s:add_library_path(libtcc_path .. [[\lua]])
    s:add_library("lua51")
    
    s:define_symbol("__thiscall", "__attribute__((__thiscall__))")
    -- s:define_symbol("__cdecl", "__attribute__((__cdecl__))")
    s:define_symbol("__stdcall", "__attribute__((__stdcall__))")
    s:define_symbol("__naked", "__attribute__((__naked__))")

    return s
end

m.delete = function(s) 
    tcc.tcc_delete(s) 
end

m.set_lib_path = function(s, path)
    tcc.tcc_set_lib_path(s, path)
end

m.set_error_func = function(s, error_opaque, error_func)
    tcc.tcc_set_error_func(s, error_opaque, error_func)
end

m.set_options = function(s, str)
    return tcc.tcc_set_options(s, str)
end

m.add_include_path = function(s, pathname)
    return tcc.tcc_add_include_path(s, pathname)
end

m.add_sysinclude_path = function(s, pathname)
    return tcc.tcc_add_sysinclude_path(s, pathname)
end

m.define_symbol = function(s, sym, value)
    tcc.tcc_define_symbol(s, sym, value)
end
m.undefine_symbol = function(s, sym)
    tcc.tcc_undefine_symbol(s, sym)
end
m.add_file = function(s, filename)
    return tcc.tcc_add_file(s, filename)
end
m.compile_string = function(s, buf)
    local res = tcc.tcc_compile_string(s, buf)
    assert(res ~= -1, "Compilation failed")
    return res 
end

m.set_output_type = function(s, output_type)
    return tcc.tcc_set_output_type(s, output_type)
end

m.add_library_path = function(s, pathname)
    return tcc.tcc_add_library_path(s, pathname)
end

m.add_library = function(s, libraryname)
    return tcc.tcc_add_library(s, libraryname)
end

m.add_symbol = function(s, name, val)
    return tcc.tcc_add_symbol(s, name, val)
end

m.output_file = function(s, filename)
    return tcc.tcc_output_file(s, filename)
end

m.run = function(s, argc, argv)
    return tcc.tcc_run(s, argc, argv)
end

m.relocate = function(s)
    local res = tcc.tcc_relocate(s)
    assert(res >= 0, ("Relocation failed. Code: %d"):format(res))
    return res
end

m.get_symbol = function(s, name, cdecl)
    local symbol = tcc.tcc_get_symbol(s, name)
    return cdecl and ffi.cast(cdecl, symbol) or symbol
end

m.list_symbols = function(s, ctx, symbol_cb)
    tcc.tcc_list_symbols(s, ctx, symbol_cb)
end

m._tcc_setjmp = function(s, jmp_buf, top_func, longjmp)
    return tcc._tcc_setjmp(s, jmp_buf, top_func, longjmp)
end

m.set_backtrace_func = function(s, userdata, backtrace_func)
    tcc.tcc_set_backtrace_func(s, userdata, backtrace_func)
end

local tccstate_mt = {}
tccstate_mt.__index = tccstate_mt
tccstate_mt.set_realloc = m.set_realloc
tccstate_mt.new = m.new
tccstate_mt.delete = m.delete
tccstate_mt.set_lib_path = m.set_lib_path
tccstate_mt.set_error_func = m.set_error_func
tccstate_mt.set_options = m.set_options
tccstate_mt.add_include_path = m.add_include_path
tccstate_mt.add_sysinclude_path = m.add_sysinclude_path
tccstate_mt.define_symbol = m.define_symbol
tccstate_mt.undefine_symbol = m.undefine_symbol
tccstate_mt.add_file = m.add_file
tccstate_mt.compile_string = m.compile_string
tccstate_mt.set_output_type = m.set_output_type
tccstate_mt.add_library_path = m.add_library_path
tccstate_mt.add_library = m.add_library
tccstate_mt.add_symbol = m.add_symbol
tccstate_mt.output_file = m.output_file
tccstate_mt.run = m.run
tccstate_mt.relocate = m.relocate
tccstate_mt.get_symbol = m.get_symbol
tccstate_mt.list_symbols = m.list_symbols
tccstate_mt._tcc_setjmp = m._tcc_setjmp
tccstate_mt.set_backtrace_func = m.set_backtrace_func

ffi.metatype("TCCState", tccstate_mt)

m.OUTPUT = setmetatable({}, {
    __index = function(t, k)
        return ffi.C["TCC_OUTPUT_" .. k]
    end,
    __newindex = function(t, k, v)
        assert(false, "Read-only table")
    end
})

m.cdef = function(t) return t end

return m