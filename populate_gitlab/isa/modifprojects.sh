#!/bin/bash
tags=("tme1-fini" "tme1-fin-seance" "tme2-fini" "tme2-derniere-version" "tme3-fini" "tme4-fini" "tme3-fin-seance" "tme4-fin-seance" "tme5-fin-seance" "tme6-fin-seance" "tme7-fin-seance" "tme8-fin-seance" "tme5-fini" "tme6-fini" "tme7-fini" "tme8-fini" "tme9-fini" "tme10-fini" "tme11-fini" "tme12-fini")
members=( $(seq 145 245 ) )

projets=( $(seq 100 1319 ) )



for i in {1..100}
do
    selectionprojetrandom=$(( RANDOM % ${#projets[@]} ))
    selectionNBTag=$(( RANDOM % ${#tags[@]} ))
    selectionNBMembre=$(( RANDOM % 6 ))



    curl -X POST 'https://pstl.algo-prog.info/api/v4/projects/'${projets[$selectionprojetrandom]}'/repository/commits?private_token=TOKEN' -H 'cache-control: no-cache' -H 'content-type: application/json' -d '{ "branch": "master",  "commit_message": "some commit message","actions": [{"action": "create","file_path": "foo/bar", "content": "some content" }]}'



    for j in {1.. $selectionNBMembre}
    do
        selectionMembreRandom=$(( RANDOM % ${#members[@]} ))
        curl -X POST 'https://pstl.algo-prog.info/api/v4/projects/'${projets[$selectionprojetrandom]}'/members?private_token=TOKEN' -H 'cache-control: no-cache' -H 'content-type: application/json' -d '{ "user_id": '${members[$selectionMembreRandom]}',  "access_level": 40}'
    done

    lastmembre=$(( RANDOM % ${#members[@]} ))
    curl -X POST 'https://pstl.algo-prog.info/api/v4/projects/'${projets[$selectionprojetrandom]}'/members?private_token=TOKEN' -H 'cache-control: no-cache' -H 'content-type: application/json' -d '{ "user_id": '${members[$lastmembre]}',  "access_level": 40}'

    for k in {1..$selectionNBTag}
    do
        selectionTagrandom=$(( RANDOM % ${#tags[@]} ))

        curl --request POST --header 'PRIVATE-TOKEN: TOKEN' 'https://pstl.algo-prog.info/api/v4/projects/'${projets[$selectionprojetrandom]}'/repository/tags?tag_name='${tags[$selectionTagrandom]}'&ref=master'
    done
done
