library(tidyverse)
library(mosaic)

# let's return to our synthetic "population" of voters
# import synthetic_voters.csv using the Import Dataset button

# remember, here was the proportion of Biden voters in our "population"
# this is our estimand, i.e. the fact about the population that
# we want to estimate using a sample
prop(~pres, data=synthetic_voters)

# Take a sample of size N = 250 from this "population"
voter_sample = sample(synthetic_voters, size=250)

# Calculate the proportion of Biden voters in our sample
prop(~pres, data=voter_sample)

# Now all we've got is our one sample.  Yet we 
# still need to "simulate the sampling process" without
# access to the whole population.
# Seems impossible, but it isn't!

# Bootstrapping addresses this problem:
# simulate the sampling processing by
# resampling from the sample itself, and
# recalculate the proportion of Biden voters each time.
voter_sample_bootstrap = resample(voter_sample)
prop(~pres, data=voter_sample_bootstrap)

# we can combine these in a single line.
# Let's repeat this line several times:
prop(~pres, data=resample(voter_sample))
     
# let's run a full bootstrap, repeating the 
# resampling process 1000 times.
# (You usually want to do more if you can wait.)
prop_pres_bootstrap = do(1000)*prop(~pres, data=resample(voter_sample))

# first few lines
# each is the sample estimate from
# a single bootstrap sample of size 250,
# drawn with replacement from our original sample
head(prop_pres_bootstrap)

# a histogram of the bootstrap sampling distribution
ggplot(data=prop_pres_bootstrap) + 
  geom_histogram(aes(x=prop_Biden))

# the bootstrap standard error
sd(~prop_Biden, data=prop_pres_bootstrap)

# our estimate from the original sample:
prop(~pres, data=voter_sample)

# the right answer, i.e. the true value of the estimand
prop(~pres, data=synthetic_voters)

# our confidence interval reflecting our uncertainty
# about the estimand.
confint(prop_pres_bootstrap, level=0.95)

# Notice is this about 12% wide, i.e. about 2 standard errors
# to either side of the sample estimate.
# We'll learn why later -- preview: Central Limit Theorem