close all;

N=10;
k=0.01;
alpha=3;
iteraciones=100000;
indices=1:1:N;
sigmaInicial=N;
sigma=sigmaInicial;

W=rand(N,1);
W=sort(W);
muestras=rand(iteraciones,1).^(1/(1+alpha));
for i=1:iteraciones
    [DistanciaMin NeuronaGanadora]=min(abs(W-muestras(i))); %calculo el minimo de la distancia Euclidea
    deltaW=k*gaussmf(indices',[sigma NeuronaGanadora]).*(muestras(i)*ones(N,1)-W);
    W=W+deltaW;
    
    if sigma<=1
        sigma=1-0.1*floor((i-iteraciones/2)/(iteraciones/2)*(10-1));
    else
        sigma=sigmaInicial-floor(i/(iteraciones/2)*(sigmaInicial-1));
    end
end
beta=1/(1+2/3*alpha);

figure (1)
fplot(@(x)x^beta, [0 1]);
hold on;
plot(0:1/(N-1):1,W,'*r');
grid on;
xlabel('x');
legend('curva te�rica x^\beta','Valores de los pesos W','Location','Southeast');
print('Ejercicio1.png','-dpng');
