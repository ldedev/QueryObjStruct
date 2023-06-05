cls

start "" "http://localhost:8093"
v  -cg -skip-unused -usecache -d vweb_livereload -o ./bin/debug/main.exe watch crun .
