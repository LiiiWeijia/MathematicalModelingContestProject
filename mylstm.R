# install.packages('keras')
library(keras)
# install.packages("dplyr")
library(dplyr)
library(ggplot2)
# install.packages("ggthemes")
library(ggthemes)
#install.packages("lubridate")
library(lubridate)
rm(list=ls())


#set the model using keras
model <- keras_model_sequential()

model %>%
  layer_lstm(
    units = 4,
    input_shape = c(1, look_back)) %>%
  layer_dense(
    units = 1) %>%
  compile(
    loss = 'mean_squared_error',
    optimizer = 'adam') %>%
  fit(trainXY$dataX,
      trainXY$dataY,
      epochs = 25,
      batch_size = 1,
      verbose = 2)
trainScore <- model %>%
  evaluate(
    trainXY$dataX,
    trainXY$dataY,
    verbose = 2)

testScore <- model %>%
  evaluate(
    testXY$dataX,
    testXY$dataY,
    verbose = 2)