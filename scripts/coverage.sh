#!/bin/bash
#
# Usage
#
#   scripts/coverage.sh [/path/to/report-directory/]
#

genhtml=$(which genhtml)
if [[ -z "${genhtml}" ]]; then
    echo "Install 'genhtml' (contained in the 'lcov' package)"
    exit 1
fi

destdir="$1"
if [[ -z "${destdir}" ]]; then
    destdir=$(mktemp -d /tmp/prysmcov.XXXXXX)
fi
echo "Running 'bazel coverage'; this may take a while"
#bazel coverage --features=norace --test_tag_filters="-race_on"  //...
base=$(bazelisk info bazel-testlogs)
echo $base
for f in $(find ${base} -name 'coverage.dat') ; do
  cp $f ${destdir}/$(echo $f| sed "s|${base}/||" | sed "s|/|_|g")
done
cd ${destdir}
find -name '*coverage.dat' -size 0 -delete
genhtml -o . --ignore-errors source *coverage.dat
echo "coverage report at file://${destdir}/index.html"