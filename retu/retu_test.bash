#!/bin/bash
#
# test script of keycut
#
# usage: [<test-path>/]cjoin0_test.bash [<command-path>]
#
#            <test-path>は
#                    「現ディレクトリーからみた」本スクリプトの相対パス
#                    または本スクリプトの完全パス
#                    省略時は現ディレクトリーを仮定する
#            <command-path>は
#                    「本スクリプトのディレクトリーからみた」test対象コマンドの相対パス
#                    またはtest対象コマンドの完全パス
#                    省略時は本スクリプトと同じディレクトリーを仮定する
#                    値があるときまたは空値（""）で省略を示したときはあとにつづく<python-version>を指定できる
name=retu # test対象コマンドの名前
testpath=$(dirname $0) # 本スクリプト実行コマンドの先頭部($0)から本スクリプトのディレトリー名をとりだす
cd $testpath # 本スクリプトのあるディレクトリーへ移動
if test "$1" = ""; # <command-path>($1)がなければ
	then commandpath="." # test対象コマンドは現ディレクトリーにある
	else commandpath="$1" # <command-path>($1)があればtest対象コマンドは指定のディレクトリーにある
fi
com="go run ${commandpath}/${name}.go"
tmp=/tmp/$$

ERROR_CHECK(){
	[ "$(echo ${PIPESTATUS[@]} | tr -d ' 0')" = "" ] && return
	echo $1
	echo "${name}" NG
	rm -f $tmp-*
	exit 1
}

###########################################
#TEST1

cat << FIN > $tmp-in
山田

田中
FIN

cat << FIN > $tmp-out
1
0
1
FIN

${com} $tmp-in > $tmp-ans
diff $tmp-ans $tmp-out
[ $? -eq 0 ] ; ERROR_CHECK "TEST1 error"

###########################################
#TEST2

cat << FIN > $tmp-out
1
FIN

echo -n aaa | ${com}  > $tmp-ans
diff $tmp-ans $tmp-out
[ $? -eq 0 ] ; ERROR_CHECK "TEST2 error"

###########################################
#TEST3

# cat << FIN > $tmp-out
# 1
# FIN

# echo aaa | ${com} - > $tmp-ans
# diff $tmp-ans $tmp-out
# [ $? -eq 0 ] ; ERROR_CHECK "TEST3 error"

###########################################
#TEST4

# cat << FIN > $tmp-in
# 山田

# 田中
# FIN

# cat << FIN > $tmp-out
# $tmp-in 1
# $tmp-in 0
# $tmp-in 1
# FIN

# ${com} -f $tmp-in > $tmp-ans
# diff $tmp-ans $tmp-out
# [ $? -eq 0 ] ; ERROR_CHECK "TEST4 error"

###########################################
#TEST4

# cat << FIN > $tmp-in1
# 山田

# 田中
# FIN

# cat << FIN > $tmp-in2
# 山田 aa 420402

# 田中
# FIN

# cat << FIN > $tmp-out
# $tmp-in1 1
# $tmp-in1 0
# $tmp-in1 1
# $tmp-in2 3
# $tmp-in2 0
# $tmp-in2 1
# FIN

# ${com} -f $tmp-in{1,2} > $tmp-ans
# diff $tmp-ans $tmp-out
# [ $? -eq 0 ] ; ERROR_CHECK "TEST5 error"

rm -Rf $tmp-*
echo "${name}" OK
exit 0