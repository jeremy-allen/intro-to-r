# shift-cmd-0 to restart R

# You can run code from this script or from the console
# We will run this code from here inside the script

# load a package into the session for use
library(tidyverse)
library(plotly)
library(palmerpenguins)
library(gt)
library(lubridate)

# read a CSV file that is online or on disk
dat <- readr::read_csv('penguins_raw.csv')


# shift-cmd-r to make a section break

# clean -------------------------------------------------------------------

# inspect the data
glimpse(dat)
skimr::skim(dat)

# drop a column that has no values
dat <- dat %>% 
  select(-Comments)

# filter out rows with no sex
dat <- dat %>% 
  filter(!is.na(Sex))


# visualize ---------------------------------------------------------------

# bar plot
dat %>%
  ggplot(aes(x = Island, fill = Species)) +
  geom_bar() + 
  labs(
    title = "Where Do They Live?",
    subtitle = "by Island",
    caption = "data from palmerpenguines R package"
  )

# save plot to disk (filename includes path)
ggsave("output/species_by_island.png", plot = last_plot())

# scatter plot, add titles
length_mass <- dat %>% 
  ggplot(aes(x = `Flipper Length (mm)`, y = `Body Mass (g)`, color = Species)) +
  geom_point(alpha = .4) +
  labs(
    title = "Is Flipper Length Associated With Body Mass?",
    subtitle = "by species",
    caption = "data from palmerpenguines R package"
  ) +
  theme_light()

# save plot to disk (filename includes path)
ggsave("output/length_mass_association.png", plot = length_mass)


# make a table of our data
# but let's summarize by year, so first make a year column
dat <- dat %>%
  dplyr::arrange(`Date Egg`) %>% 
  mutate(Year = year(`Date Egg`),
         Year = as.factor(Year))

# table using gt package
dat %>% 
  janitor::clean_names() %>% 
  group_by(species, island, year) %>% # order here will influence table output
  summarise(across(culmen_length_mm:body_mass_g, mean)) %>%
  select(species, island, year, everything()) %>% 
  dplyr::arrange(species, island, year) %>% 
  gt() %>%
  tab_header(
    title = "Penguin Anatomical Changes",
    subtitle = "By species, island, and year"
  ) %>%
  fmt_number(
    columns = culmen_length_mm:body_mass_g,
    decimals = 1
  )



# interactive -------------------------------------------------------------

# lets make the last one an interactive javascript-based plot,
# where the user can hover and hide items
plotly::ggplotly(length_mass)

# What if we don't want to save the plots to disk,
# but want to show them in a report?
  