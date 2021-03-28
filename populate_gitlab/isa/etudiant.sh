#!/bin/bash


etudiants=("amille" "nais" "xel" "rthur" "van" "lara" "mma" "harlotte" "drien" "elia" "va" "lexis" "ntoine" "dam" "lexandre" "mbre" "aptiste" "lemence" "nzo" "uliette" "ena" "ea" "eanne" "ulie" "ulien" "eo" "ucas" "atteo" "aeva" "ael" "athilde" "axime" "ouise" "ucie" "anon" "abriel" "oemie" "aphael" "ierre" "uentin" "ade" "ugo" "nes" "arah" "aura" "omain" "heo" "om" "ules" "icolas" "ola" "ouis" "athis" "athan" "aul" "ceane" "auline" "omane" "oe" "alentin" "than" "ylian" "ina" "isa" "aëlys" "atheo" "aron" "licia" "ndrea" "ntonin" "udrey" "ngele" "nthony" "youb" "astien" "dele" "lan" "lexia" "mandine" "ngelina" "ymeric" "ryan" "hiara" "laire" "oralie" "lsa" "gathe" "harles" "onstance" "lias" "orian" "ylan" "leonore" "lisa" "lodie" "anny" "lex" "lice" "nna" "polline" "ugustin" "andice" "harline" "lise" "milie" "lban" "melie" "urelien")
for i in {1..108}
do

curl -X POST 'https://pstl.algo-prog.info/api/v4/users?private_token=TOKEN' -H 'cache-control: no-cache' -H 'content-type: application/json' -d '{ "email": "Projetpstltest0'$i'@gmail.com","username": "'${etudiants[$i]}'","password":$i", "name": "'${etudiants[$i]}'","skip_confirmation": "true"}'




done
