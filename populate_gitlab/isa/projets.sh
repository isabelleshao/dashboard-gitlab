#!/bin/bash


nameproj=("Expr"  "MotCroise"  "MultiSet" "PinBoard" "Tortue"  "ILP1" "ILP2"  "ILP3"  "ILP4" "Test project no pipeline"  "Ilp1" "starting_kit"  "dashboard")
idproj=(2 3 4 5 6 7 8 9 10 12 15 26 28)



for i in {1..143}
do
    for (( c=0; c<${#nameproj[@]}; c++ ))
    do

curl -X POST 'https://pstl.algo-prog.info/api/v4/projects/'${idproj[$c]}'/fork?private_token=TOKEN' -H 'cache-control: no-cache' -H 'content-type: application/json' -d '{"name":"'"${nameproj[$c]}"'", "namespace":'$i'}'



    done
done
