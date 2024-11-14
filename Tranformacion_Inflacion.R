library(readxl)
if (!require(openxlsx)) install.packages("openxlsx")
library(dplyr)
library(openxlsx)


# Directorio
setwd("~/Desktop/Magister/Tercer Ciclo/Macroeconometría/Datos Sudafrica")


# Transformación en trimestres, cosnsiderando que solo considere hasta 2023Q2
data <- inflation %>%
  mutate(
    Quarter = case_when(
      Month %in% c(1, 2, 3) ~ "Q1",
      Month %in% c(4, 5, 6) ~ "Q2",
      Month %in% c(7, 8, 9) ~ "Q3",
      Month %in% c(10, 11, 12) ~ "Q4"
    )
  ) %>%
  group_by(Year, Quarter) %>%
  summarise(Average_Inflation = mean(Inflation, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(YQ = paste(Year, Quarter, sep = "")) %>%  # Crea la columna YQ
  filter(Year < 2023 | (Year == 2023 & Quarter %in% c("Q1", "Q2"))) %>%  # Filtra hasta 2023 Q2
  select(Year, Quarter, YQ, Average_Inflation)     # Reorganiza el orden de las columnas

# Guarda el archivo en formato xlsx
write.xlsx(data, "inflation.africa.xlsx")

