clean <- raw %>%
  mutate(
    # --------------------------------------------------------
    # 1. Shipment ID normalization (optimized)
    # --------------------------------------------------------
    # Step 1: uppercase + remove illegal characters
    shipment_id = shipment_id %>%
      str_to_upper() %>%
      str_replace_all("[^A-Z0-9]", "") %>%
      
      # Step 2: insert dash after any 2–3 letter prefix
      # Example: FRJ00123 → FRJ-00123
      str_replace("^([A-Z]{2,3})([0-9])", "\\1-\\2"),

    # --------------------------------------------------------
    # 2. Date normalization (vectorized)
    # --------------------------------------------------------
    ship_date = parse_date_time(ship_date, orders = c("ymd","dmy","Ymd","mdy")),
    delivery_date = parse_date_time(delivery_date, orders = c("ymd","dmy","Ymd","mdy")),

    # --------------------------------------------------------
    # 3. Weight normalization (optimized)
    # --------------------------------------------------------
    # Removes everything except digits, minus, and decimal
    weight_kg = weight_kg %>%
      str_replace_all("[^0-9.-]", "") %>%
      as.numeric(),

    # --------------------------------------------------------
    # 4. Currency normalization (optimized)
    # --------------------------------------------------------
    # Strip currency codes/symbols → numeric cost
    cost_numeric = cost %>%
      str_replace_all("[A-Z]|€", "") %>%   # remove currency letters/symbols
      str_replace_all("[^0-9.-]", "") %>%  # remove leftover noise
      as.numeric(),

    # --------------------------------------------------------
    # 5. Delay reason normalization (optimized)
    # --------------------------------------------------------
    delay_reason = case_when(
      str_detect(str_to_lower(delay_reason), "jam") ~ "traffic jam",
      str_detect(str_to_lower(delay_reason), "warehouse") ~ "warehouse delay",
      TRUE ~ "none"
    ),

    # --------------------------------------------------------
    # 6. Flags
    # --------------------------------------------------------
    invalid_weight = weight_kg <= 0 | is.na(weight_kg),
    missing_delivery = is.na(delivery_date),
    impossible_sequence = delivery_date < ship_date
  )
