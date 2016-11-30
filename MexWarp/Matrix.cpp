#include "stdafx.h"
# include <stdio.h>
#include <iostream>
#include "Matrix.h"
#include <assert.h>     /* assert */

using namespace std;
// Can you guys think of more cool things we might want to do with a matrix?
// We can basically implement ANYTHING!! I want to hear your ideas


//Default Constructor
Mat::Mat(int n = 1, int m = 1) {

	rows = n;
	cols = m;
	num_elements = n*m;
	data = new double[num_elements];
	for (int i = 0; i<num_elements; i++) {
		data[i] = 0.0;
	}

}


// CONSTRUCTOR
Mat::Mat(int n, int m, double* input_array) {

	rows = n;
	cols = m;
	num_elements = n*m;
	data = new double[num_elements];
	for (int i = 0; i<num_elements; i++) {
		data[i] = input_array[i];
	}

}

// CONSTRUCTOR
Mat::Mat(int n, int m, double value) {

	rows = n;
	cols = m;
	num_elements = n * m;
	data = new double[num_elements];
	for (int i = 0; i<num_elements; i++) {
		data[i] = value;
	}

}

// COPY CONSTRUCTOR
Mat::Mat(const Mat& input_matrix) {

	rows = input_matrix.rows;
	cols = input_matrix.cols;
	num_elements = input_matrix.num_elements;
	data = new double[input_matrix.num_elements];
	for (int k = 0; k < input_matrix.num_elements; k++)
		data[k] = input_matrix.data[k];

}

// DESTRUCTOR
Mat::~Mat() {

	delete[] data;

}

// Don't do more work here, just call the constructor defined previously!
Mat Mat::zeros(int n, int m) {

	Mat zero(n, m, 0.0);
	return zero;

}

// Call another previously defined constructor
Mat Mat::eye(int n) {

	Mat A(n, n);
	for (int i = 0; i < n; i++) {
		int k = i*(n + i);
		A.data[k] = 1.0;
	}

	// This looked great! I just added this return statement for you (Nathan Crock)
	return A;

}

Mat Mat::mul(const Mat& B) {

	if (cols == B.rows) {
		Mat C(rows, B.cols);
		int row, col;
		for (int k = 0; k < rows*B.cols; k++) {
			row = k / B.cols;
			col = k % B.cols;
			for (int i = 0; i < cols; i++) {
				C.data[k] += data[row*cols + i] * B.data[col + i*B.cols];
			}
		}
		return C;
	}
	else
		printf("Sorry, your matrices cannot be multiplied.\n");

}







double Mat::operator()(int i, int j) {
	//assert(i<rows);
	assert(j<cols);
	return data[(j * rows) + i];

}

Mat Mat::operator=(Mat B) {

	if (B == *this)
		return *this;
	rows = B.rows;
	cols = B.cols;
	num_elements = B.num_elements;
	delete[] data;
	data = new double[B.num_elements];
	for (int k = 0; k <= B.num_elements; k++)
		data[k] = B.data[k];

	return *this;

}

bool Mat::operator==(Mat B) {

	if (data != B.data)
		return false;
	if (rows != B.rows)
		return false;
	if (cols != B.cols)
		return false;
	if (num_elements != B.num_elements)
		return false;
	return true;

}

void Mat::set(unsigned int x, unsigned int y, double value){
	//asserts done separately for better debugging 
	assert(x<rows);
	assert(y<cols);
	data[y*rows + x] = value;
}



int Mat::getLargestCoordinate(){
	if (rows>cols){ return rows; }
	else{ return cols; }
}

int Mat::getRows(){
	return rows;
}

// Use this to print out small matrices to aid in the testing of these routines
void Mat::show() {

	if (cols == 1) {
		printf("\n");
		for (int k = 0; k<num_elements; k++) {
			printf("| %f |\n", data[k]);
		}
		printf("\n");
	}
	else {
		printf("\n| ");
		for (int k = 0; k<num_elements; k++) {
			printf("%f ", data[k]);
			if ((k + 1) % cols == 0 && k != 0 && k != num_elements - 1)
				printf("|\n| ");
		}
		printf("|\n\n");
	}

}