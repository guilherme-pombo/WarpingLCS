#ifndef MATRIX_H
#define	MATRIX_H

class Mat {

	// These are the public member functions for anyone using the library to call
public:
	// Create a matrix of dimension nxm
	Mat(int n, int m); // CONSTRUCTOR
	// Create an nxm matrix initialized to input_array
	Mat(int n, int m, double* input_array); // CONSTRUCTOR
	// Create an nxm matrix initialized to a certain value
	Mat(int n, int m, double value); // CONSTRUCTOR
	// Create a copy of input matrix
	Mat(const Mat& input_matrix); // COPY CONSTRUCTOR
	// Release the dynamically allocated memory
	~Mat(); // DESTRUCTOR
	// Create an nxm matrix initialized to all zeros
	Mat zeros(int n, int m);
	// Create an nxm identity matrix
	Mat eye(int n);
	// Extract row i from the matrix
	Mat row(int i);
	// Extract column j from the matrix
	Mat col(int j);
	// Overload the () operator for element extraction
	double operator()(int i, int j);
	// Overload the assignment operator
	Mat operator=(Mat B);
	// Overload the equivalency operatro
	bool operator==(Mat B);
	// This is the matrix multiplication routine
	Mat mul(const Mat& B);
	// This is the matrix addition routine
	Mat add(const Mat& B);
	// We will use this function to print out small matrices for testing purposes
	void show();
	void set(unsigned int x, unsigned int y, double value);
	double get(unsigned int x, unsigned int y);
	//returns the biggest coordinate of matrix
	int getLargestCoordinate();
	int getRows();
private:
	int rows; // Store the number of rows of the matrix
	int cols; // Store the number of columns of the matrix
	int num_elements; // Store the number of elements in the matrix = rows*cols
	double* data; // This is a pointer to the actual data
	
};

#endif	/* MATRIX_H */