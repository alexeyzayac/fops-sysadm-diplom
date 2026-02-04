" ~/.vimrc
" Основные настройки
set nocompatible            " Отключение совместимости с Vi
filetype plugin indent on   " Автоопределение типов файлов
syntax on                   " Включение подсветки синтаксиса
set encoding=utf-8          " Установка кодировки UTF-8

" Интерфейс
set number                  " Номера строк
set relativenumber          " Относительная нумерация
set cursorline              " Подсветка текущей строки
set title                   " Отображение имени файла в заголовке терминала
set showcmd                 " Показ вводимых команд
set wildmenu                " Улучшенное автодополнение в командной строке
set scrolloff=5             " Минимальное расстояние до края экрана при скроллинге

" Поиск
set incsearch               " Поиск по мере ввода
set hlsearch                " Подсветка результатов поиска
set ignorecase              " Игнорировать регистр при поиске
set smartcase               " Умное распознавание регистра

" Табуляция и отступы
set tabstop=4               " Ширина табуляции в пробелах
set shiftwidth=4            " Размер автоматического отступа
set expandtab               " Преобразование табов в пробелы
set smartindent             " Умные отступы

" Работа с файлами
set hidden                  " Возможность переключаться между буферами без сохранения
set autoread                " Автоперезагрузка изменённых файлов
set backupcopy=yes          " Корректная работа с файловой системой
set undofile                " Возможность отменять действия после перезагрузки
set undodir=~/.vim/undo//   " Каталог для файлов отмены

" Создаем директорию для undo-файлов, если она не существует
if !isdirectory(expand('~/.vim/undo//'))
    silent !mkdir -p ~/.vim/undo
endif

" Клавиши
let mapleader=" "           " Основная префиксная клавиша
nnoremap <Leader>w :w<CR>   " Сохранить файл
nnoremap <Leader>q :q<CR>   " Закрыть файл
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR> " Сброс подсветки поиска

" Плагины (требуют установки менеджера плагинов)
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'           " Базовые настройки
Plug 'preservim/nerdtree'           " Файловый менеджер
Plug 'itchyny/lightline.vim'        " Статусная строка
call plug#end()

" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

" Lightline
set laststatus=2            " Всегда показывать статусную строку
set noshowmode              " Скрыть стандартный индикатор режима

" Автокоманды
augroup vimrc
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e " Удаление пробелов в конце строк при сохранении
augroup END
