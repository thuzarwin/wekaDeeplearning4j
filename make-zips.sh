#!/bin/bash
set -x
build_dir="./build"
rm -r ${build_dir}
mkdir ${build_dir}
mkdir -p ${build_dir}/props
function copy_files {
	for f in package/dist/*/;
	do 
		ffixed=`cut -d'/' -f3 <(echo $f)`
		mkdir ${build_dir}/props/$ffixed
		cp package/dist/$ffixed/Description.props ${build_dir}/props/$ffixed/
	done
	cp package/dist/*.zip ${build_dir} 
}
./build.sh -c -v -b CPU
copy_files
./build.sh -c -v -b GPU
copy_files

## Generate sha256 sums
sumfile="${build_dir}/sums.sha256"
echo "### SHA256 sums" >> ${sumfile}
for f in ${build_dir}/*.zip;
do	
	sum=$(sha256sum ${f} | cut -d" " -f1)
	echo " - ${f}" >> ${sumfile}
	echo "		\`${sum}\`" >> ${sumfile}
done
tar -czvf ${build_dir}/wekaDepplearning4j-props.tar.gz ${build_dir}/props

