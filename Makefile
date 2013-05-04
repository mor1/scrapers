.PHONY: clean

clean:
	$(RM) CitationsV4.utf8.txt debug.* courses.json
	$(RM) $(patsubst %.coffee,%.js,$(wildcard *.coffee))

sanitise:
	iconv -f UTF-16 -t UTF-8 CitationsV4.txt >| CitationsV4.utf8.txt
