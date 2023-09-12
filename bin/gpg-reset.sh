#!/bin/sh

gpg-connect-agent updatestartuptty /bye

rm $HOME/.gnupg/private-keys-v1.d/6ED6EBC7FF5EC8DFD42AB6AA50F2D211D7025464.key \
   $HOME/.gnupg/private-keys-v1.d/AE824795C0081423AB212195547E5396E452DE0E.key \
   $HOME/.gnupg/private-keys-v1.d/F0AD36547A1884F7AF88FB6697FDA83E4702DE31.key

gpg --card-status
