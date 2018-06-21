library(tidyverse)

dat <- fivethirtyeight::mediacloud_hurricanes %>% 
  mutate(date = as.Date(date)) %>% 
  # as-is, each hurricane gets it's own column, named after itself, 
  # but it makes more sense to think of each name as a value in a categorical
  # variable. 
  gather(name, coverage, -date)

# make the table that we'll use to add landfall dates to dat
df_landfall <- tibble(
  name     = c("harvey", "irma", "maria", "jose"), 
  landfall = as.Date(c("2017-08-25", "2017-09-10", "2017-09-20", "2017-09-05")))

dat <- dat %>% 
  # join landfall column into main table so we can...
  left_join(df_landfall) %>% 
  # subtract it from each date to get a since_lf value for each hurricane on 
  # each date
  mutate(since_lf = as.integer(date - landfall))

dat %>% 
  # plot the amount of media coverage against the days since landfall
  ggplot(aes(since_lf, coverage)) + 
  # fill and colour different areas representing that relationship by 
  # hurricane name
  geom_area(aes(fill = name, colour = name), 
            lwd = 1, alpha = 0.8,
            # layer those areas, rather than stacking them
            position = "dodge") + 
  # make it look nice
  scale_x_continuous(limits = c(-7, 30)) + 
  scale_colour_viridis_d() + 
  scale_fill_viridis_d() + 
  theme_minimal()

