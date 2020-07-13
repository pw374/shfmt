# shfmt

A shell formatter. Supports [POSIX Shell], [Bash], and [mksh].

This project is a fork of [mvdan]. This fork contains the same formatting functionality as the original project, and in additional to that, several unqiue options (such as the option to disable line splitting) that weren't allowed into the original project.

### Usage

Download it [here](https://github.com/patrickvane/shfmt/tree/master/build).

To use it in an editor (like PhpStorm etc), make a cmd like [this](https://github.com/patrickvane/shfmt/raw/master/shfmt.cmd) and then reference that (instead of the exe).

### Description

`shfmt` formats shell programs. It can use tabs or any number of spaces to
indent.

You can feed it standard input, any number of files or any number of directories
to recurse into. When recursing, it will operate on `.sh` and `.bash` files and
ignore files starting with a period. It will also operate on files with no
extension and a shell shebang.

	shfmt -l -w script.sh

Typically, CI builds should use the command below, to error if any shell scripts
in a project don't adhere to the format:

	shfmt -d .

Use `-i N` to indent with a number of spaces instead of tabs. There are other
formatting options - see `shfmt -h`. For example, to get the formatting
appropriate for [Google's Style][google-style] guide, use `shfmt -i 2 -ci`.

If any [EditorConfig] files are found, they will be used to apply formatting
options. If any parser or printer flags are given to the tool, no EditorConfig
files will be used. A default like `-i=0` can be used for this purpose.

An example of the options available:

```editorconfig
[*.sh]
# like -i=4
indent_style = space
indent_size = 4

shell_variant      = posix # like -ln=posix
binary_next_line   = true  # like -bn
switch_case_indent = true  # like -ci
space_redirects    = true  # like -sr
keep_padding       = true  # like -kp
function_next_line = true  # like -fn
never_split        = true  # like -ns

# Ignore the entire "third_party" directory.
[third_party/**]
ignore = true
```

### Caveats

* When indexing Bash associative arrays, always use quotes. The static parser
  will otherwise have to assume that the index is an arithmetic expression.

```sh
$ echo '${array[spaced string]}' | shfmt
1:16: not a valid arithmetic operator: string
$ echo '${array[dash-string]}' | shfmt
${array[dash - string]}
```

* `$((` and `((` ambiguity is not supported. Backtracking would complicate the
  parser and make streaming support via `io.Reader` impossible. The POSIX spec
  recommends to [space the operands][posix-ambiguity] if `$( (` is meant.

```sh
$ echo '$((foo); (bar))' | shfmt
1:1: reached ) without matching $(( with ))
```

* Some builtins like `export` and `let` are parsed as keywords. This is to allow
  statically parsing them and building their syntax tree, as opposed to just
  keeping the arguments as a slice of arguments.

[bash]: https://www.gnu.org/software/bash/
[editorconfig]: https://editorconfig.org/
[google-style]: https://google.github.io/styleguide/shell.xml
[mksh]: https://www.mirbsd.org/mksh.htm
[mvdan]: https://github.com/mvdan/sh
[posix shell]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
[posix-ambiguity]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_03
