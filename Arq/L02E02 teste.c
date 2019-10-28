#include<stdio.h>

int main(){
    int x[3], soma[3], i, j, amigos=0, perfeitos=0;

    for(int i=0;i<3;i++)
        scanf("%d", &x[i]);
    for(i=0;i<3;i++)
        soma[i]=0;

    for(i=0;i<3;i++){
        for(j=x[i]-1;j>0;j--){
            if(x[i]%j==0)
                soma[i]+=j;
        }
    }

    //amigos
    for(i=0;i<3;i++){
        for(j=0;j<3;j++){
            if(i!=j)
                if(soma[i]==x[j] && soma[j]==x[i])
                    amigos++;printf("|%d|%d|%d|%d\n", soma[i],x[j],soma[j],x[i]);
        }
    }

    //perfeitos
    for(i=0;i<3;i++){
        if(x[i]==soma[i])
            perfeitos++;
    }

    printf("amigos: %d\nperfeitos: %d\n", amigos, perfeitos);
return 0;
}
