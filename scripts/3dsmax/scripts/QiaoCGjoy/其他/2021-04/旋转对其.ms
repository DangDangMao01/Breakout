$[1].rotation = $[2].rotation 

rota=($[2].transform.rotation-$[1].transform.rotation)as eulerangles
rotate $[1] rota
