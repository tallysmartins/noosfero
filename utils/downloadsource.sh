# !/bin/sh

set -eu

if [ $# -ne 3 ];
then
	echo "Usage: $0 {link} {destdir} {md5sum}"
	exit 1
fi

tarball=$1
destdir=$2
md5sum=$3

srcdir=$(dirname $0)/../src
mkdir -p $srcdir

fname=`basename $tarball`
md5sum_file=/tmp/${fname}.md5sum
echo "$md5sum $fname" > $md5sum_file

trap cleanup INT TERM EXIT
cleanup() {
	rm -f $md5sum_file
}

if [ ! -f $srcdir/$fname ];
then
	wget $tarball -O $srcdir/$fname
fi


if ! (cd $srcdir && md5sum -c $md5sum_file);
then
	echo "$fname is corrupted!"
	exit -2
fi

rm -rf $destdir
mkdir -p $destdir
tar xaf $srcdir/$fname -C $destdir --strip-components=1
