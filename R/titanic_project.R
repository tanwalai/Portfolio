# In this project, I created a "Logistic Regression Model' to predict which passengers survived the Titanic

library(titanic)
library(tidyverse)
library(ggplot2)

# Step 1 : Data Exploration
head(titanic_train)

# Create tibble for using in this project
DF <- titanic_train
DF <- as_tibble(DF)

# Check missing value
sum(is.na(DF))
colSums(is.na(DF)) # Column Age has 177 missing values

# Cabin : This column also has missing value but define as a " ". So, I decided to do not use Cabin column as a independent variable.
DF %>%
  count(Cabin)

# Pclass : interesting variable because in this variable they have too far different percent to survive.
# 1st: 62.96% survived, 2nd: 47.28% survived, 3rd:26.77% survived
DF %>%
  group_by(Survived) %>%
  count(Pclass)

# Sex : interesting variable because in this variable they have too far different percent to survive.
# female: 74.20% survived, male: 18.89% survived
DF %>%
  group_by(Survived) %>%
  count(Sex)

# Age : not sure => Age of survival and people who do not survive have the same pattern
ggplot(DF, aes(Age, fill = Survived)) +
  geom_histogram()

# SibSp : not sure => SibSp of survival and people who do not survive have the same pattern
ggplot(DF, aes(SibSp, fill = Survived)) +
  geom_histogram(bins=5)

# Parch :not sure => Parch of survival and people who do not survive have the same pattern
ggplot(DF, aes(Parch, fill = Survived)) +
  geom_histogram(bins=7)

# Fare :not sure => Parch of survival and people who do not survive have the same pattern
ggplot(DF, aes(Fare, fill = Survived)) +
  geom_histogram()

#Embarked : not sure => Embarked of survival and people who do not survive have the same pattern
ggplot(DF, aes(Embarked, fill = Survived)) +
  geom_bar(position = 'dodge')

## ---------------------------------------------------------------------
# Step 2: Data preparerion

# Clean the data : remove the rows that have a missing value.
DF <- na.omit(DF)
colSums(is.na(DF))

# Convert Survived & Pclass column to Factor
DF$Survived <- factor(DF$Survived,
                      levels = c(0,1),
                      labels = c('No', 'Yes'))

DF$Pclass <- factor(DF$Pclass,
                    levels = c('1', '2', '3'),
                    labels = c('1st', '2nd', '3rd'))

# Split data for train data (80%) and test data (20%)
n <- nrow(DF)
set.seed(22)
id <- sample(1:n, size = n*0.8)
train_data <- DF[id, ]
test_data <- DF[-id, ]

n == nrow(train_data) + nrow(test_data)

## ---------------------------------------------------------------------
# Step 3 : Create 'Logistic Regression Model'
# from information that i get from step 1 : I select Pclass, Sex to be independent variables in the model

# 1st models : Survived = f(Pclass + Sex)
# train model1
model1 <- glm(Survived ~ Sex + Pclass, data = train_data, family = "binomial")
summary(model1)

# model1 predict Survived (in train data)
predict_train <- predict(model1, type = "response")
train_data$pred_Survived <- ifelse(predict_train >= 0.5, "Yes", "No")
train_data[ , c(2,13)]

# evaluate model
matrix_train <- table(train_data$pred_Survived, train_data$Survived,
                      dnn = c("Predict", "Actual"))

cat("Accurracy train model1 : ", (matrix_train[1,1] + matrix_train[2,2])/sum(matrix_train) * 100, "%")

# ---------------- train - test model 1 --------------------------------
# model1 predict Survived (in test data)
predict_test <- predict(model1, newdata = test_data, type = "response")
test_data$pred_Survived <- ifelse(predict_test >= 0.5, "Yes", "No")
test_data[ , c(2,13)]

# evaluate model
matrix_test <- table(test_data$pred_Survived, test_data$Survived,
                     dnn = c("Predict", "Actual"))

# Compare Accurracy between test and train model
cat("Accurracy train model1 : ", (matrix_train[1,1] + matrix_train[2,2])/sum(matrix_train) * 100, "%",
    "\nAccurracy test model1 : ", (matrix_test[1,1] + matrix_test[2,2])/sum(matrix_test) * 100, "%")

## ---------------------------------------------------------------------
# Step 4 : Adjust 'Logistic Regression Model'
# 2nd models : Survived = f(Pclass + Sex + Age + Embarked + Fare)
model2 <- glm(Survived ~ Pclass + Sex + Age + Fare + Embarked , data = train_data, family = "binomial")
summary(model2)

# model1 predict Survived (in train data)
predict_train2 <- predict(model1, type = "response")
train_data$pred_Survived2 <- ifelse(predict_train2 >= 0.5, "Yes", "No")

# evaluate model
matrix_train2 <- table(train_data$pred_Survived2, train_data$Survived,
                      dnn = c("Predict", "Actual"))

# ---------------- train - test model 2 --------------------------------
# model predict Survived (in test data)
predict_test2 <- predict(model2, newdata = test_data, type = "response")
test_data$pred_Survived2 <- ifelse(predict_test2 >= 0.5, "Yes", "No")

# evaluate model
matrix_test2 <- table(test_data$pred_Survived2, test_data$Survived,
                     dnn = c("Predict", "Actual"))

# Compare Accurracy between test and train model
cat("Accurracy train model2 : ", (matrix_train2[1,1] + matrix_train2[2,2])/sum(matrix_train2) * 100, "%",
    "\nAccurracy test model2 : ", (matrix_test2[1,1] + matrix_test2[2,2])/sum(matrix_test2) * 100, "%")

## After adjusting the model, Model 2 has less over-fitting than Model 1.





