```bash
# sponge prevents `cat: ./test.txt: input file is output file` error..
# .. in case you would want to write output to a file in same..
# .. directory used as input
./treexp.sh | sponge > test.txt

./treexp.sh ~/
```
