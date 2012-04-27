While inside a ruby file, invoke the shortcut (supplied as Ctrl-S), and
the corresponding spec will be open. The assumptions are:

  * Your specs live in spec/ or fast_spec/
  * Your pwd (current dir) is the project root
  * You use the same dir structure in your code and specs so that
    code living at lib/foo/bar.rb has a spec at spec/lib/foo/bar_spec.rb
