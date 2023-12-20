import sys
import math

# Check if sample size is provided
if len(sys.argv) != 2:
    print("usage: python estimate.py <SAMPLE_SIZE>")
    sys.exit()

n_samples = int(sys.argv[1])

# Read possibly legal positions from stdin, one position per line
# The first 6 fields on each line are FEN data, and the 7th is either "legal" or "illegal"
n_lines = 0
legal_mults = {}  # Dictionary counting number of legal positions with each multiplicity
sum_mults = 0

for line in sys.stdin:
    a = line.split()
    if len(a) <= 6:
        print(f"not in form FEN data: {line}")
        sys.exit(1)
    if "legal" not in a[6]:
        print(f"no legality: {line}")
        sys.exit(1)
    mult = int(a[5])
    sum_mults += mult
    if "illegal" not in a[6]:
        legal_mults[mult] = legal_mults.get(mult, 0) + 1
    n_lines += 1

# Compute the number of legal positions in the sample and the sum of 1/mult over all legal positions
nlegal = 0
sum_recip_mult = 0
for i in legal_mults:
    nlegal += legal_mults[i]
    sum_recip_mult += legal_mults[i] / i

mu = sum_recip_mult / n_samples

# The sample mean of Y as an estimate of its expected value L
print(f"Exp[Y] ~ {mu} * N")

variance = (n_samples - nlegal) * (0 - mu)**2
for i in legal_mults:
    variance += legal_mults[i] * (1/i - mu)**2

# Unbiased sample variance as an estimate of the variance of Y
variance /= n_samples - 1

print(f"Var[Y] ~ {variance} * N^2")

# (Biased) sample standard deviation as an estimate of the standard deviation of Y
std_dev = math.sqrt(variance)

print(f"Sigma[Y] ~ {std_dev} * N")

# Average of n samples has sqrt(n) smaller standard deviation
sample_std_dev = std_dev / math.sqrt(n_samples)

print(f"Sigma[Y[S]] ~ {sample_std_dev} * N")

avg_recip_mult = sum_recip_mult / nlegal

print(f"n = {n_samples} samples {nlegal}/{n_lines} legal {list(legal_mults.values())} avg 1/mult {avg_recip_mult}")

# Chess Position Ranking size
N = 8726713169886222032347729969256422370854716254

print(f"estimate {mu * N} +- {1.96 * sample_std_dev * N} at 95% confidence")
