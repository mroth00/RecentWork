""" This tool is a Bayesian sequencial A/B testing tool. Input the total 
users in each test, N_A, N_B and the conversions for each test nA,nB. 
The results are then returned in an easy to understand Bayesian
probability.

"""

import numpy as np
import pymc as pm
from matplotlib import pyplot as plt

def kinkos(N_A, nA, N_B, nB, delta_samples):
    """This function is the printer of the result"""
    
    def print_sec_break():
        """Helper function to print ASCII section break"""
        print("\n"+"="*80)
    
    print_sec_break()
    print("In test A you had", N_A, "Visits with", nA, "conversions")
    print("In test B you had", N_B, "Visits with", nB, "conversions")
    print("Converstion rate A: {:.4f} ".format(nA/N_A))
    print("Converstion rate B: {:.4f} ".format(nB/N_B))
    print("Rate A - Rate B = {:.4f}".format(nA/N_A - nB/N_B))
    print_sec_break()
    print_sec_break()
    print("Probability site A is WORSE than site B: {:.4f}".
        format((delta_samples < 0).mean()))    
    print("Probability site A is BETTER than site B: {:.4f}".
        format((delta_samples > 0).mean()))
    print_sec_break()
    print_sec_break()
    print("Probability site A is 1% WORSE than site B: {:.4f}".
        format((delta_samples < -.01).mean()))
    print("Probability site A is 1% BETTER than site B: {:.4f}".
        format((delta_samples > .01).mean()))
    print_sec_break()
    print_sec_break()    

    print( "Probability site A is 2% WORSE than site B: {:.4f}".
        format((delta_samples < -.02).mean()))

    print("Probability site A is 2% BETTER than site B: {:.4f}".
        format((delta_samples > .02).mean()))
    print_sec_break()

def picaso(delta_samples):
    """This function plots the histogram posterior distribution """
    plt.hist(delta_samples, histtype='stepfilled', bins=30, alpha=0.85,
             label="posterior of delta", color="#7A68A6", normed=True)
    plt.vlines(0, 0, 60, linestyle="--")
    plt.vlines(0, 0, 60, color="black", alpha=0.2)
    plt.legend(loc="upper right")
    plt.ylabel("Occurences in simulated distribution")
    plt.xlabel("Conversion Rate in A - Conversion Rate in B")
    plt.show()

def main():
    """ Main Method """
    # Notice the unequal sample sizes -- no problem here.

    # Number of people in each test
    N_A = 5000
    N_B = 5000

    # Number of conversions in each test
    nA = 1200
    nB = 1107

    diff1=N_A-nA
    diff2=N_B-nB

    observations_A = np.asarray(nA*[1]+diff1*[0])
    observations_B = np.asarray(nB*[1]+diff2*[0])

    # Set up the pymc model. Again assume Uniform priors for p_A and p_B.
    # We can come back to this later, perhaps offer an easy selection of
    # a more informative prior given a mean we have seen before. 
    p_A = pm.Uniform("p_A", 0, 1)
    p_B = pm.Uniform("p_B", 0, 1)

    # Define the deterministic delta function. This is our unknown of interest.
    @pm.deterministic
    def delta(p_A=p_A, p_B=p_B):
        return p_A - p_B

    # Set of observations, in this case we have two observation datasets.
    # Just to be clear, these are the bernoulli likelihoods, given the
    # data observations_A, observations_B, times the prior p_A, p_B. 
    obs_A = pm.Bernoulli("obs_A", p_A, value=observations_A, observed=True)
    obs_B = pm.Bernoulli("obs_B", p_B, value=observations_B, observed=True)

    # Aprox using MCMC.
    mcmc = pm.MCMC([p_A, 
                    p_B, 
                    delta, 
                    obs_A, 
                    obs_B])
    mcmc.sample(30000, 6000)
    
    # These could build the theoretical priors of test A and B but we don't really care about those.
    #p_A_samples = mcmc.trace("p_A")[:]
    #p_B_samples = mcmc.trace("p_B")[:]

    #This is the money. The posterior of the difference.
    delta_samples = mcmc.trace("delta")[:]
    
    kinkos(N_A=N_A,
           nA=nA,
           N_B=N_B,
           nB=nB,
           delta_samples=delta_samples) # Print Results
    picaso(delta_samples=delta_samples) # Plot Results
    delta.summary()
    
if __name__ == '__main__':
    main()


