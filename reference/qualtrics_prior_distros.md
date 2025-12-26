# Get prior distributions for a survey

Retrieves distributions for a survey on Qualtrics

## Usage

``` r
qualtrics_prior_distros(
  survey_id,
  api_token,
  datacenter = "az1",
  max_iterations = 100
)
```

## Arguments

- survey_id:

  Qualtrics Survey ID

- api_token:

  Qualtrics api token. Consider using \`Sys.getenv()\` to keep this
  secure.

- datacenter:

  Qualtrics data center (default "az1")

- max_iterations:

  Maximum number of pages to fetch per mailing list (default 100) to
  prevent infinite loops.

## Value

Data frame of distribution data

## Examples

``` r
if (FALSE) { # \dontrun{
qualtrics_prior_distros("SV_12345", Sys.getenv("QUALTRICS_KEY"))
} # }
```
