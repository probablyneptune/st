# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

# st version
VERSION = 0.8.5

# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

# flags
STCPPFLAGS = -DVERSION=\"$(VERSION)\" -D_XOPEN_SOURCE=600
STCFLAGS = -I/usr/include/freetype2 -I/usr/include/libpng16 -I/usr/include/harfbuzz \
	   $(STCPPFLAGS) $(CPPFLAGS) $(CFLAGS)
STLDFLAGS = -lm -lrt -lX11 -lutil -lXft -lfontconfig -lfreetype $(LDFLAGS)

SRC = st.c x.c boxdraw.c
OBJ = $(SRC:.c=.o)

all: st

.c.o:
	$(CC) $(STCFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h
boxdraw.o: config.h st.h boxdraw_data.h

$(OBJ): config.h

st: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f st $(OBJ)

install: st
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f st $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st
	cp -f st-editscreen $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st-editscreen
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < st.1 > $(DESTDIR)$(MANPREFIX)/man1/st.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st.1
	tic -sx st.info

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/st
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st.1

.PHONY: all clean install uninstall
