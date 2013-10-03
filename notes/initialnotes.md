Probability distribution under optimum synchronization
------------------------------------------------------

Example: 4-PAM. The received signal with the receiver synchronised is given by:

$$
X(t) = \omega_0(t) + n(t)
$$

where $n(t)$ is the Additive White Gaussian Noise (AWGN). $r_i(t)$ therefore has PDF:

$$
f_X(y) = \frac{1}{\sqrt{2 \pi} \sigma} exp \left( -\frac{(y - \omega_0)^2}{2 \sigma^2} \right)
$$

The decision region boundaries are defined as the points where there is equal probability of
adjacent symbols, ie:

$$
f_{X,\omega_0}(y) = f_{X,\omega_1}(y)
$$

In reality, we could consider an additional two sources of error:

* Fading errors due to multiple propagation paths.
* Synchronisation (timing) errors in the receiver.

The former can be modelled with a Nagakami distribution, the latter with a Tikhonov distribution.
The ultimate goal is to incorporate all of these statistical models in an analysis of their effects
and ways of compensating for them.

First steps
-----------

Initially, it's a good idea to ignore fading, and just study the channel under AWGN. Timing error
can be set as constant and the response over a range of timing error values evaluated.
