File.write("../README.md", <<END)
# Yamanote Quine（山手Quine）

This is a self-reproducing program that shapes "Tokyo"（東京）, a station name of [Yamanote Line](https://en.wikipedia.org/wiki/Yamanote_Line).

```
#{ File.read("../yamanote-quine-inner-circle.rb") }```

When executed, it prints the next station of Tokyo, i.e., "Kanda"（神田）; the output is an executable Ruby code, which prints "Akihabara"（秋葉原）.  It returns to the original shape when executed 30 times (as Yamanote Line has 30 stations).


## Bonus

* It runs counter-clockwise by default.  You can reverse the direction by adding any command-line argument: `ruby yamanote-quine-inner-circle.rb rev` prints "Yurakucho"（有楽町）.
* `yamanote-quine-outer-circle.rb` is a clockwise variant.
* "Takanawa Gateway"（高輪ゲートウェイ） is now supported (a new station opened in 2020 :tada:).  If you don't like it, you may want to set an environment variable `NO_TGW` to skip the station: `export NO_TGW=1`.
END
