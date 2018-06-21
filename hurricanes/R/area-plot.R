library(tidyverse)

dat <- fivethirtyeight::mediacloud_hurricanes %>% 
  mutate(date = as.Date(date)) %>% 
  gather(name, coverage, -date)

df_landfall <- tibble(name = c("harvey", "irma", "maria", "jose"), 
                      landfall = as.Date(c("2017-08-25", "2017-09-10", "2017-09-20", "2017-09-05")))


dat <- dat %>% 
  left_join(df_landfall) %>% 
  mutate(since_lf = as.integer(date - landfall))

dat %>% 
  ggplot(aes(since_lf, coverage)) + 
  geom_area(aes(fill = name, colour = name), 
            lwd = 1, alpha = 0.8, position = "dodge") + 
  scale_x_continuous(limits = c(-7, 30)) + 
  scale_colour_viridis_d() + 
  scale_fill_viridis_d() + 
  theme_minimal()

