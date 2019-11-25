url_encode: url_encode.o
	mkdir -p obj/
	gcc -o url_encode obj/url_encode.o -lcurl

url_encode.o: url_encode.c
	mkdir -p obj/
	gcc -c url_encode.c -o obj/url_encode.o

clean:
	rm url_encode
	rm -rf obj/
