experiencias =  rand(6, 10000);
lancamentos = experiencias > 0.5;
resultados = sum(lancamentos);
sucessos = resultados == 6;
probSimulacao =  sum(sucessos)/10000