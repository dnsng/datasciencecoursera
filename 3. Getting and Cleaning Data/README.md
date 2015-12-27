The script \(run_analysis.R\) extracts a tidy data set from the original dataset of Avid2002.
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

The steps of the script are:   
1. Download and unzip the original dataset \(lines 2-4\)    
2. Read all the components of the dataset \(lines 6-13\)   
3. Merge the "train" and "test" dataset to get a complete dataset \(lines 16-18\)   
4. Identify the measurements \(columns\) that are means and standard deviations, and subset those columns \(lines 21-34\)    
5. Include Activity and Subject identification and descriptive column names \(lines 37-39\)  
6. Create a matrix with the average of each of the measurements from observations from the same Subject and same Activity \(lines 42-64\)  
7. Transform to data.frame, use descriptive variable names and readable labels on Activity, and export as "tidy_data.txt" \(lines 67-73\).     
