## use Example
### get data ####
set.seed(678)
path <- 'https://raw.githubusercontent.com/guru99-edu/R-Programming/master/titanic_data.csv'
titanic <-read.csv(path)
head(titanic)
### cut data ####
shuffle_index <- sample(1:nrow(titanic))
head(shuffle_index)
titanic <- titanic[shuffle_index, ]
head(titanic)
## 自己家的部份 因為資料中有出現 "?"
titanic[which(titanic == "?",arr.ind = T)] <- NA
names(titanic)
### clean dataset ######
library(dplyr)
# Drop variables
clean_titanic <- titanic %>%
  select(-c(home.dest, cabin, name, x, ticket)) %>% 
  #Convert to factor level
  mutate(pclass = factor(pclass, levels = c(1, 2, 3), labels = c('Upper', 'Middle', 'Lower')),
         survived = factor(survived, levels = c(0, 1), labels = c('No', 'Yes'))) %>%
  na.omit()
glimpse(clean_titanic)

### creat train/test set
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

### Build the model ######
library(rpart)
library(rpart.plot)
fit <- rpart(survived~., data = data_train, method = 'class')
rpart.plot(fit, extra = 106)

### Make a prediction ####
predict_unseen <- predict(fit, data_test, type = 'class')           
table_mat <- table(data_test$survived, predict_unseen)
table_mat