static-vim
==========

This repository contains a Makefile and patches to produce a fully statically
linked Vim binary. Normally, when compiling Vim with `LDFLAGS="-static"` to
produce a statically linked executable, the generated binary still has hard
dependencies on the glibc version of the system that built the binary; a few
warnings like this one will be emitted during the build process:

    misc1.c:…: warning: … requires … the glibc version used for linking

By making some relatively minor changes to the Vim codebase, the glibc version
dependency can be completely eliminated. As of November 1st, 2014, the
resulting Vim binary has the following feature set which has been tweaked from
what is normally generated with `--with-features=normal` to suit my personal
preferences:

    Normal version without GUI.  Features included (+) or not (-):
    +acl             -farsi           -mouse_netterm   +syntax
    -arabic          +file_in_path    -mouse_sgr       +tag_binary
    +autocmd         +find_in_path    -mouse_sysmouse  +tag_old_static
    -balloon_eval    +float           -mouse_urxvt     -tag_any_white
    -browse          +folding         +mouse_xterm     -tcl
    +builtin_terms   -footer          +multi_byte      +terminfo
    +byte_offset     +fork()          +multi_lang      +termresponse
    +cindent         -gettext         -mzscheme        +textobjects
    -clientserver    -hangul_input    -netbeans_intg   +title
    -clipboard       +iconv           +path_extra      -toolbar
    +cmdline_compl   +insert_expand   -perl            +user_commands
    +cmdline_hist    +jumplist        +persistent_undo +vertsplit
    +cmdline_info    -keymap          +postscript      +virtualedit
    +comments        -langmap         +printer         +visual
    +conceal         -libcall         -profile         +visualextra
    +cryptv          +linebreak       -python          +viminfo
    -cscope          +lispindent      -python3         +vreplace
    +cursorbind      +listcmds        +quickfix        +wildignore
    +cursorshape     +localmap        +reltime         +wildmenu
    +dialog_con      -lua             -rightleft       +windows
    +diff            +menu            -ruby            +writebackup
    +digraphs        +mksession       +scrollbind      -X11
    -dnd             +modify_fname    -signs           -xfontset
    -ebcdic          +mouse           +smartindent     -xim
    -emacs_tags      -mouseshape      -sniff           -xsmp
    +eval            -mouse_dec       +startuptime     -xterm_clipboard
    +ex_extra        -mouse_gpm       +statusline      -xterm_save
    +extra_search    -mouse_jsbterm   -sun_workshop    -xpm

In short there is little to no:

- GUI support or X11 integration
- support for scripting in any languages other than Vim script
- special support for non-US/European locales and languages
- client / server RPC's

Licensing
---------

The Makefiles and launcher script are licensed under the 2-clause BSD license.

Instructions
------------

The Makefile provides a number of different targets. The most important ones
are as follows:

- **all**: Download, patch and build a statically linked copy of Vim. This is
  the default target.
- **update**: Update the local copy of the Vim source code if it is out of sync
  with the official repository which will also implicitly cause the **clean**
  target to be executed. If the local copy of Vim is already up-to-date, this
  will fail with a non-zero exit status, and no files will be modified. This
  may be useful for automatic updates (`make update && make install`).
- **install**: Install Vim's binaries and runtime content. Refer to the
  description of `INSTALLDIR` and `BINDIR` below. The Vim binaries will be
  built as necessary when this target is used.
- **uninstall**: Remove the Vim binaries and runtime from `INSTALLDIR` and
  related symlinks from `BINDIR`.
- **dist**: Create a distributable, compressed archive. To install Vim, simply
  extract the archive on the target system, `cd` into the `vim` directory and
  run `make install`. By default, symlinks to the executables will be placed in
  `~/bin/`. To install the symlinks in another directory, override the Makefile
  variable `BINDIR`: `make BINDIR=/usr/local/bin install`. By default, this
  produces a bz2 archive. Override the `DISTEXTENSION` to change this, e.g.,
  `make dist DISTEXTENSION=tgz`.
- **clean**: Return the local Vim source code repository to a clean,
  unadulterated state.
- **cleanest**: Delete the `vim-src` folder.

There are several variables defined in the Makefile that may be overridden:
`INSTALLDIR`, which defaults to `~/vim/`, determines where the `vim` and `xxd`
binaries and the Vim runtime folder will be stored. `BINDIR` is the directory
where symlinks to the `xxd` binary and Vim launcher will be placed and should
be a folder listed in the `PATH` environment variable. `DISTEXTENSION`, which
defaults to `bz2`, determines the extension and type of the distributable
archive.

The `vim.sh` script is a wrapper used to launch the statically compiled Vim
binary with `VIMRUNTIME` set to the appropriate directory and will
automatically be installed or bundled as necessary.
