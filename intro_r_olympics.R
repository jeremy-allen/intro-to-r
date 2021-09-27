# load a package into the session for use
library(tidyverse)
library(plotly)

# read a CSV file that is online or on disk
dat <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-08-03/athletes.csv')

# inspect the data
glimpse(dat)
skimr::skim(dat)

# drop a column that has no values
dat <- dat %>% 
  select(-guide)

# filter out rows with no athlete names
dat <- dat %>% 
  filter(!is.na(athlete))

# bar plot but bars are not in descending order
dat %>%
  #count(gender, type, sort = TRUE) %>% 
  ggplot(aes(x = type, fill = gender)) +
  geom_bar()

# this time we reorder the levels of the type factor by count

dat %>%
  mutate(type = fct_infreq(type)) %>% #reorder levels by freq
  count(gender, type, sort = TRUE) %>% 
  ggplot(aes(x = type, y = n, fill = gender)) +
  geom_bar(stat = "identity")

# save plot to disk (filename includes path)
ggsave("output/gender_by_event.png", plot = last_plot())

# line graph with default colors, add title
line_graph <- dat %>% 
  count(gender, year, sort = TRUE) %>% 
  ggplot(aes(x = year, y = n, group = gender, color = gender)) +
  geom_line() +
  labs(
    title = "Number of Olympic Athletes by Year",
    subtitle = "by gender"
  )

# save plot to disk (filename includes path)
ggsave("output/gender_over_time.png", plot = line_graph)

# lets make the last one an interactive javascript-based plot,
# where the user can hover and hide lines
plotly::ggplotly(line_graph)

# What if we don't want to save the plots to disk,
# but want to show them in a report?
  