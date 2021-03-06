numInd Function
```{r}

#generates genotype and phenotype data
numInd.function <- function(var, da, IAF) {
  
  ### Generates genotype and phenotype data based on genetic inputs of QTL variance(var), the dominance additivity(da), and the increaser
  ### allele frequency(IAF)
  
  #number of indiviuals is decided by the increaser allele frequency
  #NAF = null increaser frequency
  NAF = 1 - IAF
  pq2 = (2*IAF*NAF) 
  HWMin = min(IAF^2, pq2, NAF^2)
  numInd = max((10/HWMin), 1000)
  
  #Additive Term
  at = sqrt(var/(2*IAF*(1-IAF)*(1+da*(1-2*IAF))^2+4*IAF^2*(1-IAF)^2*da^2))
  #Dominance Term
  dt = at*da
  #Mean
  mean = -(IAF^2*at+2*IAF*(1-IAF)*dt-((1-IAF)^2)*at)
  
  #Mean + Additive Term - genotype 2
  mat = mean + at
  #Mean + Dominance Term - genotype 1
  mdt = mean + dt
  #Mean - Additive Term - genotype 0
  negmat = mean - at
  
  #Residual Variance
  rVar = 1-var
  #Residual Standard Deviation
  rsd = sqrt(rVar)
  
  #random genotype based on IAF, random phenotype based on genotype
  randGeno <- runif(1)
  if (randGeno <= (NAF^2)) {
    geno <- 0
    pheno <- qnorm(runif(1), mean=negmat, sd=rsd)
  } #end of geno0 assignment
  
  if  (randGeno >= (1-IAF^2)) {
    geno <- 2
    pheno <- qnorm(runif(1), mean=mat, sd=rsd)
  } #end of geno2 assignment
  
  if (randGeno > NAF^2 && randGeno < (1-IAF^2)) {
    geno <- 1
    pheno <- qnorm(runif(1), mean=mdt, sd=rsd)
  } #end of geno1 assignment
  return.mat <- matrix(nrow = 1, ncol = 2)
  return.mat <- c(geno, pheno)
  return(return.mat)
  
}#end of numInd function

