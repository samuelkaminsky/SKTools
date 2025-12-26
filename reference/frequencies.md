# Dataframe Frequencies

Calculates frequencies of every Column in a dataframe

## Usage

``` r
frequencies(df, perc = FALSE)
```

## Arguments

- df:

  Dataframe with data

- perc:

  Logical indicating whether or not to calculate percentages and valid
  percentages for each value by variable

## Value

Dataframe of frequencies for each variable and value

## Examples

``` r
frequencies(mtcars)
#>      var value  n
#> 1    mpg  10.4  2
#> 2    mpg  13.3  1
#> 3    mpg  14.3  1
#> 4    mpg  14.7  1
#> 5    mpg    15  1
#> 6    mpg  15.2  2
#> 7    mpg  15.5  1
#> 8    mpg  15.8  1
#> 9    mpg  16.4  1
#> 10   mpg  17.3  1
#> 11   mpg  17.8  1
#> 12   mpg  18.1  1
#> 13   mpg  18.7  1
#> 14   mpg  19.2  2
#> 15   mpg  19.7  1
#> 16   mpg    21  2
#> 17   mpg  21.4  2
#> 18   mpg  21.5  1
#> 19   mpg  22.8  2
#> 20   mpg  24.4  1
#> 21   mpg    26  1
#> 22   mpg  27.3  1
#> 23   mpg  30.4  2
#> 24   mpg  32.4  1
#> 25   mpg  33.9  1
#> 26   cyl     4 11
#> 27   cyl     6  7
#> 28   cyl     8 14
#> 29  disp  71.1  1
#> 30  disp  75.7  1
#> 31  disp  78.7  1
#> 32  disp    79  1
#> 33  disp  95.1  1
#> 34  disp   108  1
#> 35  disp 120.1  1
#> 36  disp 120.3  1
#> 37  disp   121  1
#> 38  disp 140.8  1
#> 39  disp   145  1
#> 40  disp 146.7  1
#> 41  disp   160  2
#> 42  disp 167.6  2
#> 43  disp   225  1
#> 44  disp   258  1
#> 45  disp 275.8  3
#> 46  disp   301  1
#> 47  disp   304  1
#> 48  disp   318  1
#> 49  disp   350  1
#> 50  disp   351  1
#> 51  disp   360  2
#> 52  disp   400  1
#> 53  disp   440  1
#> 54  disp   460  1
#> 55  disp   472  1
#> 56    hp    52  1
#> 57    hp    62  1
#> 58    hp    65  1
#> 59    hp    66  2
#> 60    hp    91  1
#> 61    hp    93  1
#> 62    hp    95  1
#> 63    hp    97  1
#> 64    hp   105  1
#> 65    hp   109  1
#> 66    hp   110  3
#> 67    hp   113  1
#> 68    hp   123  2
#> 69    hp   150  2
#> 70    hp   175  3
#> 71    hp   180  3
#> 72    hp   205  1
#> 73    hp   215  1
#> 74    hp   230  1
#> 75    hp   245  2
#> 76    hp   264  1
#> 77    hp   335  1
#> 78  drat  2.76  2
#> 79  drat  2.93  1
#> 80  drat     3  1
#> 81  drat  3.07  3
#> 82  drat  3.08  2
#> 83  drat  3.15  2
#> 84  drat  3.21  1
#> 85  drat  3.23  1
#> 86  drat  3.54  1
#> 87  drat  3.62  1
#> 88  drat  3.69  1
#> 89  drat   3.7  1
#> 90  drat  3.73  1
#> 91  drat  3.77  1
#> 92  drat  3.85  1
#> 93  drat   3.9  2
#> 94  drat  3.92  3
#> 95  drat  4.08  2
#> 96  drat  4.11  1
#> 97  drat  4.22  2
#> 98  drat  4.43  1
#> 99  drat  4.93  1
#> 100   wt 1.513  1
#> 101   wt 1.615  1
#> 102   wt 1.835  1
#> 103   wt 1.935  1
#> 104   wt  2.14  1
#> 105   wt   2.2  1
#> 106   wt  2.32  1
#> 107   wt 2.465  1
#> 108   wt  2.62  1
#> 109   wt  2.77  1
#> 110   wt  2.78  1
#> 111   wt 2.875  1
#> 112   wt  3.15  1
#> 113   wt  3.17  1
#> 114   wt  3.19  1
#> 115   wt 3.215  1
#> 116   wt 3.435  1
#> 117   wt  3.44  3
#> 118   wt  3.46  1
#> 119   wt  3.52  1
#> 120   wt  3.57  2
#> 121   wt  3.73  1
#> 122   wt  3.78  1
#> 123   wt  3.84  1
#> 124   wt 3.845  1
#> 125   wt  4.07  1
#> 126   wt  5.25  1
#> 127   wt 5.345  1
#> 128   wt 5.424  1
#> 129 qsec  14.5  1
#> 130 qsec  14.6  1
#> 131 qsec 15.41  1
#> 132 qsec  15.5  1
#> 133 qsec 15.84  1
#> 134 qsec 16.46  1
#> 135 qsec  16.7  1
#> 136 qsec 16.87  1
#> 137 qsec  16.9  1
#> 138 qsec 17.02  2
#> 139 qsec 17.05  1
#> 140 qsec  17.3  1
#> 141 qsec  17.4  1
#> 142 qsec 17.42  1
#> 143 qsec  17.6  1
#> 144 qsec 17.82  1
#> 145 qsec 17.98  1
#> 146 qsec    18  1
#> 147 qsec  18.3  1
#> 148 qsec 18.52  1
#> 149 qsec  18.6  1
#> 150 qsec 18.61  1
#> 151 qsec  18.9  2
#> 152 qsec 19.44  1
#> 153 qsec 19.47  1
#> 154 qsec  19.9  1
#> 155 qsec    20  1
#> 156 qsec 20.01  1
#> 157 qsec 20.22  1
#> 158 qsec  22.9  1
#> 159   vs     0 18
#> 160   vs     1 14
#> 161   am     0 19
#> 162   am     1 13
#> 163 gear     3 15
#> 164 gear     4 12
#> 165 gear     5  5
#> 166 carb     1  7
#> 167 carb     2 10
#> 168 carb     3  3
#> 169 carb     4 10
#> 170 carb     6  1
#> 171 carb     8  1
```
