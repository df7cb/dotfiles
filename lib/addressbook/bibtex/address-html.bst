%% address-html.bst
%% Copyright 1999-2000 Christophe Geuzaine
%
% Last Mod by Christophe on Sun Aug 27 21:10:54 2000
%
% This program can be redistributed and/or modified under the terms
% of the LaTeX Project Public License distributed from CTAN
% archives in directory macros/latex/base/lppl.txt; either
% version 1 of the License, or (at your option) any later version.
%
% BibTeX bibliography style `address-html.bst'
% 'directory' database: all fields
% 
% Christophe.Geuzaine@advalvas.be
%
% Last modified 08/06/1999
% 
% This is definitively a hack... 
% 
% The parts you may want to customize are labeled with "CUSTOM"
%

INTEGERS { nameptr namesleft numnames numaux len }
STRINGS { s t u v }

% ------------------------------------------------------------ 
%  E N T R I E S
% ------------------------------------------------------------ 

ENTRY
  { name
    nickname
    birthday
    birthyear
    address
    phone
    cellular
    fax
    email
    url
    account
    p.address
    p.phone
    p.cellular
    p.fax
    p.email
    p.url
    p.account
    r.address
    r.phone
    r.cellular
    r.fax
    r.email
    r.url
    r.account
    w.title
    w.name
    w.address
    w.phone
    w.cellular
    w.fax
    w.email
    w.url
    w.account
    note
  }
  {}
  { birthday.str 
    private.str 
    residence.str 
    work.str 
    note.str 
    and.str 
    nickname.str
    address.str
    phone.str
    cellular.str
    fax.str
    email.str
    url.str
    account.str
    title.str
    name.str
   }


% ------------------------------------------------------------ 
%  G E N E R A L
% ------------------------------------------------------------ 

FUNCTION {init.strings}
{ 

% CUSOTM this is the 'html' equivalent for the \dirXXX customization
%        commands

  "<dt>&nbsp;&nbsp;&nbsp;&nbsp;<em>Geburtstag</em></dt>"  'birthday.str :=
  "<dt>&nbsp;&nbsp;&nbsp;&nbsp;<em>Adresse</em></dt>"      'private.str :=
  "<dt>&nbsp;&nbsp;&nbsp;&nbsp;<em>Eltern-Adresse</em></dt>" 'residence.str :=
  "<dt>&nbsp;&nbsp;&nbsp;&nbsp;<em>Firmen/Uni-Adresse</em></dt>" 'work.str :=
  "<dt>&nbsp;&nbsp;&nbsp;&nbsp;<em>Bemerkung</em></dt>"      'note.str :=

  " and "                                               'and.str :=
  "  aka "                                              'nickname.str :=
  ""                                                    'address.str :=
  "Tel: "                                               'phone.str :=
  "Mobil: "                                               'cellular.str :=
  "Fax: "                                               'fax.str :=
  ""                                                    'email.str :=
  ""                                                    'url.str :=
  "Account: "                                           'account.str :=
  ""                                                    'title.str :=
  ""                                                    'name.str :=
}

FUNCTION {output.nonnull}
{ 's :=
   write$
   newline$
   "<dd> " write$
   s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$ 
    'output.nonnull
  if$  
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {emailize}
{ duplicate$ empty$
    { pop$ "" }
    { "<A HREF=" quote$ * "mailto:" * swap$ * quote$ * " >" * swap$ *  "</A>" * }
  if$
}

FUNCTION {urlize}
{ duplicate$ empty$
    { pop$ "" }
    { "<A HREF=" quote$ * "http://" * swap$ * quote$ * " >" * swap$ *  "</A>" * }
  if$
}

FUNCTION {ttize}
{ duplicate$ empty$
    { pop$ "" }
    { "<tt>" swap$ * "</tt>" * }
  if$
}

% ------------------------------------------------------------ 
%  S O R T I N G   F U N C T I O N S
% ------------------------------------------------------------ 

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

FUNCTION {sort.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
	{ "   " * }
	'skip$
      if$
      s nameptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
	{ "et al" * }
	{ t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}


FUNCTION {sort.raw.names}
{ 't :=
  "A " #2 "L'" #2
  "An " #3 "Au " #3 "Le " #3 "La " #3
  "The " #4 "Les " #4 "Aux " #4
  t 
  chop.word chop.word 
  chop.word chop.word chop.word chop.word 
  chop.word chop.word chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {name.sort}
{ name empty$
    { " Name field missing in entry '" cite$ * "'" * warning$ "" }
    { name sort.names }
  if$
}

FUNCTION {raw.name.sort}
{ name empty$
    { " Name field missing in entry '" cite$ * "'" * warning$ "" }
    { name sort.raw.names }
  if$
}

FUNCTION {presort}
{ type$ "company" =
  type$ "place" =
  or
    { raw.name.sort }
    { name.sort }
  if$
  " "
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

% ------------------------------------------------------------ 
%  P R E -   A N D   P O S T -   H E A D E R S 
% ------------------------------------------------------------ 

FUNCTION {begin.bib}
{ %"<HTML><!-- This is a file generated by the LaTeX directory package -->"  write$ 
  %newline$
  %"<TITLE>Address Book (generated by the LaTeX directory package)</TITLE>" write$ 
  %newline$
}

FUNCTION {end.bib}
{ %newline$
  %"<p><hr><center><font size=-1>This address book was generated by <A HREF= " write$
  %quote$ "http://www.geuz.org/directory/" * quote$ * write$
  %" >directory</A>, version 1.15</center></HTML>" write$
  %newline$
}

% ------------------------------------------------------------ 
%  F O R M A T S 
% ------------------------------------------------------------ 

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { 
% CUSTOM uncomment one of the following lines to have the behaviour on the right
      s nameptr "{ff{ } }{vv{ } }{ll{ }}{, jj{ }}"  format.name$ 't := % Christophe de Geuzaine, jr
%     s nameptr "{f.{ } }{vv{ } }{ll{ }}{, jj{ }}"  format.name$ 't := % C. de Geuzaine, jr
%     s nameptr "{vv{ } }{ll{ }}{ f.{ }}{, jj{ }}"  format.name$ 't := % de Geuzaine C., jr
%     s nameptr "{vv{ } }{ll{ }}{, ff{ }}{, jj{ }}" format.name$ 't := % de Geuzaine, Christophe, jr

      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { and.str * t * }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}


FUNCTION {format.dates}
{
 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=

    birthyear empty$
      { #0 'numaux := }
      { birthyear num.names$ 'numaux := 
        numnames numaux =
         { }
         { " birthdays and birthyears don't match in entry '" cite$ * "'" * warning$ }
       if$
      }
    if$
    
% CUSTOM 

    { namesleft #0 > }
    { s nameptr "{ff}" format.name$ 't :=
      s nameptr "{ll}" format.name$ 'u :=

      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * "/" * u * }
	    { and.str * t * "/" * u *  }
	  if$
	}
	{ t ". " * u * }
      if$

      numaux #0 > not
        { }
        { birthyear nameptr "{ll}" format.name$ 'v := 
          ". " * v * }
      if$

      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
      numaux #1 - 'numaux :=
    }
  while$
}

FUNCTION {format.years}
{
 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    
    { namesleft #0 > }
    { s nameptr "{ll}" format.name$ 't :=
      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { and.str * t * }
	  if$
	}
	t 
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.name}
{ name empty$
    { "" }
    { name format.names }
  if$
}

FUNCTION {format.nickname}
{ nickname empty$
    { "" }
    { nickname.str nickname format.names * }
  if$
}

FUNCTION {format.birthday.flag}
{ birthyear empty$ not
  birthday empty$ not
  or
    { birthday.str }
    { "" }
  if$
}

FUNCTION {format.birthday}
{ birthday empty$
    {  
       birthyear empty$
        { "" }
        { birthyear format.years }
      if$
    }
    { birthday format.dates }
  if$
}

FUNCTION {format.address}
{ address empty$
    { "" }
    { address.str address * }
  if$
}

FUNCTION {format.account}
{ account empty$
    { "" }
    { account.str account ttize * }
  if$
}

FUNCTION {format.phone}
{ phone empty$
    { "" }
    { phone.str phone * }
  if$
}

FUNCTION {format.cellular}
{ cellular empty$
    { "" }
    { cellular.str cellular * }
  if$
}

FUNCTION {format.fax}
{ fax empty$
    { "" }
    { fax.str fax * }
  if$
}

FUNCTION {format.email}
{ email empty$
    { "" }
    { email.str email email emailize * }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
    { url.str url url urlize * }
  if$
}


FUNCTION {format.p.flag}
{ p.address empty$ not
  p.phone empty$ not 
  p.cellular empty$ not 
  p.fax empty$ not 
  p.email empty$ not
  p.url empty$ not
  p.account empty$ not
  or or or or or or
    { private.str }
    { "" }
  if$
}

FUNCTION {format.p.address}
{ p.address empty$
    { "" }
    { address.str p.address * }
  if$
}

FUNCTION {format.p.phone}
{ p.phone empty$
    { "" }
    { phone.str p.phone * }
  if$
}

FUNCTION {format.p.cellular}
{ p.cellular empty$
    { "" }
    { cellular.str p.cellular * }
  if$
}

FUNCTION {format.p.fax}
{ p.fax empty$
    { "" }
    { fax.str p.fax * }
  if$
}

FUNCTION {format.p.email}
{ p.email empty$
    { "" }
    { email.str p.email p.email emailize * }
  if$
}

FUNCTION {format.p.url}
{ p.url empty$
    { "" }
    { url.str p.url p.url urlize * }
  if$
}

FUNCTION {format.p.account}
{ p.account empty$
    { "" }
    { account.str p.account ttize * }
  if$
}

FUNCTION {format.r.flag}
{ r.address empty$ not
  r.phone empty$ not 
  r.cellular empty$ not 
  r.fax empty$ not 
  r.email empty$ not
  r.url empty$ not
  r.account empty$ not
  or or or or or or
    { residence.str }
    { "" }
  if$
}

FUNCTION {format.r.address}
{ r.address empty$
    { "" }
    { address.str r.address * }
  if$
}

FUNCTION {format.r.phone}
{ r.phone empty$
    { "" }
    { phone.str r.phone * }
  if$
}

FUNCTION {format.r.cellular}
{ r.cellular empty$
    { "" }
    { cellular.str r.cellular * }
  if$
}

FUNCTION {format.r.fax}
{ r.fax empty$
    { "" }
    { fax.str r.fax * }
  if$
}

FUNCTION {format.r.email}
{ r.email empty$
    { "" }
    { email.str r.email r.email emailize * }
  if$
}

FUNCTION {format.r.url}
{ r.url empty$
    { "" }
    { url.str r.url r.url urlize * }
  if$
}

FUNCTION {format.r.account}
{ r.account empty$
    { "" }
    { account.str r.account ttize * }
  if$
}

FUNCTION {format.w.flag}
{ w.title empty$ not
  w.name empty$ not
  w.address empty$ not
  w.phone empty$ not 
  w.cellular empty$ not 
  w.fax empty$ not 
  w.email empty$ not
  w.url empty$ not
  w.account empty$ not
  or or or or or or or or
    { work.str }
    { "" }
  if$
}

FUNCTION {format.w.title}
{ w.title empty$
    { "" }
    { title.str w.title * }
  if$
}

FUNCTION {format.w.name}
{ w.name empty$
    { "" }
    { name.str w.name * }
  if$
}

FUNCTION {format.w.address}
{ w.address empty$
    { "" }
    { address.str w.address * }
  if$
}

FUNCTION {format.w.phone}
{ w.phone empty$
    { "" }
    { phone.str w.phone * }
  if$
}

FUNCTION {format.w.cellular}
{ w.cellular empty$
    { "" }
    { cellular.str w.cellular * }
  if$
}

FUNCTION {format.w.fax}
{ w.fax empty$
    { "" }
    { fax.str w.fax * }
  if$
}

FUNCTION {format.w.email}
{ w.email empty$
    { "" }
    { email.str w.email w.email emailize * }
  if$
}

FUNCTION {format.w.url}
{ w.url empty$
    { "" }
    { url.str w.url w.url urlize * }
  if$
}

FUNCTION {format.w.account}
{ w.account empty$
    { "" }
    { account.str w.account ttize * }
  if$
}

FUNCTION {format.note.flag}
{ note empty$
    { "" }
    { note.str }
  if$
}

FUNCTION {format.note}
{ note empty$
    { "" }
    { note }
  if$
}


% ------------------------------------------------------------ 
%  P E R S O N   E N T R Y  
% ------------------------------------------------------------ 

FUNCTION { person }
{ 
  init.strings
  newline$
  "<p><dt><b>" write$
  format.name write$
  "</b></dt>" write$

  format.nickname write$

  ""
  format.birthday.flag output
  format.birthday output

  format.p.flag output
  format.p.address output
  format.p.phone output
  format.p.cellular output
  format.p.fax output
  format.p.email output
  format.p.url output
  format.p.account output

  format.r.flag output
  format.r.address output
  format.r.phone output
  format.r.cellular output
  format.r.fax output
  format.r.email output
  format.r.url output
  format.r.account output

  format.w.flag output
  format.w.title output
  format.w.name output
  format.w.address output
  format.w.phone output
  format.w.cellular output
  format.w.fax output
  format.w.email output
  format.w.url output
  format.w.account output

  format.note.flag output
  format.note output

  write$
  newline$
}

% ------------------------------------------------------------ 
%  C O M P A N Y   E N T R Y  
% ------------------------------------------------------------ 


FUNCTION { company }
{ 
  init.strings
  newline$
  "<p><dt><b>" write$
  name write$
  "</b></dt><dd>" write$

  ""
  format.address output
  format.phone output
  format.cellular output
  format.fax output
  format.email output
  format.url output
  format.account output
  format.note.flag output
  format.note output

  write$
  newline$
}

% ------------------------------------------------------------ 
%  P L A C E   E N T R Y  
% ------------------------------------------------------------ 

FUNCTION { place }
{ 
  init.strings
  newline$
  "<p><dt><b>" write$
  name write$
  "</b></dt><dd>" write$

  ""
  format.address output
  format.phone output
  format.cellular output
  format.fax output
  format.note.flag output
  format.note output

  write$
  newline$
}

% ------------------------------------------------------------ 
%  M A I N 
% ------------------------------------------------------------ 

READ
ITERATE {presort}
SORT
EXECUTE {begin.bib}
ITERATE {call.type$}
EXECUTE {end.bib}

