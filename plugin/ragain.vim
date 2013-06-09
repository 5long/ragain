function! s:run(reset)
  if (a:reset || !s:has_set_cmd())
    call s:set_and_run()
  else
    call s:run_cmd()
  endif
endfunction

function! s:has_set_cmd()
  return exists("t:runagain_cmd")
endfunction

function! s:set_and_run(...)
  if (a:0 == 1)
    call s:set_cmd_as(a:1)
  else
    call s:set_cmd()
  endif

  call s:run_cmd()
endfunction

function! s:set_cmd()
  if (exists("b:runagain_cmd"))
    call s:set_cmd_as(b:runagain_cmd)
  else
    throw "Ragain: b:runagain_cmd not found"
  endif
endfunction

function! s:set_cmd_as(cmd)
  let t:runagain_cmd = a:cmd
endfunction

function! s:run_cmd()
  exec t:runagain_cmd
endfunction

command -bang RagainRun call s:run("!" == "<bang>")
command -nargs=1 RagainSetAndRun call s:set_and_run(<q-args>)

nnoremap <silent> <unique> <Plug>RagainRun :RagainRun<CR>
nnoremap <silent> <unique> <Plug>RagainResetAndRun :RagainRun!<CR>
