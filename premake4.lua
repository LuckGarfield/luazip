-- premake4.lua
-- > tool\premake4 --file=premake4.lua --os=windows  vs2012
-- > devenv lua_libz.sln /build "Release|Win32"
-- >premake4 --file=premake4.lua --os=linux --platform=x64 gmake


-- define
	local LUA_PKG_NAME = 'lua-5.3.2'
	local LIBZ_PKG_NAME = 'zlib-1.2.6'
	
	local LUA_ROOT_PATH = 'src/lua/'..LUA_PKG_NAME..'/src'
	local ZIP_ROOT_PATH = 'src/zip/'..LIBZ_PKG_NAME
	local MINIZIP_ROOT_PATH = 'src/zip/'..LIBZ_PKG_NAME..'/contrib/minizip'
	local ZIPTEST_ROOT_PATH = 'src/ziptest'
	
	print(ZIP_ROOT_PATH)
-- solution
solution 'lua_libz'
    configurations {'Debug', 'Release'}
    platforms {'native','x32', 'x64'}
	location "./build"

	configuration "Debug"
    targetdir "debug/bin"
	objdir "debug/obj"
	-- The libdirs function specifies the library search paths.
	--libdirs 'debug/lib'
	implibdir 'debug/lib'	
	if os.get() == "windows" then
        defines {'_WINDOWS','_WIN32','_CRT_SECURE_NO_WARNINGS','_CRT_SECURE_NO_DEPRECATE'}
    end												 

    configuration "Release"
    targetdir "release/bin"
	objdir "release/obj"
	--libdirs 'release/lib'
	implibdir 'release/lib'	
	if os.get() == "windows" then
		defines {'_WINDOWS','_WIN32','_CRT_SECURE_NO_WARNINGS','_CRT_SECURE_NO_DEPRECATE'}
    end

    -- the lua library
    project 'liblua'
        targetname 'liblua' -- rename the target library to lua
        kind 'SharedLib'
        language 'C'
		includedirs {LUA_ROOT_PATH}
		if os.get() == "windows" then
			defines {'_WIN32','LUA_BUILD_AS_DLL'}
		end
        files {LUA_ROOT_PATH..'/*.c'}
	    excludes {LUA_ROOT_PATH.."/lua.c", LUA_ROOT_PATH.."/luac.c"}

	-- the lua interpret
    project 'lua'
        kind 'ConsoleApp'
        language 'C'
        links 'liblua'
        if os.get() == "linux" then
            links {'m'}
		else 
			defines {'_WIN32'}
        end
        files {LUA_ROOT_PATH.."/lua.c"}
		
    -- the libz library
    project 'libz'
        targetname 'libz' -- rename the target library to lua
        kind 'SharedLib'
        language 'C'
		includedirs {ZIP_ROOT_PATH}
		if os.get() == "windows" then
			defines {'ZLIB_DLL'}
		end
		
        files {ZIP_ROOT_PATH..'/*.c'}
		
	--  minizip 
    project 'minizip'
        kind 'ConsoleApp'
        language 'C'
        links 'libz'
  		if os.get() == "windows" then
			defines {'ZLIB_DLL','ZLIB_INTERNAL'}
		end
		includedirs {ZIP_ROOT_PATH,MINIZIP_ROOT_PATH}
        files {MINIZIP_ROOT_PATH..'/*.c'}
		excludes {MINIZIP_ROOT_PATH.."/miniunz.c"}

	--  miniunz
    project 'miniunz'
        kind 'ConsoleApp'
        language 'C'
        links 'libz'
     	if os.get() == "windows" then
			defines {'ZLIB_DLL','ZLIB_INTERNAL'}
		end
		includedirs {ZIP_ROOT_PATH,MINIZIP_ROOT_PATH}
        files {MINIZIP_ROOT_PATH..'/*.c'}
		excludes {MINIZIP_ROOT_PATH.."/minizip.c"}		
