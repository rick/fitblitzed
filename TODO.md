## TODO

 - [ ] make fitbit step counts into data
 - [ ] remove DEVELOPMENT hooks / upgrade to an actual test suite
   - [ ] test that everything actually still works, as we refactored Config and couldn't test fully on the plane
 - [ ] support writing back config file (to support fitbit oauth update functionality)
 - [ ] a wrapper to make it possible to get a "yes/no" + "why/why not" with counts
 - [ ] make configuration per-user (so this can work for multiple users) -> config.user(:foo)
 - [ ] interface
 - [ ] chatops
 - [ ] consistently symbolize hash keys in the config.yml
 - [ ] waiting on API key from untappd (still, will that be sufficient to let us work with multiple users?)
 - [ ] caching of past fitbit days
 - [ ] move config.yml to data somewhere, presumably
