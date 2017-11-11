CRONTABS=$(sort *.crontab)
TARGET=.cron.$(shell hostname)

install: $(TARGET)

$(TARGET): $(CRONTABS)
	for c in $^ ; do echo "# $$c" ; cat $$c ; echo ; done | crontab -
	crontab -l | tee $@

clean:
	rm -f $(TARGET)
