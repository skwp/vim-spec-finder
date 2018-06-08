" Find the related spec for any file you open.
function! s:RelatedSpec()
  let l:fullpath = expand("%:p")
  let l:filepath = expand("%:h")
  let l:fname = expand("%:t")
  let l:filepath_without_app = substitute(l:filepath, "app/", "", "")
  let l:filepath_without_app = substitute(l:filepath_without_app, "assets/", "", "")

  " Possible names for the spec/test for the file we're looking at
  let l:test_names = [substitute(l:fname, ".rb$", "_spec.rb", ""), substitute(l:fname, ".rb$", "_test.rb", ""), substitute(l:fname, ".js$", "_spec.js", ""), substitute(l:fname, ".jsx$", "_spec.js", ""), substitute(l:fname, ".jsx$", "_spec.jsx", "")]

  " Possible paths
  let l:test_paths = ["spec", "fast_spec", "test"]

  for test_name in l:test_names
    for path in l:test_paths
      let l:spec_path = path . "/" . l:filepath_without_app . "/" . test_name
      let l:full_spec_path = substitute(l:fullpath, l:filepath . "/" . l:fname, l:spec_path, "")
      if filereadable(l:spec_path)
        return l:full_spec_path
      end
    endfor
  endfor
endfunction

" Find the file being tested when looking at a spec
function! s:FileRelatedToSpec()
  let l:fullpath = expand("%:p")
  let l:filepath = expand("%:h")
  let l:fname = expand("%:t")

  let l:related_file = substitute(l:filepath, "fast_spec/", "", "")
  let l:related_file = substitute(l:related_file, "spec/", "", "")

  let l:related_file_names = [substitute(l:fname, "_spec.rb$", ".rb", ""), substitute(l:fname, "_spec.js$", ".js", ""), substitute(l:fname, "_spec.js$", ".jsx", ""), substitute(l:fname, "_spec.jsx$", ".jsx", "")]

  for related_file_name in l:related_file_names
    let l:full_file_path = substitute(l:fullpath, l:filepath . "/" . l:fname, "app/" . l:related_file . "/" . related_file_name, "")
    if match(l:full_file_path, "javascripts") != -1
      let l:full_file_path = substitute(l:full_file_path, "app/", "app/assets/", "")
    end
    if filereadable(l:full_file_path)
      return l:full_file_path
    end
  endfor
endfunction

" If looking at a regular file, find the related spec
" If looking at a spec, find the related file
function! g:RelatedSpecOrFile()
  let l:fname = expand("%:t")
  if match(l:fname, "_spec") != -1
    let l:result = s:FileRelatedToSpec()
  else
    let l:result = s:RelatedSpec()
  endif

  return l:result
endfunction

function! s:RelatedSpecOpen()
  let l:spec_path = g:RelatedSpecOrFile()
  if filereadable(l:spec_path)
    execute ":e " . l:spec_path
  endif
endfunction

function! s:RelatedSpecVOpen()
  let l:spec_path = g:RelatedSpecOrFile()
  if filereadable(l:spec_path)
    execute ":botright vsp " . l:spec_path
  endif
endfunction

command! RelatedSpecVOpen call s:RelatedSpecVOpen()
command! RelatedSpecOpen call s:RelatedSpecOpen()

nnoremap <silent> <C-s> :RelatedSpecVOpen<CR>
nnoremap <silent> ,<C-s> :RelatedSpecOpen<CR>
