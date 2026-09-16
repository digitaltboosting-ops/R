# ============================================================
# pipeline.R — Operational KPI Pipeline (Nordic Freight)
# Version: 1.0
# Date: 2024-09-16
# ============================================================

library(tidyverse)
library(lubridate)
library(stringr)
library(randomForest)

# ------------------------------------------------------------
# 1. Load raw data
# ------------------------------------------------------------
raw <- read_csv("../data/shipment_raw.csv", show_col_types = FALSE)

# ------------------------------------------------------------
# 2. Cleaning functions
# ------------------------------------------------------------

# Normalize shipment IDs
clean_id <- function(x){
  x %>%
    str_to_upper() %>%
    str_replace_all("[^A-Z0-9]", "") %>%
    str_replace("^FRJ", "FRJ-") %>%
    str_replace("^GT", "GT-") %>%
    str_replace("^OS", "OS-") %>%
    str_replace("^HK", "HK-") %>%
    str_replace("^AA", "AA-") %>%
    str_replace("^TR", "TR-")
}

# Normalize dates
clean_date <- function(x){
  parse_date_time(x, orders = c("ymd","dmy","Ymd","mdy"))
}

# Normalize weights
clean_weight <- function(x){
  x %>%
    str_replace_all("[^0-9.-]", "") %>%
    as.numeric()
}

# Normalize currencies → numeric cost
clean_cost <- function(x){
  x <- str_replace_all(x, ",", "")
  x <- str_replace_all(x, "SEK", "")
  x <- str_replace_all(x, "DKK", "")
  x <- str_replace_all(x, "NOK", "")
  x <- str_replace_all(x, "EUR", "")
  x <- str_replace_all(x, "€", "")
  x <- str_replace_all(x, "[^0-9.-]", "")
  as.numeric(x)
}

# Normalize delay reasons
clean_delay <- function(x){
  x %>%
    str_to_lower() %>%
    str_replace("jam", "traffic jam") %>%
    str_replace("delayed by traffic", "traffic jam") %>%
    str_replace("warehouse issue", "warehouse delay")
}

# ------------------------------------------------------------
# 3. Apply cleaning
# ------------------------------------------------------------
clean <- raw %>%
  mutate(
    shipment_id = clean_id(shipment_id),
    ship_date = clean_date(ship_date),
    delivery_date = clean_date(delivery_date),
    weight_kg = clean_weight(weight_kg),
    cost_numeric = clean_cost(cost),
    delay_reason = clean_delay(delay_reason),

    # Flags
    invalid_weight = weight_kg <= 0 | is.na(weight_kg),
    missing_delivery = is.na(delivery_date),
    impossible_sequence = delivery_date < ship_date
  )

# ------------------------------------------------------------
# 4. Remove invalid rows (strict cleaning)
# ------------------------------------------------------------
clean_valid <- clean %>%
  filter(
    !invalid_weight,
    !missing_delivery,
    !impossible_sequence
  )

# ------------------------------------------------------------
# 5. Write cleaned dataset
# ------------------------------------------------------------
write_csv(clean_valid, "../data/shipment_clean.csv")

# ------------------------------------------------------------
# 6. KPI calculations
# ------------------------------------------------------------
kpi <- clean_valid %>%
  mutate(
    transit_days = as.numeric(delivery_date - ship_date),
    delayed = delay_reason != "none"
  ) %>%
  summarise(
    avg_transit_days = mean(transit_days),
    pct_delayed = mean(delayed) * 100,
    avg_cost = mean(cost_numeric),
    shipments = n()
  )

write_csv(kpi, "../report/kpi_tables.csv")

# ------------------------------------------------------------
# 7. Plot summary
# ------------------------------------------------------------
plot_data <- clean_valid %>%
  mutate(transit_days = as.numeric(delivery_date - ship_date))

png("../report/summary_plots.png", width = 900, height = 600)
ggplot(plot_data, aes(x = transit_days)) +
  geom_histogram(binwidth = 1, fill = "steelblue") +
  labs(title = "Transit Time Distribution", x = "Days", y = "Count")
dev.off()

# ------------------------------------------------------------
# 8. Delay prediction model
# ------------------------------------------------------------
model_data <- clean_valid %>%
  mutate(
    transit_days = as.numeric(delivery_date - ship_date),
    delayed = delay_reason != "none"
  ) %>%
  select(delayed, weight_kg, cost_numeric, transit_days)

rf <- randomForest(delayed ~ ., data = model_data, ntree = 200)

importance <- as.data.frame(rf$importance)
write_csv(importance, "../report/feature_importance.csv")

# ------------------------------------------------------------
# Done
# ------------------------------------------------------------
print("Pipeline completed successfully.")

