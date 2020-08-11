# datamodeler
Interactive GUI calculator designed with SwiftUI and Swift to generate mock data models to aid in experimental design and predict power. Can be used in conjunction with SAS statistical software for power calculations. Developed under the mentorship of Caitlin Maikawa as part of 2020 Summer Research Experience in the Appel Lab @ Stanford Dept. of Bioengineering.

Usage guidelines--
Warnings will display in red and any calculations/views to be generated will be halted if input is unrecognized.

Step 1 Notes:

Enter integer values for total measurements, treatments and number of blocking factors.
   
Enter one word (underscores ok) for name of subjects and dependent variable names to ensure compatability with SAS softtware.

If wanting to update total measurements, number of treatments, number of blocking factors, click the Continue/Update button. For the name of subjects and depenent variable name, you do not need to press the button. Pressing the button resets the treatment and blocking factors fields and storage of values.

Default values if nothing is inputed for name of subject and name of dependent variable is "Measurement" and "DependentVar", respectively.


Step 2 Notes:
Enter one word (underscores ok) for the labels of blocking factors.

Enter integer values for the value associated with each blocking factor i.e. 6 cages


Step 3 Notes:
Enter the associated error SD values for the overall experiment and between each blocking factor. These must be decimal or integer values.


Step 4 Notes:
Enter the treatment means for each treatment. These must be decimal or integer values.

If you update the error or treatment values after generating the grid and are not changing the total measurements, number of blocking factors, or number of treatments, click the update error/treatment values button. On the bottom half of right hand side, you should see newly generated error values and treatment values to be reflected.


Step 5 Notes:
Assign each treatment and blocking factor to each measurement/subject.

These must be valid inputs and integers. i.e. if there are 3 treatments, assigning treatment 5 is not a valid input and will throw an input. 


Buttons:
Reset/Generate Dependent Variable Value - Press this to reset runs or to generate dependent variable numbers for the first time.

Add run - Press this to generate multiple runs. There is a counter on the right side.

Export to text file - Press this to export text files to downloads folder. Can export multiple runs (will just be multiple text outputs concatenated together)

Export SAS to text file - Press this to export a SAS output to downloads folder. Can export multiple runs (will just be multiple SAS outputs concatenated together. This is still compatible with the SAS software and can be used for better power calculations.)



