install.packages("splines")

install.packages("FuzzyToolkitUoN")

library(splines)

library(FuzzyToolkitUoN)

dados <- read.csv("dados.csv", head=TRUE, sep=",")

regras <- read.csv(file="regras.csv", header=FALSE, stringsAsFactors=FALSE, colClasses="numeric",)

prec <- dados$precipitacao_mm

dist_rio <- dados$dist_rio_m

regras <- as.matrix(regras)

SIF_chuva <- newFIS("SIF_chuva", FISType="mamdani", andMethod="min", defuzzMethod="centroid")

SIF_chuva <- addVar(SIF_chuva, "input", "Precipitação", 0:50)

prec_alerta <- trapMF("prec_alerta", 0:50, c(0, 25, 50, 50, 1))

prec_ok <- trapMF("prec_ok", 0:50, c(0, 0, 25, 50, 1))

SIF_chuva <- addMF(SIF_chuva, "input", 1, prec_alerta)

SIF_chuva <- addMF(SIF_chuva, "input", 1, prec_ok)

SIF_chuva <- addVar(SIF_chuva, "input", "Distância do Rio", 0:100)

dist_alerta <- trapMF("dist_alerta", 0:100, c(0, 0, 25, 50, 1))

dist_ok <- trapMF("dist_ok", 0:100, c(25, 50, 100, 100, 1))

SIF_chuva <- addMF(SIF_chuva, "input", 2, dist_alerta)

SIF_chuva <- addMF(SIF_chuva, "input", 2, dist_ok)

SIF_chuva <- addVar(SIF_chuva, "output", "Nível de Alerta", 0:10)

N_Alto <- trapMF("Alto", 0:10, c(6, 7, 10, 10, 1))

N_Medio <- trapMF("Médio", 0:10, c(3, 5, 6, 7, 1))

N_Baixo <- trapMF("Baixo", 0:10, c(0, 0, 3, 5, 1))

SIF_chuva <- addMF(SIF_chuva, "output", 1, N_Alto)

SIF_chuva <- addMF(SIF_chuva, "output", 1, N_Medio)

SIF_chuva <- addMF(SIF_chuva, "output", 1, N_Baixo)

SIF_chuva <- addRule(SIF_chuva, regras)

saida <- matrix(c(cbind(prec), cbind(dist_rio)), 9, 2)

resultados <- evalFIS(saida, SIF_chuva)

