close all;

CantCiudades=200; %el ejercicio luego hacerlo con 200 ciudades
N=2*CantCiudades;
Kaprendizaje=1;
iteraciones=2500;
filas=1:1:N;
columnas=1:1:N;
sigmaInicial=N;
sigma=sigmaInicial;
Nentradas=2;
porcentaje=0.7; %En el 50% de las iteraciones, bajo el sigma en un 10% de N. Luego lo bajo en un 1% de N.
SigmaVector=zeros(1,iteraciones); %Sirve plotearlo para ver como evoluciona el sigma
indices=1:1:N;

%Distribuyo las ciudades aleatoriamente
angulos=0:2*pi/(N-1):2*pi;
W=[cos(angulos)',sin(angulos)'];
ciudades=3*rand(CantCiudades,2)-3/2;

for i=1:iteraciones
    for j=1:CantCiudades
        SigmaVector(i)=sigma;
        distancias=zeros(N,1);
        for k=1:N
            distancias(k)=norm(W(k,:)-ciudades(j,:));
        end
        [DistanciaMin, NeuronaGanadora]=min(distancias); %calculo el minimo de la distancia Euclidea    
        DistanciasNeuronas=indices-NeuronaGanadora*ones(size(indices));
        %Si la distancia de cada neurona a la neurona ganadora es mayor a
        %la mitad de N, calculo la distancia por el otro camino
        for k=1:N
            if DistanciasNeuronas(k)>0.5*N
                DistanciasNeuronas(k)=N-k+NeuronaGanadora;
            end
        end
        factor=Kaprendizaje*gaussmf(DistanciasNeuronas',[sigma 0]);
        deltaW=[factor.*(ciudades(j,1)*ones(N,1)-W(:,1)),factor.*(ciudades(j,2)*ones(N,1)-W(:,2))];
        W=W+deltaW;
    end
 
    %Disminucion de sigma
    if sigma<=1
        sigma=1-0.1*floor((i-iteraciones*porcentaje)/(iteraciones*(1-porcentaje))*(10-1));
    else
        sigma=sigmaInicial-floor(i/(iteraciones*porcentaje)*(sigmaInicial-1));
    end
end

figure (1)
plot(W(:,1),W(:,2),'r');
hold on;
plot(ciudades(:,1),ciudades(:,2),'ob');
hold on;
plot(W(1,1),W(1,2),'*g');
hold on;
plot(W(end,1),W(end,2),'*m');
title('Problema del viajante de comercio con 200 ciudades y 2500 iteraciones');
grid on;
print('ejercicio2.png','-dpng');

figure (2)
plot(SigmaVector); %se muestra como varia la varianza en función de las iteraciones
title('Variación del Sigma de la función de vecindad');
xlabel('Iteraciones');
ylabel('Sigma');