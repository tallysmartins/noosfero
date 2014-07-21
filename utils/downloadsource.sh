# !/bin/bash
if [ $# -lt 3 ];
then
	echo "Usage: $0 {link} {destdir} {md5sum}"
	exit -1
fi

link=$1
dest=$2
checksum=$3
packdir=packages

fname=`basename $link`
cname=`basename $checksum`

if [ ! -f $packdir/$fname ];
then
	wget $link -O $dest/$fname
fi

if [ ! -f $packdir/$cname ];
then
	wget $checksum -O $packdir/$cname
fi


cd $packdir

if ! md5sum -c $cname;
then
	echo "$fname is corrupted!"
	exit -2
fi

cd ..

mkdir -p $dest
tar vxzf $packdir/$fname -C $dest --strip-components=1

