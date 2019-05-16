close all;

N=10;
Kaprendizaje=0.07;
iteraciones=15000;
filas=1:1:N;
columnas=1:1:N;
sigmaInicial=N;
sigma=sigmaInicial;
Nentradas=2;
porcentaje=0.7; %En 70% de las iteraciones, bajo el sigma en un 10% de N. Luego lo bajo en un 1% de N.
SigmaVector=zeros(1,iteraciones); %Sirve plotearlo para ver como evoluciona el sigma

W=rand(N,N,Nentradas);
radio=sqrt(rand(iteraciones,1));
angulo=2*pi*rand(iteraciones,1);
muestras=[radio.*cos(angulo),radio.*sin(angulo)];

for i=1:iteraciones
    SigmaVector(i)=sigma;
    distancias=zeros(N,N);
    indice=1;
    deltaW=zeros(N,N,Nentradas);
    for j=1:N
        for k=1:N
            distancias(j,k)=norm([W(j,k,1),W(j,k,2)]-muestras(i,:));
        end
    end
    
    [DistanciaMinFilas FilasPosiblesGanadoras]=min(distancias); %calculo el minimo de la distancia Euclidea
    [DistanciaMin ColumnaGanadora]=min(DistanciaMinFilas);
    FilaGanadora=FilasPosiblesGanadoras(ColumnaGanadora);
    MatrizVieja=W;
    for j=1:N
        for k=1:N
            deltaW(j,k,:)=Kaprendizaje*gaussmf(norm([j,k]-[FilaGanadora,ColumnaGanadora]),[sigma 0])*(muestras(i,:)-squeeze(W(j,k,:))');
            W(j,k,:)=W(j,k,:)+deltaW(j,k,:);
        end
    end
    
    if sigma<=1
        sigma=1-0.1*floor((i-iteraciones*porcentaje)/(iteraciones*(1-porcentaje))*(10-1));
    else
        sigma=sigmaInicial-floor(i/(iteraciones*porcentaje)*(sigmaInicial-1));
    end
end

figure (1)
plot(W(:,:,1),W(:,:,2),'r');
hold on;
plot(W(:,:,1)',W(:,:,2)','r')
circle(0,0,1);
title('Mapa de preservación topológica para k=0.07 y 15000 iteraciones');
print('ejercicioB.png','-dpng');

