## use Example https://www.guru99.com/r-decision-trees.html
# 共有六個步驟
#
### Step 1) import data ####
set.seed(678)
path <- 'https://raw.githubusercontent.com/guru99-edu/R-Programming/master/titanic_data.csv'
titanic <- read.csv(path)
head(titanic)
# str(titanic)
### cut data ####
shuffle_index <- sample(1:nrow(titanic))
head(shuffle_index)
titanic <- titanic[shuffle_index, ]
head(titanic)
tail(titanic)
## 自己家的部份 因為資料中有出現 "?"
titanic[which(titanic == "?",arr.ind = T)] <- NA
## 後面再predict的時候有出現錯誤，經過檢查需要修改資料格式。
titanic$age <- as.integer(titanic$age)
titanic$fare <- as.numeric(titanic$fare)
str(titanic)
names(titanic)
### Step 2) clean dataset ######
library(dplyr)
# Drop variables
clean_titanic <- titanic %>%
  select(-c(home.dest, cabin, name, x, ticket)) %>% 
  #Convert to factor level
  mutate(pclass = factor(pclass, levels = c(1, 2, 3), labels = c('Upper', 'Middle', 'Lower')),
         survived = factor(survived, levels = c(0, 1), labels = c('No', 'Yes'))) %>%
  na.omit()
dim(clean_titanic)
`glimpse(clean_titanic) # ????

### Step 3)creat train/test set #### 
create_train_test <- function(data, size = 0.8, train = TRUE) {
  # n_row = nrow(data)
  n_row = nrow(clean_titanic)
  total_row = size * n_row
  train_sample <- 1:total_row
  if (train == TRUE) {
    return (data[train_sample, ])
  } else {
    return (data[-train_sample, ])
  }
}

data_train <- create_train_test(data = clean_titanic, size = 0.8, train = TRUE)
data_test <- create_train_test(data = clean_titanic, size = 0.8, train = FALSE)
dim(data_train)
dim(data_test)
prop.table(table(data_train$survived))

### Step 4) Build the model ######
library(rpart)
library(rpart.plot)
fit <- rpart(survived~., data = data_train, method = 'class')
# rpart.plot(fit, extra = 106)

### Step 5) Make a prediction ####
predict_unseen <- predict(fit, data_test, type = 'class')           
table_mat <- table(data_test$survived, predict_unseen)
table_mat

### Step 6) Measure performance ####
accuracy_Test <-  sum(diag(table_mat)) / sum(table_mat)
print(paste('Accuracy for test', accuracy_Test))


### Step 7) Tune the hyper_parameters ####
accuracy_tune <- function(fit) {
  predict_unseen <- predict(fit, data_test, type = 'class')
  table_mat <- table(data_test$survived, predict_unseen)
  accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
  accuracy_Test
}
control <- rpart.control(minsplit = 4,
                         minbucket = round(5 / 3),
                         maxdepth = 3,
                         cp = 0)
tune_fit <- rpart(survived~., data = data_train, method = 'class', control = control)
accuracy_tune(tune_fit)
