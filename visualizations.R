cars <- read_csv('https://www.dropbox.com/s/piimbmlxxn2d1f5/cars.csv?dl=1')

library(tidyverse)

# Data Preparation and Visualization

# 1. Highway MPG by Cylinders
data_1 <- cars %>% 
  mutate(
    cylinders_c = case_when(
      cylinders %in% c(4, 6, 8) ~ as.factor(cylinders),
      TRUE ~ NA_real_
    )
  ) %>%
  filter(!is.na(cylinders_c)) %>%
  select(make, model, mpg_hwy, cylinders_c)

plot_1 <- ggplot(data_1, aes(x = mpg_hwy, fill = cylinders_c)) +
  geom_histogram(color = "black", bins = 15, alpha = 0.5, position = 'dodge') +
  labs(
    title = "Highway MPG by Cylinders",
    x = "Highway MPG",
    y = "Count"
  ) +
  theme_bw()

# 2. Density of City MPG for Different Eras
data_2 <- cars %>% 
  filter(year %in% c(1985, 1995, 2010)) %>% 
  mutate(
    era = case_when(
      year == 1985 ~ "80s",
      year == 1995 ~ "90s",
      year == 2010 ~ "2000s"
    )
  ) %>% 
  select(make, model, mpg_city, era)

plot_2 <- ggplot(data_2, aes(x = mpg_city, fill = era)) +
  geom_density(alpha = 0.5) +
  geom_vline(xintercept = 30, color = "green") +
  labs(
    title = "Density of City MPG for Different Eras",
    x = "City MPG",
    y = "Density"
  ) +
  theme_bw()

# 3. Count of Makes and Top 4 Classes
data_3 <- cars %>% 
  filter(class %in% c("Compact Cars", "Midsize Cars", "Standard Pickup Trucks", "Subcompact Cars")) %>% 
  select(make, class)

plot_3 <- ggplot(data_3, aes(x = make, fill = class)) +
  geom_bar() +
  labs(
    title = "Count of Makes and Top 4 Classes",
    x = "Make",
    y = "Count"
  ) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  theme_bw()

# 4. Distribution of Highway MPG for 4 Makes
data_4 <- cars %>% 
  filter(make %in% c("Chevrolet", "Mercedes-Benz", "Porsche", "Toyota")) %>% 
  select(make, mpg_hwy)

plot_4 <- ggplot(data_4, aes(x = make, y = mpg_hwy, fill = make)) +
  geom_violin() + 
  labs(
    title = "Distribution of Highway MPG for 4 Makes", 
    x = "Make",
    y = "Highway MPG"
  ) +
  annotate(
    "text", x = 1.25, y = 105,
    label = "Spark EV, MPG = 109",
    color = "black",
    size = 4
  ) +
  theme_bw()

# 5. City MPG by Cylinders and Drive Type
data_5 <- cars %>% 
  filter(year >= 2008) %>% 
  filter(drive %in% c("Rear-Wheel Drive", "Front-Wheel Drive", "4-Wheel or All-Wheel Drive"))

plot_5 <- ggplot(data_5, aes(x = factor(cylinders), y = mpg_city, fill = drive)) +
  geom_jitter(size = 3, alpha = 0.5, position = position_jitter(width = 0.1)) +
  labs(
    title = "City MPG by Cylinders and Drive Type", 
    y = "City MPG", 
    x = "Cylinders"
  ) +
  scale_x_discrete(labels = as.character(unique(data_5$cylinders))) +
  theme_bw()

# 6. City MPG by Engine Size and Drive Type
data_6 <- cars %>% 
  filter(drive != "Part-time 4-Wheel Drive") %>% 
  filter(!is.na(eng_size)) %>% 
  select(eng_size, mpg_city, drive)

plot_6 <- ggplot(data_6, aes(x = eng_size, y = mpg_city)) +
  geom_point(alpha = 0.5, size = 2, color = "blue") +
  geom_smooth(method = "loess", se = FALSE, color = "orange") +
  facet_wrap(~drive, scales = "free") +
  labs(
    title = "City MPG by Engine Size and Drive Type", 
    y = "City MPG", 
    x = "Engine Size"
  ) +
  theme_bw()

# 7. MPG Over time across make and fuel type
data_7 <- cars %>% 
  filter(make %in% c("Chevrolet", "Dodge", "Ford", "Toyota")) %>% 
  mutate(
    fuel_group = if_else(fuel == "Regular", "Regular Unleaded", "Other")
  ) %>%
  pivot_longer(cols = c(mpg_city, mpg_hwy), names_to = "mpg_type", values_to = "mpg") %>% 
  mutate(
    mpg_type = if_else(mpg_type == "mpg_city", "City", "Highway")
  ) %>%
  group_by(make, year, mpg_type, fuel_group) %>% 
  mutate(mpg = mean(mpg))

plot_7 <- ggplot(data_7, aes(x = year, y = mpg, color = mpg_type)) +
  geom_line(alpha = 0.5) +
  facet_grid(fuel_group ~ make) +
  labs(
    title = "MPG Over time across Make and Fuel Type",
    x = "Year",
    y = "Avg MPG"
  ) +
  theme_bw()

# Displaying Plots
grid.arrange(plot_1, plot_2, plot_3, plot_4, plot_5, plot_6, plot_7, ncol = 2)
