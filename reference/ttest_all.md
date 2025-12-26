# Conduct T-Tests at every nth percentile for list of IVs and DVs

Conduct T-Tests at specified percentile intervals for list of IVs and
DVs

## Usage

``` r
ttest_all(df, ivs, dvs, perc = 0.05)
```

## Arguments

- df:

  Dataframe with test data

- ivs:

  Names of independent variables to be inserted into dplyr::select()

- dvs:

  Names of dependent variables to be inserted into dplyr::select()

- perc:

  Nth percentile to conduct T-Test at

## Value

Data frame of tidy t.test results

## Examples

``` r
ttest_all(mtcars, ivs = c("disp", "hp"), dvs = "mpg")
#>      IV  DV Cutoff.Perc Cutoff.Num  estimate estimate1 estimate2 statistic
#> 1  disp mpg          5%     77.350 12.863333  32.15000  19.28667  6.437172
#> 2  disp mpg         10%     80.610 12.467857  31.00000  18.53214  7.487811
#> 3  disp mpg         15%    103.485 12.787407  30.88000  18.09259  9.474545
#> 4  disp mpg         20%    120.140 10.617714  28.38571  17.76800  5.428349
#> 5  disp mpg         25%    120.825 10.662500  28.08750  17.42500  6.114276
#> 6  disp mpg         30%    142.060  9.890000  26.89000  17.00000  5.962835
#> 7  disp mpg         35%    146.445  9.364935  26.23636  16.87143  5.580778
#> 8  disp mpg         40%    160.000  9.588333  26.08333  16.49500  6.222909
#> 9  disp mpg         45%    167.220  9.362698  25.35714  15.99444  6.500651
#> 10 disp mpg         50%    196.300  8.818750  24.50000  15.68125  6.086214
#> 11 disp mpg         55%    258.890  8.872222  23.97222  15.10000  6.533936
#> 12 disp mpg         65%    279.580  8.103463  22.87619  14.77273  5.629132
#> 13 disp mpg         70%    303.100  7.768182  22.51818  14.75000  5.199585
#> 14 disp mpg         75%    326.000  7.320833  21.92083  14.60000  4.468116
#> 15 disp mpg         80%    350.800  6.790286  21.57600  14.78571  3.852147
#> 16 disp mpg         85%    360.000  6.737179  21.35385  14.61667  3.491161
#> 17 disp mpg         90%    396.000  7.332143  21.00714  13.67500  3.101331
#> 18 disp mpg         95%    449.000 10.336667  20.73667  10.40000 10.020808
#> 19   hp mpg          5%     63.650  7.796667  27.40000  19.60333  2.448128
#> 20   hp mpg         10%     66.000 10.456322  29.56667  19.11034  3.553558
#> 21   hp mpg         15%     82.250 11.365185  29.68000  18.31481  5.903071
#> 22   hp mpg         20%     93.400 10.343429  28.17143  17.82800  5.773850
#> 23   hp mpg         25%     96.500  9.879167  27.50000  17.62083  5.650915
#> 24   hp mpg         30%    106.200  8.537273  25.96000  17.42273  4.622255
#> 25   hp mpg         35%    109.850  8.312121  25.54546  17.23333  4.672693
#> 26   hp mpg         45%    112.850  8.016667  24.60000  16.58333  4.894411
#> 27   hp mpg         50%    123.000  9.216078  24.98667  15.77059  6.507323
#> 28   hp mpg         55%    150.000  8.816863  24.22353  15.40667  6.271668
#> 29   hp mpg         60%    165.000  7.874089  23.28947  15.41539  5.239040
#> 30   hp mpg         70%    178.500  8.451818  22.73182  14.28000  6.284671
#> 31   hp mpg         80%    200.000  8.545714  21.96000  13.41429  6.283849
#> 32   hp mpg         85%    220.250  6.483704  21.10370  14.62000  5.265920
#> 33   hp mpg         90%    243.500  6.275000  20.87500  14.60000  4.985214
#> 34   hp mpg         95%    253.550  5.003333  20.40333  15.40000  4.228606
#>     p.value parameter   conf.low conf.high                  method alternative
#> 1  0.034594  1.694730   2.596551 23.130115 Welch Two Sample t-test   two.sided
#> 2  0.000443  5.488427   8.299685 16.636029 Welch Two Sample t-test   two.sided
#> 3  0.000009  8.405308   9.701018 15.873797 Welch Two Sample t-test   two.sided
#> 4  0.000510  8.491751   6.152292 15.083137 Welch Two Sample t-test   two.sided
#> 5  0.000101 10.292193   6.791817 14.533183 Welch Two Sample t-test   two.sided
#> 6  0.000038 13.734357   6.326176 13.453824 Welch Two Sample t-test   two.sided
#> 7  0.000047 15.471814   5.797691 12.932179 Welch Two Sample t-test   two.sided
#> 8  0.000010 16.903194   6.336085 12.840581 Welch Two Sample t-test   two.sided
#> 9  0.000002 20.379974   6.361933 12.363464 Welch Two Sample t-test   two.sided
#> 10 0.000003 24.191131   5.829470 11.808030 Welch Two Sample t-test   two.sided
#> 11 0.000001 26.522281   6.083757 11.660687 Welch Two Sample t-test   two.sided
#> 12 0.000004 29.994183   5.163469 11.043457 Welch Two Sample t-test   two.sided
#> 13 0.000015 28.992571   4.712574 10.823790 Welch Two Sample t-test   two.sided
#> 14 0.000211 21.067858   3.914136 10.727531 Welch Two Sample t-test   two.sided
#> 15 0.001392 16.117111   3.055676 10.524896 Welch Two Sample t-test   two.sided
#> 16 0.005049 10.998145   2.489670 10.984689 Welch Two Sample t-test   two.sided
#> 17 0.028613  4.762561   1.162520 13.501766 Welch Two Sample t-test   two.sided
#> 18 0.000000 29.000000   8.226971 12.446363 Welch Two Sample t-test   two.sided
#> 19 0.202092  1.269326 -17.089367 32.682700 Welch Two Sample t-test   two.sided
#> 20 0.049733  2.529597   0.025451 20.887193 Welch Two Sample t-test   two.sided
#> 21 0.000934  6.198537   6.690481 16.039889 Welch Two Sample t-test   two.sided
#> 22 0.000192  9.825319   6.342241 14.344616 Welch Two Sample t-test   two.sided
#> 23 0.000112 11.860698   6.065107 13.693227 Welch Two Sample t-test   two.sided
#> 24 0.000316 15.290579   4.607006 12.467539 Welch Two Sample t-test   two.sided
#> 25 0.000187 18.107412   4.576439 12.047804 Welch Two Sample t-test   two.sided
#> 26 0.000041 26.812943   4.654829 11.378504 Welch Two Sample t-test   two.sided
#> 27 0.000002 21.712361   6.276672 12.155485 Welch Two Sample t-test   two.sided
#> 28 0.000001 25.345303   5.923512 11.710213 Welch Two Sample t-test   two.sided
#> 29 0.000013 28.745888   4.799001 10.949177 Welch Two Sample t-test   two.sided
#> 30 0.000001 29.999530   5.705306 11.198331 Welch Two Sample t-test   two.sided
#> 31 0.000001 25.358423   5.746853 11.344576 Welch Two Sample t-test   two.sided
#> 32 0.000011 29.879455   3.968715  8.998692 Welch Two Sample t-test   two.sided
#> 33 0.000029 28.110574   3.697081  8.852919 Welch Two Sample t-test   two.sided
#> 34 0.000276 24.929724   2.566116  7.440550 Welch Two Sample t-test   two.sided
#>     0  1    cd.est cd.mag   sig
#> 1   2 30 2.4667344  large  TRUE
#> 2   4 28 2.8307272  large  TRUE
#> 3   5 27 3.3534903  large  TRUE
#> 4   7 25 2.5763792  large  TRUE
#> 5   8 24 2.7718541  large  TRUE
#> 6  10 22 2.5434644  large  TRUE
#> 7  11 21 2.3102805  large  TRUE
#> 8  12 20 2.5136141  large  TRUE
#> 9  14 18 2.4567222  large  TRUE
#> 10 16 16 2.1518015  large  TRUE
#> 11 18 14 2.1599853  large  TRUE
#> 12 21 11 1.7382045  large  TRUE
#> 13 22 10 1.5954784  large  TRUE
#> 14 24  8 1.4137208  large  TRUE
#> 15 25  7 1.2581119  large  TRUE
#> 16 26  6 1.2267864  large  TRUE
#> 17 28  4 1.3113436  large  TRUE
#> 18 30  2 1.8608173  large  TRUE
#> 19  2 30 1.3423457  large FALSE
#> 20  3 29 1.9893738  large  TRUE
#> 21  5 27 2.5822807  large  TRUE
#> 22  7 25 2.4357947  large  TRUE
#> 23  8 24 2.3275517  large  TRUE
#> 24 10 22 1.8704787  large  TRUE
#> 25 11 21 1.8177617  large  TRUE
#> 26 14 18 1.7635098  large  TRUE
#> 27 15 17 2.3816658  large  TRUE
#> 28 17 15 2.1456097  large  TRUE
#> 29 19 13 1.6949212  large  TRUE
#> 30 22 10 1.8371438  large  TRUE
#> 31 25  7 1.7363641  large  TRUE
#> 32 27  5 1.1529750  large  TRUE
#> 33 28  4 1.0933137  large  TRUE
#> 34 30  2 0.8342328  large  TRUE
```
