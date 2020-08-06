function logGuassianDensity = compute_logGuassianDensity(x,miu,sigma)
nDim = length(x);
aDet = det(sigma);

logGuassianDensity = -0.5*log(aDet+eps)-0.5*(x-miu)*pinv(sigma)*(x-miu)';% -0.5*nDim*log(2*pi)-0.5*log(aDet)