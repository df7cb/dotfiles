%% address.bst
%% Copyright 1999-2000 Christophe Geuzaine
%
% Last Mod by Christophe on Sun Aug 27 21:07:56 2000
%
% This program can be redistributed and/or modified under the terms
% of the LaTeX Project Public License distributed from CTAN
% archives in directory macros/latex/base/lppl.txt; either
% version 1 of the License, or (at your option) any later version.
%
% BibTeX bibliography style `address.bst'
% 'directory' database: all fields
% 
% Christophe.Geuzaine@advalvas.be
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
    icq
    account
    p.address
    p.phone
    p.cellular
    p.fax
    p.email
    p.url
    p.icq
    p.account
    r.address
    r.phone
    r.cellular
    r.fax
    r.email
    r.url
    r.icq
    r.account
    w.title
    w.name
    w.address
    w.phone
    w.cellular
    w.fax
    w.email
    w.url
    w.icq
    w.account
    note
  }
  {}
  { label
    letter
  }

% ------------------------------------------------------------ 
%  G E N E R A L
% ------------------------------------------------------------ 

FUNCTION {output}
{  's :=
   s empty$
    {}
    { s write$
      newline$
      "\dirblock" write$
      newline$
    }
   if$  
}

FUNCTION {output.flag}
{  's :=
   s empty$
    {}
    { s write$
      newline$      
    }
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

FUNCTION {format.first.letter}
{ type$ "company" =
  type$ "place" =
  or
    { raw.name.sort }
    { name.sort }
  if$
  #1 #1 substring$ 
}

% ------------------------------------------------------------ 
%  P R E -   A N D   P O S T -   H E A D E R S 
% ------------------------------------------------------------ 

FUNCTION {begin.bib}
{ "\begin{theaddressbook}" write$ 
  newline$
}

FUNCTION {end.bib}
{ newline$
  "\end{theaddressbook}" write$ 
  newline$
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
      s nameptr "{ff }{vv }{ll}{, jj}"  format.name$ 't := % Christophe de Geuzaine, jr
%     s nameptr "{f. }{vv }{ll}{, jj}"  format.name$ 't := % C. de Geuzaine, jr
%     s nameptr "{vv }{ll}{ f.}{, jj}"  format.name$ 't := % de Geuzaine C., jr
%     s nameptr "{vv }{ll}{, ff}{, jj}" format.name$ 't := % de Geuzaine, Christophe, jr

      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { " {\dirandf} " * t * }
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
    
% CUSTOM you shoudn't change this, but rather redefine the command \Dirbirthday.

    { namesleft #0 > }
    { s nameptr "{ff}" format.name$ 't :=
      s nameptr "{ll}" format.name$ 'u :=

      nameptr #1 >
	{ namesleft #1 >
	    { ", \dirbira{" * t * "}{" * u * "}" *  }
	    { " {\dirandf} \dirbira{" * t * "}{" * u * "}" *  }
	  if$
	}
	{ "\dirbira{" t * "}{" * u * "}" * }
      if$

      numaux #0 > not
        { }
        { birthyear nameptr "{ll}" format.name$ 'v := 
          "\dirbiya{" * v * "}" * }
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
	    { ", \dirbyra{" * t * "}" *  }
	    { " {\dirandf} \dirbyra{" * t * "}" *  }
	  if$
	}
	{ "\dirbyra{" t * "}" * }
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
    { newline$
      "\dirnica{" nickname format.names "}" * * }
  if$
}

FUNCTION {format.birthday.flag}
{ birthyear empty$ not
  birthday empty$ not
  or
    { "\dirbirf" }
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
    { "\diradda{" address "}" * * }
  if$
}

FUNCTION {format.account}
{ account empty$
    { "" }
    { "\diracca{" account "}" * * }
  if$
}

FUNCTION {format.phone}
{ phone empty$
    { "" }
    { "\dirphoa{" phone "}" * * }
  if$
}

FUNCTION {format.cellular}
{ cellular empty$
    { "" }
    { "\dircela{" cellular "}" * * }
  if$
}

FUNCTION {format.fax}
{ fax empty$
    { "" }
    { "\dirfaxa{" fax "}" * * }
  if$
}

FUNCTION {format.email}
{ email empty$
    { "" }
    { "\diremaa{" email "}" * * }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
    { "\dirurla{" url "}" * * }
  if$
}

FUNCTION {format.icq}
{ icq empty$
    { "" }
    { "\diricqa{" icq "}" * * }
  if$
}


FUNCTION {format.p.flag}
{ p.address empty$ not
  p.phone empty$ not 
  p.cellular empty$ not 
  p.fax empty$ not 
  p.email empty$ not
  p.url empty$ not
  p.icq empty$ not
  p.account empty$ not
  or or or or or or or
    { "\dirprif" }
    { "" }
  if$
}

FUNCTION {format.p.address}
{ p.address empty$
    { "" }
    { "\dirpadda{" p.address "}" * * }
  if$
}

FUNCTION {format.p.phone}
{ p.phone empty$
    { "" }
    { "\dirpphoa{" p.phone "}" * * }
  if$
}

FUNCTION {format.p.cellular}
{ p.cellular empty$
    { "" }
    { "\dirpcela{" p.cellular "}" * * }
  if$
}

FUNCTION {format.p.fax}
{ p.fax empty$
    { "" }
    { "\dirpfaxa{" p.fax "}" * * }
  if$
}

FUNCTION {format.p.email}
{ p.email empty$
    { "" }
    { "\dirpemaa{" p.email "}" * * }
  if$
}

FUNCTION {format.p.url}
{ p.url empty$
    { "" }
    { "\dirpurla{" p.url "}" * * }
  if$
}

FUNCTION {format.p.icq}
{ p.icq empty$
    { "" }
    { "\dirpicqa{" p.icq "}" * * }
  if$
}

FUNCTION {format.p.account}
{ p.account empty$
    { "" }
    { "\dirpacca{" p.account "}" * * }
  if$
}

FUNCTION {format.r.flag}
{ r.address empty$ not
  r.phone empty$ not 
  r.cellular empty$ not 
  r.fax empty$ not 
  r.email empty$ not
  r.url empty$ not
  r.icq empty$ not
  r.account empty$ not
  or or or or or or or
    { "\dirresf" }
    { "" }
  if$
}

FUNCTION {format.r.address}
{ r.address empty$
    { "" }
    { "\dirradda{" r.address "}" * * }
  if$
}

FUNCTION {format.r.phone}
{ r.phone empty$
    { "" }
    { "\dirrphoa{" r.phone "}" * * }
  if$
}

FUNCTION {format.r.cellular}
{ r.cellular empty$
    { "" }
    { "\dirrcela{" r.cellular "}" * * }
  if$
}

FUNCTION {format.r.fax}
{ r.fax empty$
    { "" }
    { "\dirrfaxa{" r.fax "}" * * }
  if$
}

FUNCTION {format.r.email}
{ r.email empty$
    { "" }
    { "\dirremaa{" r.email "}" * * }
  if$
}

FUNCTION {format.r.url}
{ r.url empty$
    { "" }
    { "\dirrurla{" r.url "}" * * }
  if$
}

FUNCTION {format.r.icq}
{ r.icq empty$
    { "" }
    { "\dirricqa{" r.icq "}" * * }
  if$
}

FUNCTION {format.r.account}
{ r.account empty$
    { "" }
    { "\dirracca{" r.account "}" * * }
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
  w.icq empty$ not
  w.account empty$ not
  or or or or or or or or or
    { "\dirworf" }
    { "" }
  if$
}

FUNCTION {format.w.title}
{ w.title empty$
    { "" }
    { "\dirtita{" w.title "}" * * }
  if$
}

FUNCTION {format.w.name}
{ w.name empty$
    { "" }
    { "\dirnama{" w.name "}" * * }
  if$
}

FUNCTION {format.w.address}
{ w.address empty$
    { "" }
    { "\dirwadda{" w.address "}" * * }
  if$
}

FUNCTION {format.w.phone}
{ w.phone empty$
    { "" }
    { "\dirwphoa{" w.phone "}" * * }
  if$
}

FUNCTION {format.w.cellular}
{ w.cellular empty$
    { "" }
    { "\dirwcela{" w.cellular "}" * * }
  if$
}

FUNCTION {format.w.fax}
{ w.fax empty$
    { "" }
    { "\dirwfaxa{" w.fax "}" * * }
  if$
}

FUNCTION {format.w.email}
{ w.email empty$
    { "" }
    { "\dirwemaa{" w.email "}" * * }
  if$
}

FUNCTION {format.w.url}
{ w.url empty$
    { "" }
    { "\dirwurla{" w.url "}" * * }
  if$
}

FUNCTION {format.w.icq}
{ w.icq empty$
    { "" }
    { "\dirwicqa{" w.icq "}" * * }
  if$
}

FUNCTION {format.w.account}
{ w.account empty$
    { "" }
    { "\dirwacca{" w.account "}" * * }
  if$
}

FUNCTION {format.note.flag}
{ note empty$
    { "" }
    { "\dirnotf" }
  if$
}

FUNCTION {format.note}
{ note empty$
    { "" }
    { "\dirnota{" note "}" * * }
  if$
}


% ------------------------------------------------------------ 
%  P E R S O N   E N T R Y  
% ------------------------------------------------------------ 

FUNCTION { person }
{ 
  newline$

  "\dircheck{" write$
  format.first.letter write$
  "}" write$
  newline$

  "\diritem[" write$
  format.name write$
  "]{" write$
  "d." cite$ * write$
  "}\dirgroup" write$
  format.nickname write$  
  newline$
  "\dirblock" write$
  newline$

  format.birthday.flag output.flag
  format.birthday output

  format.p.flag output.flag
  format.p.address output
  format.p.phone output
  format.p.cellular output
  format.p.fax output
  format.p.email output
  format.p.url output
  format.p.icq output
  format.p.account output

  format.r.flag output.flag
  format.r.address output
  format.r.phone output
  format.r.cellular output
  format.r.fax output
  format.r.email output
  format.r.url output
  format.r.icq output
  format.r.account output

  format.w.flag output.flag
  format.w.title output
  format.w.name output
  format.w.address output
  format.w.phone output
  format.w.cellular output
  format.w.fax output
  format.w.email output
  format.w.url output
  format.w.icq output
  format.w.account output

  format.note.flag output.flag
  format.note output

  "\direndgroup" write$
  newline$
}

% ------------------------------------------------------------ 
%  C O M P A N Y   E N T R Y  
% ------------------------------------------------------------ 


FUNCTION { company }
{ 
  newline$

  "\dircheck{" write$
  format.first.letter write$
  "}" write$
  newline$

  "\diritem[" write$
  name write$
  "]{" write$
  "d." cite$ * write$
  "}\dirgroup" write$
  newline$
  "\dirblock" write$
  newline$

  format.address output
  format.phone output
  format.cellular output
  format.fax output
  format.email output
  format.url output
  format.icq output
  format.account output
  format.note.flag output.flag
  format.note output

  "\direndgroup" write$
  newline$
}

% ------------------------------------------------------------ 
%  P L A C E   E N T R Y  
% ------------------------------------------------------------ 

FUNCTION { place }
{ 
  newline$

  "\dircheck{" write$
  format.first.letter write$
  "}" write$
  newline$

  "\diritem[" write$
  name write$
  "]{" write$
  "d." cite$ * write$
  "}\dirgroup" write$
  newline$
  "\dirblock" write$
  newline$

  format.address output
  format.phone output
  format.cellular output
  format.fax output
  format.note.flag output.flag
  format.note output

  "\direndgroup" write$
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

