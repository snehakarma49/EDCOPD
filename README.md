# EDCOPD
An Early Diagnosis of Chronic Obstructive Disease

Lung diseases have become the leading cause of fatality worldwide. The most common form of lung disease
is the Chronic Obstructive Pulmonary Disease (COPD). The disease cannot be identified in early ages
and keeps growing with age. It can be caused due to variety of factors. This research aims to identify 
the factors that contribute to the exacerbation of COPD in an individual. Also, it aims at building machine
learning models that help to predict the health status of an individual i.e., whether the individual is
healthy or progressing towards COPD. To achieve the desired goals this research makes use of feature selection 
techniques, namely lasso regression and ridge regression to select relevant attributes, where lasso 
regression is found to be better than ridge regression. Machine learning models, namely, Random Forest,
Gradient Boosting Machine (GBM) and Decision Tree are compared for accuracy, sensitivity and specificity.
Random Forest is found to outperform the other two techniques and deems the important attributes in diagnosing COPD.

Performance Metrics of the machine learning algorithms are as follows:
1. Decision Trees
Accuracy: 64%    Specificity: 48%    Sensitivity: 87%

2. Random Forest
Accuracy: 84%    Specificity: 82%    Sensitivity: 87%

3. GBM
Accuracy: 86%    Specificty: 71%     Sensitivity: 84%
