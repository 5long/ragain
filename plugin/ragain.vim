let s:type_funcref = type(function("type"))
let s:type_string = type("")

function! s:run(reset)
  if a:reset || !s:has_set_cmd()
    call s:set_and_run()
  else
    call s:run_cmd()
  endif
endfunction

function! s:has_set_cmd()
  return exists("t:ragain_cmd")
endfunction

function! s:set_and_run(...)
  if a:0 == 1
    call s:set_cmd_as(a:1)
  else
    call s:set_cmd()
  endif

  call s:run_cmd()
endfunction

function! s:set_cmd()
  if exists("b:ragain_cmd")
    call s:set_cmd_as(b:ragain_cmd)
  else
    throw "Ragain: b:ragain_cmd not found"
  endif
endfunction

function! s:set_cmd_as(cmd)
  if type(a:cmd) == s:type_string
    let t:ragain_cmd = a:cmd
  elseif type(a:cmd) == s:type_funcref
    let t:ragain_cmd = a:cmd()
  else
    raise "Ragain: can't use " . a:cmd . " as command"
  end
endfunction

function! s:run_cmd()
  exec t:ragain_cmd
endfunction

command -bang RagainRun
      \ call s:run("!" == "<bang>")
command -nargs=1 -complete=command RagainSetAndRun
      \ call s:set_and_run(<q-args>)

nnoremap <silent> <unique> <Plug>RagainRun :RagainRun<CR>
nnoremap <silent> <unique> <Plug>RagainResetAndRun :RagainRun!<CR>
