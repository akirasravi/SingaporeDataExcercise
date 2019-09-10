# SingaporeDataExcercise

This application will show the each year and curresponding data consumption in columns, on click of each row it will expand and show quarterly data.

Clickable image is added to the rows which has decrease in data in any quarter. on click of image, shown an alert with all quarter's data.
1) Used MVVM Design pattern 
2) Whole businesslogic is in ViewModel . 
3) SingaporeDataViewControllerDelegate protocol is used to perform UI operatiuons from viewModel
4) In Tableview each cell can be expandable to show each quarter's data
5) ServiceUtilMock and ServiceUtilErrorMock used to mock service response .
6) Used coreData to cache the records, will be fetched when service fails.

