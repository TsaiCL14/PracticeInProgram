### Example in 
## https://www.geeksforgeeks.org/classifying-data-using-support-vector-machinessvms-in-r/

########### get Data #################
Dataset <- read.csv("data/social.csv")
head(Dataset)
str(Dataset) # 是 data.frame的資料格式
Dataset <- Dataset[,3:5] # 需要的資料只用3:5

Dataset$Purchased <- factor(Dataset$Purchased, levels = c(0,1))

########### split Data ##################
library(caTools)
set.seed(317)
split <-  sample.split(Dataset$Purchased, SplitRatio = 0.75)

training_set <-  subset(Dataset, split == TRUE)
test_set <-  subset(Dataset, split == FALSE)

########## Feature Scaling ##############
## 把factor 要預測的那個欄位拿掉後 進行 scale
training_set[-3] <-  scale(training_set[-3])
test_set[-3] <-  scale(test_set[-3])
#### 可以把scale 換成 min max scale 

########## fit SVM ############## 
library(e1071)

classifier  <-  svm(formula = Purchased ~ .,
                    data = training_set,
                    type = 'C-classification',
                    kernel = 'linear')


############# Predicting ############

# Predicting the Test set results
y_pred <- predict(classifier, newdata = test_set[-3])

CM <- table(test_set[,3],y_pred)
(CM[1,1]+CM[2,2])/sum(CM)

############# Visualizing the Training set results ##############


# installing library ElemStatLearn
library(ElemStatLearn)

# Plotting the training data set results
set = training_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)

grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('Age', 'EstimatedSalary')
y_grid = predict(classifier, newdata = grid_set)

plot(set[, -3],
     main = 'SVM (Training set)',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1), ylim = range(X2))

contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)

points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'coral1', 'aquamarine'))

points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))

# plotting test set results
set = test_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)

grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('Age', 'EstimatedSalary')
y_grid = predict(classifier, newdata = grid_set)

plot(set[, -3], main = 'SVM (Test set)',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1), ylim = range(X2))

contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)

points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'coral1', 'aquamarine'))

points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))