#include "stdafx.h"
#include <vector>
#include "Matrix.h"
#include "MatrixInt.h"
#ifndef WARPING_H
#define	WARPING_H

using namespace std;

struct warpingValues{
	//Mat* out;
	vector<double> val;
};

Mat spottingWLCS(vector<double>, vector<double>, int, double, int);
Mat warping(Mat&, MatInt&, MatInt&, int, int, int);
vector<double> getLastRow(vector<double>, vector<double>, int, double, int);
MatInt buildDistMatrix(int, int);
Mat spottingWLCS(vector<double>, vector<double>, int, int, int, MatInt &);
bool checkInside(int, Mat);
int max(int, int);
pair<vector<double>, vector<int>> extrema(vector<double>);
#endif	/* WARPING_H */