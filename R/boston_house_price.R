# Install packages
install.packages("mlbench")

library(tidyverse) ; library(caret) ; library(corrplot) ; library(ggmosaic)

# predict medv (price)

# ---------------------------------------------------------------
# Step 1 : Data Exploration

data("BostonHousing")
df <- as_tibble(BostonHousing)

# check data type
glimpse(df)

# which column has missing values ?
# no missing value
colSums(is.na(df))

# Numeric : crim, zn, indus, nox, rm, age, dis, rad, tax, ptratio, lstat
# Create function
numeric_fn <- function(i){
  print(ggplot(df, aes({{i}})) +
          geom_histogram())
  print(df %>%
          summarise("min" = min({{i}}),
                    "mean" = mean({{i}}),
                    "median" = median({{i}}),
                    "max" = max({{i}}),
                    "range" = max-min,
                    "sd" = sd({{i}})))
}

# crim 
numeric_fn(crim)
# positive skewed
# range : 89

# zn
numeric_fn(zn)
# positive skewed
# range : 100

# indus
numeric_fn(indus)
# normal distribution
# range : 27.3

# nox
numeric_fn(nox)
# normal distribution
# range : 0.486

# rm
numeric_fn(rm)
# normal distribution
# range : 5.22

# age
numeric_fn(age)
# negative skewed
# range : 97.1

# dis
numeric_fn(dis)
# normal distribution (has outlier)
# range : 11

# rad
numeric_fn(rad)
# normal distribution (has outlier)
# range : 23

# tax
numeric_fn(tax)
# normal distribution (has outlier)
# range : 524

# ptratio
numeric_fn(ptratio)
# normal distribution
# range : 9.4

# b
numeric_fn(b)
# negative skewed
# range : 397

# lstat
numeric_fn(lstat)
# normal distribution
# range : 36.2
# there are different range, so I will normalize data in pre-processing

# correlation
df %>%
  select(-chas) %>%
  cor() %>%
  corrplot(method = "color")

# Category : chas
df %>%
  ggplot(aes(chas))+
  geom_bar()
df %>%
  count(chas) %>%
  mutate("%" = n/sum(n))
# No : 93.1% , Yes : 6.9%
# Near to zero : so maybe I don't use this feature in model.

df %>% 
  ggplot() +
  geom_mosaic(aes(x = product(chas, medv), fill = chas))

# ---------------------------------------------------------------
# Part 2 : Prepare data
# split data
# train data 80% , test data 20%
n <- nrow(df)

set.seed(22)
id <- sample(1:n, size = n*0.8)
train_data <- df[id,]
test_data <- df[-id,]

# ---------------------------------------------------------------
# Part 3 : Create model
# pre-process : normalization , Near-zero variance
crtl <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE
)

set.seed(22)
lm_model <- train(medv~.,
                  data = train_data,
                  method = "lm",
                  preProcess = c("center", "scale", "nzv"),
                  trControl = crtl)

lm_model
lm_model$finalModel
# RMSE : 5.037

varImp(lm_model)
# remove : age, indus

set.seed(22)
new_model <- train(medv~.,
                  data = train_data %>%
                    select(-indus, -age),
                  method = "lm",
                  trControl = crtl)
new_model
new_model$finalModel
summary(new_model)
# RMSE : 5.033

# ---------------------------------------------------------------
# Part 4 : Evaluate Model

set.seed(22)
predic_tets <- predict(new_model,
                       newdata = test_data)

RMSE(predic_tets, test_data$medv)
# RMSE : 3.99

# RMSE for test data is less than train data. It might be sampling bias issue. So I will adjust how I split the data set.

# ---------------------------------------------------------------
# Part 5 : Tune Model
# Change the way how to split the data

set.seed(99)
new_id <- sample(1:n, size = n*0.8)
new_train_data <- df[new_id,]
new_test_data <- df[-new_id,]

set.seed(22)
model2 <- train(medv~.,
                   data = new_train_data %>%
                     select(-indus, -age),
                   method = "lm",
                   trControl = crtl)

new_predic_tets <- predict(model2,
                       newdata = new_test_data)

model2
RMSE(new_predic_tets, new_test_data$medv)
# RMSE : 5.77











