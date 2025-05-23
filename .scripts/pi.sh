#!/bin/bash
# Ravi Roy (https://github.com/Ravieroy)
# Improved by Assistant (OpenAI)

# Text colors for aesthetics
clear
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)

# Display syntax error message if no arguments are provided
if [ $# -eq 0 ] || ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "${txtred}Error: Invalid Syntax or Missing Argument.${txtrst}"
    echo "${txtcyn}----------------------------------------${txtrst}"
    echo "${txtylw}n : Number of random points (positive integer).${txtrst}"
    echo "${txtcyn}----------------------------------------${txtrst}"
    echo "${txtgrn}Usage:${txtcyn} $0 n"
    exit 1
fi

# Input: number of random points
num_points=$1

# Initialize counters
inside_circle=0
total_points=0

# Generate random points and check if they fall inside the unit circle
for ((i = 0; i < num_points; i++)); do
    x=$(awk -v seed="$RANDOM" 'BEGIN { srand(seed); printf "%.5f\n", rand() }')
    y=$(awk -v seed="$RANDOM" 'BEGIN { srand(seed); printf "%.5f\n", rand() }')
    radius=$(echo "scale=5; sqrt($x*$x + $y*$y)" | bc)

    if (( $(echo "$radius <= 1" | bc -l) )); then
        inside_circle=$((inside_circle + 1))
    fi
    total_points=$((total_points + 1))
done

# Calculate Pi using the Monte Carlo method
calculated_pi=$(echo "scale=10; 4 * $inside_circle / $total_points" | bc -l)

# True value of Pi (to calculate error)
true_pi=$(echo "scale=10; 4*a(1)" | bc -l)
error=$(echo "scale=10; $true_pi - $calculated_pi" | bc -l)

# Display the results
echo "${txtcyn}----------------------------------------${txtrst}"
echo "${txtylw}Number of Points:${txtrst} $num_points"
echo "${txtylw}Calculated Value of Pi:${txtrst} ${txtgrn}$calculated_pi${txtrst}"
echo "${txtylw}True Value of Pi:${txtrst} ${txtgrn}$true_pi${txtrst}"
echo "${txtylw}Error:${txtrst} ${txtred}$error${txtrst}"
echo "${txtcyn}----------------------------------------${txtrst}"

