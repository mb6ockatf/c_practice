repeat(){
	for i in {1..80}
    do
        echo -n "$1"
    done
}

separator=`repeat -`
rm main
echo "compiling..."
gcc -Werror -o main main.c
echo "done"
echo "running your code..."
echo "$separator"
./main