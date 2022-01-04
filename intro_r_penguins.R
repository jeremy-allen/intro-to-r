# shift-cmd-0 to restart R

#load a package into the session for use
library(tidyverse)
library(plotly)
library(readr)
library(palmerpenguins)
library(gtsummary)

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


dat %>%
  select(Species, `Flipper Length (mm)`, `Body Mass (g)`) %>% 
  gtsummary::tbl_summary(by = Species) %>% 
  gtsummary::add_p() %>% 
  gtsummary::bold_labels()



# interactive -------------------------------------------------------------

# lets make the last one an interactive javascript-based plot,
# where the user can hover and hide items
plotly::ggplotly(length_mass)

# What if we don't want to save the plots to disk,
# but want to show them in a report?
  