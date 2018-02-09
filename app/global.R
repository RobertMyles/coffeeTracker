library(shiny)
library(dygraphs)
library(Quandl)
library(dplyr)
library(ggplot2)
library(scales)

key <- "x5fBiB4SxpgfzA23cUUK" 
Quandl.api_key(key)

coffee <- Quandl("ODA/PCOFFOTM_USD", type = "xts")
# https://www.quandl.com/data/ODA/PCOFFOTM_USD-Arabica-Coffee-Price
# Arabic coffee price, comes from IMF cross country statistics 
# https://www.quandl.com/data/ODA-IMF-Cross-Country-Macroeconomic-Statistics

# starbucks data from: https://www.couponbox.com/press/cost-starbucks-coffees-around-world/

starb <- tibble(
  city = c("Bern", "Copenhagen", "Oslo", "Helsinki", "Brussels", "Stockholm",
           "Paris", "Beijing", "Vienna", "Tokyo", "Amsterdam", "Berlin", 
           "Dublin", "New York", "Sydney", "Budapest", "London", "Madrid",
           "Bangkok", "Ottawa", "Athens", "Warsaw"),
  country = c("Switzerland", "Denmark", "Norway", "Finland", "Belgium", 
              "Sweden", "France", "China", "Austria", "Japan", "Netherlands",
              "Germany", "Ireland", "USA", "Australia", "Hungary", "UK",
              "Spain", "Thailand", "Canada", "Greece", "Poland"),
  cappucino = c(6.06, 5.84, 4.97, 4.8, 4.75, 4.54, 4.41, 4.2, 4.22, 3.9, 
                3.65, 3.65, 3.57, 3.15, 3.32, 3.22, 3.24, 3.12, 3.15, 3.12,
                3.07, 2.85),
  americano = c(5.65, 4.35, 4, 3.69, 3.74, 3.61, 3.3, 3.6, 3.99, 3.59, 3.09,
                3.09, 3.02, 2.38, 2.87, 2.72, 2.91, 2.57, 2.87, 2.27, 3.29, 2.33),
  latte = c(6.06, 5.84, 5.33, 5.25, 4.75, 4.54, 4.41, 4.2, 4.22, 3.9, 3.65,
            3.54, 3.57, 3.15, 3.32, 3.22, 3.24, 3.12, 3.15, 3.12, 3.68, 2.85)
)
