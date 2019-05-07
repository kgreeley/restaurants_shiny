library(dplyr)
library(ggplot2)
library(data.table)
library(tidyverse)
library(leaflet)
library(maps)
library(plotly)
library(readr)
library(DT)
library(googleVis)
library(gapminder)


# Load CSV Files to Use ####
rest = readr::read_csv(file = "resta_identify.csv")
data1 = readr::read_csv(file = "data.csv")

test = rest %>%
  select(name, zipcode, violation.code,violation.description, grade, year)

data1

# Dataframe for Search ####
df = rest %>% 
  select(name, zipcode, violation.code,violation.description,grade, year)

# Grade vs Borough Graph ####
inspections = unique(data1)

ggplot(data = data1) +
  geom_bar(aes(x = boro, fill = grade), position = 'dodge') +
  labs(title = 'Restaurants by borough and latest grade',
       x = 'Borough',
       y = 'Restaurants') +
  scale_fill_brewer(palette = 'Set1') +
  theme_bw() +
  theme(legend.key = element_blank())

# Plotly Graph of A/B/C ratings per month ####
month <-
  c(
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  )

grade_A = data1 %>%
  select(month, grade) %>%
  group_by(month, grade) %>%
  summarise(Total = n()) %>%
  filter(grade == "A")

grade_A = subset(grade_A, select = Total)

grade_B = data1 %>%
  select(month, grade) %>%
  group_by(month, grade) %>%
  summarise(Total = n()) %>%
  filter(grade == "B")

grade_B = subset(grade_B, select = Total)

grade_C = data1 %>%
  select(month, grade) %>%
  group_by(month, grade) %>%
  summarise(Total = n()) %>%
  filter(grade == "C")

grade_C = subset(grade_C, select = Total)

abc1 = data.frame(month, grade_A, grade_B, grade_C)

abc1$month <- factor(abc1$month, levels = abc1[["month"]])

p = plot_ly(
  abc1,
  x = ~ month,
  y = ~ Total,
  name = 'A',
  type = 'scatter',
  mode = 'lines'
) %>%
  add_trace(y = ~ Total.1,
            name = 'B',
            mode = 'lines') %>%
  add_trace(y = ~ Total.2,
            name = 'C',
            mode = 'lines')