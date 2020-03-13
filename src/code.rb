d="DATA";

## decode the data
88.times{|i|
  d=
    i==31?
      d.gsub(?~){$'[0,3]}.gsub(?#){$'[0,2]}
    :
      d.gsub(""<<123-i,d[0,z=i/82+2])[z..-1]
};
i=j=-k=b=1;
d.bytes{|c|d=b+=b+k^=c&1};
## b=d: [MSB] font_data + name_data [LSB]

## generate a code template
c=33.chr;
n=($*[0]?SUCC)%30;
n==TAKANAWA&&ENV["NO_TGW"]&&n=($*[0]?SUCC)%30;
0.upto(n%30){ ## iterate to the n-th station
  k=(c*58<<10)*m=b%4*23+30;
  b/=4;
  9.step(m,23){|m| ## each letter
    i+=v=b%2;
    760.times{|p| ## each pixel
      k[p%38+(p/38+m)*59-226]=
        ""<<d[OFFSET+(v<1?b/2%64:i)*380+p/2]+32
    };
    b>>=7-v*6
  }
};

## cast the quine into the template
puts((c*58<<10<<k<<c*54).gsub(c){
  "n=#{n};eval$S=%w#{c+$S[0,SIZ]*9}"[j+=1]
}+c+"*''")
