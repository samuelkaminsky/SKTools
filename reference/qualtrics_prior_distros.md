# Get prior distributions for a survey

Retrieves distributions for a survey on Qualtrics

## Usage

``` r
qualtrics_prior_distros(surveyId, api_token, datacenter = "az1")
```

## Arguments

- surveyId:

  Qualtrics Survey ID

- api_token:

  Qualtrics api token

- datacenter:

  Qualtrics data center (default "az1")

## Value

Data frame of distribution data

## Examples

``` r
if (FALSE) { # \dontrun{
qualtrics_prior_distros("SV_12345", "API_TOKEN")
} # }
```
