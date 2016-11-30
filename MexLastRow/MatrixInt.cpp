#include "stdafx.h"
# include <stdio.h>
#include "MatrixInt.h"
#include <assert.h>     /* assert */
// Can you guys think of more cool things we might want to do with a matrix?
// We can basically implement ANYTHING!! I want to hear your ideas


//Default Constructor
MatInt::MatInt(int n = 1, int m = 1) {

	rows = n;
	cols = m;
	num_elements = n*m;
	data = new int[num_elements];
	for (int i = 0; i<num_elements; i++) {
		data[i] = 0;
	}

}


// CONSTRUCTOR
MatInt::MatInt(int n, int m, int* input_array) {

	rows = n;
	cols = m;
	num_elements = n*m;
	data = new int[num_elements];
	for (int i = 0; i<num_elements; i++) {
		data[i] = input_array[i];
	}

}

// CONSTRUCTOR
MatInt::MatInt(int n, int m, int value) {

	rows = n;
	cols = m;
	num_elements = n * m;
	data = new int[num_elements];
	for (int i = 0; i<num_elements; i++) {
		data[i] = value;
	}

}

// COPY CONSTRUCTOR
MatInt::MatInt(const MatInt& input_matrix) {

	rows = input_matrix.rows;
	cols = input_matrix.cols;
	num_elements = input_matrix.num_elements;
	data = new int[input_matrix.num_elements];
	for (int k = 0; k < input_matrix.num_elements; k++)
		data[k] = input_matrix.data[k];

}

// DESTRUCTOR
MatInt::~MatInt() {

	delete[] data;

}

// Don't do more work here, just call the constructor defined previously!
MatInt MatInt::zeros(int n, int m) {

	MatInt zero(n, m, 0);
	return zero;

}

// Call another previously defined constructor
MatInt MatInt::eye(int n) {

	MatInt A(n, n);
	for (int i = 0; i < n; i++) {
		int k = i*(n + i);
		A.data[k] = 1;
	}

	// This looked great! I just added this return statement for you (Nathan Crock)
	return A;

}







int MatInt::operator()(int i, int j) {

	return data[(j * rows) + i];

}

bool MatInt::operator==(MatInt B) {

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

MatInt MatInt::operator=(MatInt B) {

	if (B == *this)
		return *this;
	rows = B.rows;
	cols = B.cols;
	num_elements = B.num_elements;
	delete[] data;
	data = new int[B.num_elements];
	for (int k = 0; k <= B.num_elements; k++)
		data[k] = B.data[k];

	return *this;

}


void MatInt::set(unsigned int x, unsigned int y, int value){
	//asserts done separately for better debugging 
	assert(x<rows);
	assert(y<cols);
	data[y*rows + x] = value;
}

int MatInt::get(unsigned int x, unsigned int y){
	//asserts done separately for better debugging 
	assert(x<rows);
	assert(y<cols);
	return data[y*rows + x];
}

int MatInt::getLargestCoordinate(){
	if (rows>cols){ return rows; }
	else{ return cols; }
}

