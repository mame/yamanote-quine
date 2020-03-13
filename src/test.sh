#!/bin/bash

set -e
cp ../yamanote-quine-inner-circle.rb t.rb
for i in `seq 1 30`; do
  ruby t.rb > t2.rb
  mv t2.rb t.rb
  cat t.rb
  echo
done
diff -sq ../yamanote-quine-inner-circle.rb t.rb
