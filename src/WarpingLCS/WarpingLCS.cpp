// WarpingLCS.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <vector>
#include <iostream>
#include "Matrix.h" //matrix for doubles
#include "MatrixInt.h" //matrix for ints
#include "Warping.h"

using namespace std;


Mat warping(Mat& lcstable, MatInt& prevx, MatInt& prevy, int threshold, int columns, int rows){

	vector<double> lastRow(columns + 1);
	for (int i = 0; i < lastRow.size(); i++){
		lastRow[i] = lcstable(rows, i);
	}
	//pair<vector<double>, vector<int>> ext = extrema(lastRow);
	//vector<double> ymax = ext.first;
	//vector<int> imax = ext.second;
	vector<int> spotidx; //stores all values >= threshold
	for (int i = 0; i < lastRow.size(); i++){
		if (lastRow[i] >= threshold){
			spotidx.push_back(i);
		}
	}
	int i = spotidx.size() - 1; //this will be the while loop iterator
	Mat out(i, 2); //this is a ix2 matrix in the worst case, however if some values are left empty that's alright
	int outIdx = 0;
	vector<double> val;
	while (i >= 1){
		//int stop = imax[spotidx[i]];
		int stop = spotidx[i];
		if (checkInside(stop, out)){
			i--;
			continue;
		}
		int n = stop;
		int m = rows;
		int lcss = 0;
		std::cout << "Reached i: " << i << "\n";
		while (m >= 0 && n > 0){

			int newm = prevx(m, n);
			if (newm == 0){
				break;
			}
			int newn = prevy(m, n);
			if (newm == m - 1 && newn == n - 1){
				lcss++;
			}
			m = newm;
			n = newn;
		}

		int start = n;
		//out = [out; [start stop]];
		out.set(outIdx, 0, start);
		out.set(outIdx, 1, stop);
		outIdx++;
		// val = [val;lcss / max(length(template), (stop - start + 1))];
		val.push_back(lcss / max(rows, (stop - start + 1)));
		i--;
	}
	return out;

}

//This method does pass in the matrix dist as a parameter
//It simply uses a default distance matrix and calls the regular spottingWLCS passing in the created matrix as reference
Mat spottingWLCS(vector<double> series, vector<double> templ, int acceptedDist, double penalty, int threshold){

	int rows = templ.size();
	int columns = series.size();
	if (rows == 0 || columns == 0){
		Mat a(1, 1); //return 0
		return a;
	}
	else{
		Mat lcstable(rows + 1, columns + 1, 0.0);
		MatInt prevx(rows + 1, columns + 1, 0);
		MatInt prevy(rows + 1, columns + 1, 0);
		//template = [template(1) template];
		//series = [series(1) series];
		templ.insert(templ.begin(), templ[0]);
		series.insert(series.begin(), series[0]);
		std::cout << "A:  " << templ[0] << " B: " << templ[1] << std::endl;
		std::cout << "A:  " << series[0] << " B: " << series[1] << std::endl;
		for (int i = 0; i < rows; i++){
			for (int j = 0; j < columns; j++){
				if (j == columns - 1){
					std::cout << "Reached j: " << j << " Reached i: " << i << std::endl;
				}
				if (abs(templ[i + 1] - series[j + 1]) <= acceptedDist){
					lcstable.set(i + 1, j + 1, (lcstable(i, j) + 1));
					prevx.set(i + 1, j + 1, i);
					prevy.set(i + 1, j + 1, j);
				}

				else{
					double p1 = lcstable(i, j) - abs(templ[i + 1] - series[j + 1]) * penalty;
					double p2 = lcstable(i, j + 1) - abs(templ[i] - templ[i + 1]) * penalty;
					double p3 = lcstable(i + 1, j) - abs(series[j] - series[j + 1]) * penalty;
					int pos = 1;
					double x = p1;
					if (p2 > p1 && p2 > p3){
						x = p2;
						pos = 2;
					}
					if (p3 > p1 && p3 > p2){
						x = p3;
						pos = 3;
					}
					lcstable.set(i + 1, j + 1, x);
					if (pos == 1){
						prevx.set(i + 1, j + 1, i);
						prevy.set(i + 1, j + 1, j);
					}
					else if (pos == 2){
						prevx.set(i + 1, j + 1, i);
						prevy.set(i + 1, j + 1, j + 1);
					}
					else{
						prevx.set(i + 1, j + 1, i + 1);
						prevy.set(i + 1, j + 1, j);
					}
				}
			}
		}

		Mat out = warping(lcstable, prevx, prevy, threshold, columns, rows);
		return out;
	}
}

vector<double> getLastRow(vector<double> series, vector<double> templ, int acceptedDist, double penalty, int threshold){

	int rows = templ.size();
	int columns = series.size();
	if (rows == 0 || columns == 0){
		vector<double> a(0);
		return a;
	}
	else{
		Mat lcstable(rows + 1, columns + 1, 0.0);
		MatInt prevx(rows + 1, columns + 1, 0);
		MatInt prevy(rows + 1, columns + 1, 0);
		//template = [template(1) template];
		//series = [series(1) series];
		templ.insert(templ.begin(), templ[0]);
		series.insert(series.begin(), series[0]);
		std::cout << "A:  " << templ[0] << " B: " << templ[1] << std::endl;
		std::cout << "A:  " << series[0] << " B: " << series[1] << std::endl;
		for (int i = 0; i < rows; i++){
			for (int j = 0; j < columns; j++){
				if (j == columns - 1){
					std::cout << "Reached j: " << j << " Reached i: " << i << std::endl;
				}
				if (abs(templ[i + 1] - series[j + 1]) <= acceptedDist){
					lcstable.set(i + 1, j + 1, (lcstable(i, j) + 1));
					prevx.set(i + 1, j + 1, i);
					prevy.set(i + 1, j + 1, j);
				}

				else{
					double p1 = lcstable(i, j) - abs(templ[i + 1] - series[j + 1]) * penalty;
					double p2 = lcstable(i, j + 1) - abs(templ[i] - templ[i + 1]) * penalty;
					double p3 = lcstable(i + 1, j) - abs(series[j] - series[j + 1]) * penalty;
					int pos = 1;
					double x = p1;
					if (p2 > p1 && p2 > p3){
						x = p2;
						pos = 2;
					}
					if (p3 > p1 && p3 > p2){
						x = p3;
						pos = 3;
					}
					lcstable.set(i + 1, j + 1, x);
					if (pos == 1){
						prevx.set(i + 1, j + 1, i);
						prevy.set(i + 1, j + 1, j);
					}
					else if (pos == 2){
						prevx.set(i + 1, j + 1, i);
						prevy.set(i + 1, j + 1, j + 1);
					}
					else{
						prevx.set(i + 1, j + 1, i + 1);
						prevy.set(i + 1, j + 1, j);
					}
				}
			}
		}
		vector<double> lastRow(columns + 1);
		for (int i = 0; i < lastRow.size(); i++){
			lastRow[i] = lcstable(rows, i);
		}
		return lastRow;
	}
}

//This function builds a distance Matrix that is to be used when calling spottingWLCS with quantized data
//It is recommended to use k-means (k=20 usually) for quantizing the data
MatInt buildDistMatrix(int seriesSize, int templateSize){
	//The Matrix looks like
	//0-1-2
	//1-0-1
	//2-1-0
	MatInt dist(templateSize, seriesSize);
	int diagonalIdx = 0; //keeps track of the diagonal's index
	for (int i = 0; i < seriesSize; i++){
		for (int j = 0; j < templateSize; j++){
			if (j == diagonalIdx){
				dist.set(i, j, 0);
			}
			else{
				dist.set(i, j, abs(j-diagonalIdx)); //the value is the absolute distance between the column and diagonalIdx
			}
		}
		diagonalIdx++; //go down one row, increment the diagonal index
	}
	return dist;
}


/*
warpingValues spottingWLCS(vector<double> templ, vector<double> series, int acceptedDist, int penalty, int threshold, Mat dist){

	Mat lcstable(templ.size+1, series.size+1,0);
	Mat prevx(templ.size + 1, series.size + 1, 0);
	Mat prevy(templ.size + 1, series.size + 1, 0);

	for (int i = 1; i < templ.size; i++){
		for (int j = 1; i < series.size; j++){
			if (dist.get(templ[i + 1], series[j + 1]) <= acceptedDist){
				lcstable.set(i + 1, j + 1, lcstable(i, j) + 1);
				prevx.set(i + 1, j + 1, i);
				prevy.set(i + 1, j + 1, j);
			}
			else{
				int p1 = lcstable.get(i, j) - dist.get(templ[i + 1], series[j + 1]) * penalty;
				int p2 = lcstable.get(i, j + 1) - dist.get(templ[i], templ[i + 1]) * penalty;
				int p3 = lcstable.get(i + 1, j) - dist.get(series[j], series[j + 1]) * penalty;
				int x = 0;
				int pos = 0;
				//[x,pos] = max(p1,p2,p3)
				if (p1 >= p2 && p1 >= p3){ x = p1; pos = 1; }
				else if (p2 >= p1 && p2 >= p3){ x = p2; pos = 2; }
				else if (p3 >= p1 && p3 >= p1){ x = p3; pos = 3; }
				lcstable.set(i + 1, j + 1, x);
				if (pos == 1){
					prevx.set(i + 1, j + 1, i);
					prevy.set(i + 1, j + 1, j);
				}
				else if (pos == 2){
					prevx.set(i + 1, j + 1, i);
					prevy.set(i + 1, j + 1, j + 1);
				}
				else{
					prevx.set(i + 1, j + 1, i + 1);
					prevy.set(i + 1, j + 1, j);
				}
			}
		}
	}
	warpingValues toReturn;
	toReturn.table = lcstable;
	toReturn.prevx = prevx;
	toReturn.prevy = prevy;
	return toReturn;
}
*/
bool checkInside(int index, Mat matrix){

	bool inside = false;
	for (int i = 0; i < matrix.getRows(); i++){
		double start = matrix(i, 0);
		double stop = matrix(i, 1);
		if (index <= stop && index >= start){
			inside = true;
			break;
		}
	}
	return inside;	
}

int max(int i, int j){
	if (i > j){ return i; }
	else{ return j; }
}

/*
pair<vector<double>, vector<int>> extrema(vector<double> vec){
	vector<double> dx(vec.size() - 1);
	for (int i = 0; i < dx.size(); i++){
		dx[i] = vec[i + 1] - vec[i];
	}
	//find indices of nonzeroes
	vector<int> a;
	for (int i = 0; i < dx.size(); i++){
		if (dx[i] != 0){
			a.push_back(i);
		}
	}
	vector<int> diffa(a.size() - 1);
	for (int i = 0; i < diffa.size(); i++){
		diffa[i] = a[i + 1] - a[i];
	}
	//find indices where there is no change
	vector<int> lm;
	for (int i = 0; i < diffa.size(); i++){
		if (diffa[i] != 1){
			lm.push_back(i + 1);
		}
	}
	//number of elements in flat peak
	vector<int> d;
	for (int i = 0; i < lm.size(); i++){
		d.push_back(a[lm[i]] - a[lm[i] - 1]);
	}

	//save middle elements
	for (int i = 0; i < lm.size(); i++){
		a[lm[i]] = a[lm[i]] - d[i] / 2;
	}
	a.push_back(vec.size() - 1);

	vector<int> xa;
	for(int i = 0; i < a.size(); i++){
		xa.push_back(vec[a[i]]);
	}

	vector<int> diffxa(xa.size() - 1);
	for (int i = 0; i < diffxa.size(); i++){
		diffxa[i] = xa[i + 1] - xa[i];
	}

	//b = (diff(xa) > 0);
	vector<int> b;
	for (int i = 0; i < diffxa.size(); i++){
		if (diffxa[i]>0){
			b.push_back(i);
		}
	}

	//xb  = diff(b);

	vector<int> xb(b.size() - 1);
	for (int i = 0; i < xb.size(); i++){
		xb[i] = b[i + 1] - b[i];
		//std::cout << "xb ..." << xb[i] <<std::endl;
	}

	//imax = find(xb == -1) + 1; % maxima indexes
	//imin = find(xb == +1) + 1; % minima indexes
	vector<int> imax;
	vector<int> imin;
	for (int i = 0; i < xb.size() - 1; i++){
		if (xb[i] == -1){
			imax.push_back(i + 1);
		}
		if (xb[i] == 1){
			imin.push_back(i + 1);
		}
	}

	for (int i = 0; i < imax.size(); i++){
		imax[i] = a[imax[i]];
	}

	for (int i = 0; i < imin.size(); i++){
		imin[i] = a[imin[i]];
	}

	int nmaxi = imax.size();
	int nmini = imin.size();

	if (nmaxi == 0 && nmini == 0){
		vector<double> max;
		vector<int> idx;
		if (vec[0]>vec[vec.size() - 1]){
			double xmax = vec[0];
			int imax = 0;
			int xmin = vec[vec.size() - 1];
			int imin = vec.size() - 1;
			max.push_back(xmax);
			idx.push_back(imax);
		}
		else if (vec[0]<vec[vec.size() - 1]){
			int xmin = vec[0];
			int imin = 0;
			double xmax = vec[vec.size() - 1];
			int imax = vec.size() - 1;
			max.push_back(xmax);
			idx.push_back(imax);
		}
		pair<vector<double>, vector<int>> toReturn;
		toReturn = make_pair(max, idx);
		return toReturn;
	}
	if (nmaxi == 0){
		imax.push_back(0);
		imax.push_back(vec.size() - 1);
	}
	else if (nmini == 0){
		imin.push_back(0);
		imin.push_back(vec.size() - 1);
	}
	else{
		if (imax[0] < imin[0]){
			imin.insert(imin.begin() + 0, 0);
			imin[0] = 0;
		}
		else{
			imax.insert(imin.begin() + 0, 0);
		}
		if (imax[imax.size() - 1]>imax[imax.size() - 1]){
			imin.push_back(vec.size() - 1);
		}
		else{
			imax.push_back(vec.size() - 1);
		}
	}
	vector<double> xmax;
	vector<double> xmin;
	for (int i = 0; i < imax.size() - 1; i++){
		xmax.push_back(vec[imax[i]]);
	}
	for (int i = 0; i < imin.size() - 1; i++){
		xmin.push_back(vec[imin[i]]);
	}
	pair<vector<double>, vector<int>> toReturn;
	toReturn = make_pair(xmax, imax);
	return toReturn;
}

*/

