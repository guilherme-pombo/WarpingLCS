#ifndef MATRIXINT_H
#define	MATRIXINT_H

class MatInt {

	// These are the public member functions for anyone using the library to call
public:
	// Create a matrix of dimension nxm
	MatInt(int n, int m); // CONSTRUCTOR
	// Create an nxm matrix initialized to input_array
	MatInt(int n, int m, int* input_array); // CONSTRUCTOR
	// Create an nxm matrix initialized to a certain value
	MatInt(int n, int m, int value); // CONSTRUCTOR
	// Create a copy of input matrix
	MatInt(const MatInt& input_matrix); // COPY CONSTRUCTOR
	// Release the dynamically allocated memory
	~MatInt(); // DESTRUCTOR
	// Create an nxm matrix initialized to all zeros
	MatInt zeros(int n, int m);
	// Create an nxm identity matrix
	MatInt eye(int n);
	// Extract row i from the matrix
	MatInt row(int i);
	// Extract column j from the matrix
	MatInt col(int j);
	// Overload the () operator for element extraction
	int operator()(int i, int j);
	// Overload the assignment operator
	bool operator==(MatInt B);
	MatInt operator=(MatInt B);
	// Overload the equivalency operatro
	void set(unsigned int x, unsigned int y, int value);
	int get(unsigned int x, unsigned int y);
	//returns the biggest coordinate of matrix
	int getLargestCoordinate();
	int getRows();
private:
	unsigned int rows; // Store the number of rows of the matrix
	unsigned int cols; // Store the number of columns of the matrix
	int num_elements; // Store the number of elements in the matrix = rows*cols
	int* data; // This is a pointer to the actual data

};

#endif	/* MATRIXINT_H */