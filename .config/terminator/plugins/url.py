import re
import terminatorlib.plugin as plugin

AVAILABLE = ['DebianBugURLHandler', 'MaidenheadURLHandler', 'CallsignURLHandler', 'ManpageURLHandler']

class DebianBugURLHandler(plugin.URLHandler):
    """Debian Bug URL handler"""
    capabilities = ['url_handler']
    handler_name = 'debian_bug'
    match = '#(\\d{6,7})\\b'
    nameopen = "Open Debian bug"
    namecopy = "Copy bug URL"

    def callback(self, url):
        """Look for the number in the supplied string and return it as a URL"""
        match = '#(\\d{6,7})\\b'
        for item in re.findall(match, url):
            return 'https://bugs.debian.org/' + item

class MaidenheadURLHandler(plugin.URLHandler):
    """Maidenhead URL handler"""
    capabilities = ['url_handler']
    handler_name = 'maidenhead_locator'
    match = '\\b[A-R][A-R][0-9][0-9](?:[A-Xa-x][A-Xa-x](?:[0-9][0-9])?)?\\b'
    nameopen = "View locator on map"
    namecopy = "Copy locator URL"

    def callback(self, url):
        return 'https://k7fry.com/grid/?qth=' + url

class CallsignURLHandler(plugin.URLHandler):
    """Callsign URL handler"""
    capabilities = ['url_handler']
    handler_name = 'callsign'
    match = '\\b[0-9]?[A-Z]{1,2}[0-9]{1,2}[A-Z]{1,5}\\b'
    nameopen = "View call on qrz.com"
    namecopy = "Copy callsign URL"

    def callback(self, url):
        return 'https://www.qrz.com/db/' + url

class ManpageURLHandler(plugin.URLHandler):
    """Manpage URL handler"""
    capabilities = ['url_handler']
    handler_name = 'manpage_url'
    match = '\\b(\w+)\(\d\)'
    nameopen = "View manpage"
    namecopy = "Copy manpage URL"

    def callback(self, url):
        match = '\\b(\w+)\(\d\)'
        for item in re.findall(match, url):
            return 'https://manpages.debian.org/' + item
