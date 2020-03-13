require_relative "font"

stations = %w(
  東京 神田 秋葉原 御徒町 上野 鶯谷 日暮里 西日暮里 田端 駒込 巣鴨 大塚 池袋
  目白 高田馬場 新大久保 新宿 代々木 原宿 渋谷 恵比寿 目黒 五反田 大崎 品川
  高輪ゲ 田町 浜松町 新橋 有楽町
)

usable_data = []
30.times do
  # generate data
  name_data, font_data = "", ""
  tbl = {}
  stations.each do |name|
    # length
    name_data << ("%02b" % (name.size - 1)).reverse
    name.chars do |ch|
      if tbl[ch]
        # manual index
        name_data << ("0" + ("%06b" % tbl[ch]).reverse)
      else
        # auto-increment index
        name_data << "1"
        font_data << Font[ch].tr(".#", "10")
        tbl[ch] = tbl.size
      end
    end
  end
  data = (name_data + font_data).reverse

  # block sort
  prev_ch = "1"
  data = data.gsub(/./) do
    ch = $& == prev_ch ? "0" : "1"
    prev_ch = $&
    ch
  end

  # byte-pair encoding
  data = data.tr("01", "|}").gsub(/^\|*/,"")
  36.upto(123) do |i|
    if i == 92
      data = data.gsub(/(..)\1/) { "#" + $1 }
      data = data.gsub(/(...)\1/) { "~" + $1 }
    else
      h = Hash.new(0)
      (data.size - 1).times {|j| h[data[j, i < 42 ? 3 : 2]] += 1 }
      _, s = h.invert.max
      data = s + data.gsub(s, i.chr)
    end
  end

  usable_data << [data, name_data.size, stations.dup] unless data.dump.include?("\\")

  stations.rotate!(1)
end

# shortest encoded data
data, offset, stations = usable_data.min_by {|data,| data.size }
p [:data_size, data.size]

# generate code
src = File.read("code.rb")
src = src.gsub(/##.*/, "")
src = src.sub("DATA") { data }
src = src.sub("OFFSET") { offset }
src = src.sub("TAKANAWA") { stations.index("高輪ゲ") }
src = src.gsub("SUCC") { $*[0] == "inner" ? "n-1:n+1" : "n+1:n-1" }
src = src.split.join
src = src.sub("SIZ") { src.size + 2 }
src = %(n=1;eval$S=%w!#{ src }#!*"")
p [:code_size, src.size]

# memo: "+" for inner, "-" for outer

# dry run
def puts(s)
  $output = s
end
31.times do
  eval(src)
  src = $output
end

File.write("../yamanote-quine-#{ $*[0] }-circle.rb", src + "\n")
