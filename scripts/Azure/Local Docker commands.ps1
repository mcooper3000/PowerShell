

#local docker containers
1..4 | %{

    docker container run --name myapp$($_) -detach -p 808$($_):80 manojnair/myapp:v$($_) 

}

