"
"
"
"   ,-.----.                                                               
"   \    /  \                                                       ____   
"   |   :    \  ,--,                          ,---. ,--,          ,'  , `. 
"   |   |  .\ ,--.'|              ,---,.     /__./,--.'|       ,-+-,.' _ | 
"   .   :  |: |  |,             ,'  .' |,---.;  ; |  |,     ,-+-. ;   , || 
"   |   |   \ `--'_      ,---.,---.'   /___/ \  | `--'_    ,--.'|'   |  || 
"   |   : .   ,' ,'|    /     |   |    \   ;  \ ' ,' ,'|  |   |  ,', |  |, 
"   ;   | |`-''  | |   /    / :   :  .' \   \  \: '  | |  |   | /  | |--'  
"   |   | ;   |  | :  .    ' /:   |.'    ;   \  ' |  | :  |   : |  | ,     
"   :   ' |   '  : |__'   ; :_`---'       \   \   '  : |__|   : |  |/      
"   :   : :   |  | '.''   | '.'|           \   `  |  | '.'|   | |`-'       
"   |   | :   ;  :    |   :    :            :   \ ;  :    |   ;/           
"   `---'.|   |  ,   / \   \  /              '---"|  ,   /'---'            
"     `---`    ---`-'   `----'                     ---`-'                  
"
"
let g:pic_vim_extensions = get(g:, 'pic_vim_extensions', ['jpg', 'jpeg', 'png'])
let g:pic_vim_script_dir = get(g:, 'pic_vim_script_dir', '')
let g:pic_vim_script_name = get(g:, 'pic_vim_script_name', 'pic-vim.py')
let g:pic_vim_max_files_on_start = get(g:, 'pic_vim_max_files_on_start', 5)
let g:pic_vim_enable = get(g:, 'PicVimEnable', 1)

let s:pic_vim_startup_files = []
let s:pic_vim_startup_divisors = []
let s:pic_vim_script = ''
let s:pic_vim_default_location = fnamemodify(resolve(expand('<sfile>:p')), ':h') 

fu! s:PicVimGetImageFile(fn)
  for l:ext in g:pic_vim_extensions
    if a:fn =~ l:ext . '$'
      return 1
    endif
  endfor
  return 0
endfu
  
fu! s:PicVimVerify()
  let s:pic_vim_startup_files = filter(argv(), 's:PicVimGetImageFile(v:val)')
  if ! len(s:pic_vim_startup_files)
    return 0
  endif
  if g:pic_vim_script_dir == ''
    let s:pic_vim_script = s:pic_vim_default_location . '/' . g:pic_vim_script_name
  else
    let s:pic_vim_script = g:pic_vim_script_dir . '/' . g:pic_vim_script_name
  endif
  if ! filereadable(s:pic_vim_script) || ! executable(s:pic_vim_script)
    return 0
  endif
  for l:i in range(g:pic_vim_max_files_on_start)
    call add(s:pic_vim_startup_divisors, float2nr(pow(2, ((l:i + 1) / 2) + 1)))
  endfor
  return 1
endfu

fu! s:PicVimReadImage(fn, ...)
  let l:str = 'r !' . s:pic_vim_script . ' -i ' . a:fn
  if a:1
    let l:str = l:str . ' -a ' . a:1
  endif
  echom l:str
  exec l:str
endfu

fu! PicVimDrawImageWithWidth(fn, w)
  call s:PicVimReadImage(a:fn, a:w)
endfu
com! -nargs=+ PicVimDrawImage call PicVimDrawImageWithWidth(<f-args>)

fu! PicVimDrawImageIntoSplit(fn, d, ...)
  if a:d == 'vert'
    vert split
  elseif a:d == 'horz'
    split
  else
    echom '[PicVim] Incorrect split direction argument'
    return
  endif
  enew
  setlocal bufhidden=hide buftype=nofile noswapfile
  if a:1
    call s:PicVimReadImage(a:fn, a:1 - 8)
  else
    call s:PicVimReadImage(a:fn, winwidth(0) - 8)
  endif
endfu
com! -nargs=+ PicVimDrawImageIntoSplit call PicVimDrawImageIntoSplit(<f-args>)
  
fu! PicVimStarter()
  if s:PicVimVerify()
    let l:width = winwidth(0)
    let l:range = min([len(s:pic_vim_startup_files), g:pic_vim_max_files_on_start])
    for l:i in range(l:range)
      let l:fn = s:pic_vim_startup_files[l:i]
      if l:i + 1 < l:range || l:i == 0
        let l:w = float2nr(l:width / s:pic_vim_startup_divisors[l:i])
      endif
      if i % 2
        call PicVimDrawImageIntoSplit(l:fn, 'horz', l:w)
      else
        call PicVimDrawImageIntoSplit(l:fn, 'vert', l:w)
      endif
    endfor
  endif
endfu
com! -nargs=0 PicVimStarter call PicVimStarter()

augroup PicVimGroup
  autocmd!
  autocmd VimEnter * nested if g:pic_vim_enable 
        \ |   call PicVimStarter()
        \ | endif
augroup END
