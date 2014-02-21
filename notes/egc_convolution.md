Background
==========

Given $n$ independent random variables, denoted $X_1, X_2, \dots X_n$, described by the PDFs $f_1(y), f_2(y), \dots f_n(y)$, the PDF of their sum
$X_1 + X_2 + \cdots X_n$ is given by the convolution of their PDFs $f_1(y) \ast f_2(y) \ast \cdots f_n(y)$.

In this case all sources are statistically identical but independent. Hence the overall PDF is $f_{EGC}(y) = f(y) \ast f(y) \ast \cdots f(y) = f^{(n-1) \ast}(y)$
(using the notation that $f^{2 \ast} \equiv f(y) \ast f(y) \ast f(y)$).

From before, $f(y) = \sum\limits_{\Delta_i} \omega_{i_{\Delta_i}} T(\Delta_i) \dfrac{[\cdots]}{\sqrt{2 \pi} \sigma_X}$

This was found using the Gauss-Legendre method, which states that:

$$
\int_a^b f(x) dx \simeq \dfrac{b-a}{2} \sum\limits_{i=1}^n \omega_i f \left ( \dfrac{b-a}{2} z_i + \dfrac{b+a}{2} \right ) 
$$

EGC case assuming Gram-Charlier approximation
=============================================

For l=2 antennae, we must solve the case where each antenna output is summed together, ie $f_{EGC}(y) = f(y) \ast f(y)$.

Using the Gauss-Legendre method to break the convolution integral into a sum,

$$
\begin{matrix*}[l]
f_{EGC}(y) & = \int\limits_{-\infty}^{\infty} f(x) f(y-x) dx \\
 & \simeq \int\limits_{-1}^5 f(x) f(y-x) dx \\
 & \simeq \sum\limits_{i=1}^{n_f} \: 3 \omega_i \: f(3 z_i + 2) \: f(y - 3 z_i - 2)
\end{matrix*}
$$

For the l=3 antennae, the solution is now $f^{2 \ast} = f(y) \ast f(y) \ast f(y)$.

$$
\begin{matrix*}[l]
f_{EGC}(y) & = \int\limits_{-\infty}^{\infty} f(y-x) f^{\ast}(x) dx \\
 & \simeq \int\limits_{-1}^5 f(y-x) f^{\ast}(x) dx \\
 & \simeq \sum\limits_{j=1}^{n_f} \: 3 \omega_j \: f(y - 3 z_i - 2) \: f^{\ast}(3 z_i + 2) \\
 & \simeq \sum\limits_{j=1}^{n_f} \: 3 \omega_j \: f(y - 3 z_i - 2) \: \sum\limits_{i=1}^{n_f} \: 3 \omega_i \: f(3 z_i + 2) \: f(3z_j - 3 z_i) \\
 & \simeq \sum\limits_{i=1}^{n_f} \sum\limits_{j=1}^{n_f} \: 3^2 \omega_i \omega_j \: f(3 z_j - 3 z_i) \: f(3 z_i + 2) \: f(y - 3 z_j - 2) 
\end{matrix*}
$$

Doing this a few more times it appears that the PDF of the output of a l=m+1 antenna EGC system is given by

$$
\begin{matrix*}[l]
f_{EGC}(y) = f^{m \ast}(y) \simeq \sum\limits_{a_1=1}^{n_f} \sum\limits_{a_2=1}^{n_f} \cdots \sum\limits_{a_m=1}^{n_f} \: 3^m \omega_{a_1} \omega_{a_2} \cdots \omega_{a_m} \\
f(3 z_{a_m} - 3 z_{a_{m-1}}) \: f(3 z_{a_{m-1}} - 3 z_{a_{m-2}}) \cdots f(3 z_{a_2} - 3 z_{a_1}) \: f(3 z_{a_1} + 2) \: f(y - 3 z_{a_m} - 2) 
\end{matrix*}
$$

