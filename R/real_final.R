# Install packages
library(tidyverse); library(caret) ; library(ggmosaic) ; library(corrplot)

# Import data
df <- read_delim("bank-additional-full.csv", delim = ";")

## ------------------------------------------------------------
## Part 1 : Explore data
# Understand the dataset
df <- as_tibble(df)
glimpse(df)

# Is it balance class ? 
table(df$y)/nrow(df)

# Explore missing value
colSums(is.na(df))
colSums(df == "")
colSums(df == "unknown")/nrow(df)

## ------------------------------------------------------------
# Explore Numeric feature
# Numeric : Age, Duration, Campaign, Pdays, Previous, Emp.var.rate, Cons.price.idx, Cons.conf.idx, Euribor3m, Nr.employed

# Create function
numeric_fn <- function(i){
  print(ggplot(df, aes({{i}}))+
          geom_histogram())
  print(df %>%
          summarise("min" = min({{i}}),
                    "mean" = mean({{i}}),
                    "median" = median({{i}}),
                    "max" = max({{i}}),
                    "range" = max-min,
                    "sd" = sd({{i}})))
}

# duration
numeric_fn(duration)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, duration), fill = y))
df %>%
  group_by(y) %>%
  summarise("mean" = mean(duration),
            "median" = median(duration),
            "min" = min(duration),
            "max" = max(duration),
            "sd" = sd(duration))

# age
numeric_fn(age)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, age), fill = y))

# pdays
numeric_fn(pdays)
df %>%
  count(pdays) %>%
  mutate("%" = n/sum(n)) %>%
  arrange(desc(n))
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, pdays), fill = y))

df %>% 
  filter(pdays != 999) %>%
  ggplot() +
  geom_mosaic(aes(x = product(y, pdays), fill = y))

# previous
numeric_fn(previous)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, previous), fill = y))

# emp.var.rate
numeric_fn(emp.var.rate)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, emp.var.rate), fill = y))

# cons.price.idx
numeric_fn(cons.price.idx)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, cons.price.idx), fill = y))

# cons.conf.idx
numeric_fn(cons.conf.idx)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, cons.conf.idx), fill = y))

# euribor3m
numeric_fn(euribor3m)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y,euribor3m), fill = y))

# nr.employed
numeric_fn(nr.employed)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y,nr.employed), fill = y))

# insight
# quarter
df %>%
  group_by(emp.var.rate) %>%
  summarise("n" = n(),
            "median_du" = median(duration))

df <- df %>%
  mutate("segment" = ifelse(age<27, "young", ifelse(age>60, "old", "middle")))
glimpse(df)

df %>%
  group_by(segment) %>%
  summarise("n" = n(),
            "median" = median(duration),
            "mean" = mean(duration))

## ------------------------------------------------------------
# Explore Category feature
# Category : Job, Marital, Education, Default, Housing, Loan, Contact, Month, Day_of_week, Poutcome

# Create function
cat_fn <- function(i){
  print(ggplot(df, aes({{i}})) +
          geom_bar())
  print(df %>%
          count({{i}}) %>%
          mutate("%" = n/sum(n)))
}

# job
cat_fn(job)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, marital), fill = y))
table(df$marital, df$y)

# education
cat_fn(education)
df %>%
  filter(education == "unknown") %>%
  count(segment)

df %>%
  group_by(segment) %>%
  count(education) %>%
  arrange(segment, desc(n)) %>%
  print(n = 23)

# default 
cat_fn(default)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, default), fill = y))
table(df$default, df$y)

# housing
cat_fn(housing)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, housing), fill = y))
table(df$housing, df$y)

# loan
cat_fn(loan)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, loan), fill = y))
table(df$loan, df$y)

# contact
cat_fn(contact)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, contact), fill = y))
table(df$contact, df$y)

# month
cat_fn(month)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, month), fill = y))
table(df$month, df$y)

# day_of_week
cat_fn(day_of_week)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, day_of_week), fill = y))
table(df$day_of_week, df$y)

# poutcome
cat_fn(poutcome)
df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(y, poutcome), fill = y))
table(df$poutcome, df$y)

## ------------------------------------------------------------
## Part 2 : Prepare data

## replace missing value
# Education : young = high school, middle = university degree, old = basic.4y
data <- df %>%
  mutate(clean_education = case_when(
    segment == "young" & education == "unknown" ~ "high.school",
    segment == "middle" & education == "unknown" ~ "university.degree",
    segment == "old" & education == "unknown" ~ "basic.4y",
    TRUE ~ education))
glimpse(data)

# housing
data <- data %>%
  mutate("clean_housing" = case_when(
    housing == "unknown" ~ "no",
    TRUE ~ housing
  ))

# loan
data <- data %>%
  mutate("clean_loan" = case_when(
    loan == "unknown" ~ "no",
    TRUE ~ loan
  ))

colSums(data == "unknown")

## remove : jobs, marital
data <- data %>%
  filter(job != "unknown" & marital != "unknown")
colSums(is.na(data))
# After : 40,787 data points (99.03%)
colSums(data == "unknown")

# Create new df
data2 <- data %>%
  select(1:3, 5, 8:20,23:25,21)
glimpse(data2)

# Change data type
data2 <- data2 %>%
  mutate_at(c("job","marital","default", "contact", "month", "day_of_week","poutcome","clean_education","clean_housing","clean_loan","y"), funs(factor))

# split data
# train data 80% , test data 20%
n = nrow(data2)

set.seed(22)
id <- sample(1:n, size = n*0.8)

train_data <- data2[id, ]
test_data <- data2[-id, ]

nrow(data2)*0.8
nrow(train_data)

## ------------------------------------------------------------
# Part 3 : Train model

# train control
ctrl <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  summaryFunction = twoClassSummary,
  verboseIter = TRUE
)

# Logistic Regression
set.seed(22)
glm_model <- train(y ~.,
                   data = train_data %>%
                     select(-pdays,-default,-duration),
                   method = "glm",
                   preProcess = c("center","scale"),
                   metric = "ROC",
                   trControl = ctrl)

# K-nearest neighbor
set.seed(22)
knn_model <- train(y~.,
                   data = train_data %>%
                     select(-pdays,-default,-duration),
                   method = "knn",
                   preProcess = c("center","scale"),
                   metric = "ROC",
                   trControl = ctrl)

# Random Forest
# there are 18 feature, So I will try mtry = 2 - 17
my_grid <- data.frame(mtry = 2:17)

set.seed(22)
rf_model <- train(y~.,
                  data = train_data %>%
                    select(-pdays,-default,-duration),
                  method = "rf",
                  preProcess = c("center","scale"),
                  metric = "ROC",
                  tuneGrid = my_grid,
                  trControl = ctrl)

result <- resamples(list(
  logistic = glm_model,
  knn = knn_model,
  randomForest = rf_model
))
summary(result)

# -------------------------------------------------------------
# Part 4 : Evaluate Model

# train
glm_train <- predict(glm_model, train_data)
confusionMatrix(glm_train, train_data$y,
                positive = "yes",
                mode = "prec_recall")

# test
glm_test <- predict(glm_model, 
                    newdata = test_data)
confusionMatrix(glm_test, test_data$y,
                positive = "yes",
                mode = "prec_recall")






