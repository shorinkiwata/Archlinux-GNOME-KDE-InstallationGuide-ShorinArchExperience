"显示行号
set number
"显示相对行号
set relativenumber
"高亮当前行
set cursorline
"语法高亮
syntax on 
" 设置 Tab 键的宽度为 4 个空格
set tabstop=4

" 设置自动缩进和 >> << 命令的宽度为 4 个空格
set shiftwidth=4

" 将 Tab 键自动转换为空格。这是现代编程的推荐实践。
set expandtab

" 开启自动缩进，新的一行会自动与上一行对齐
set autoindent
" 在输入搜索词时，实时高亮显示匹配项（增量搜索）
set incsearch

" 高亮显示所有搜索结果
set hlsearch

" 搜索时忽略大小写
set ignorecase

" 如果搜索词中包含了大写字母，则自动切换为大小写敏感搜索
set smartcase
" 开启持久化撤销（undo），即使关闭再打开文件，也能撤销之前的更改
set undofile

" 为备份、交换和撤销文件创建一个统一的目录
" a) 创建目录
silent !mkdir -p ~/.vim/backup
silent !mkdir -p ~/.vim/swap
silent !mkdir -p ~/.vim/undo
" b) 设置 Vim 使用这些目录
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set undodir=~/.vim/undo
