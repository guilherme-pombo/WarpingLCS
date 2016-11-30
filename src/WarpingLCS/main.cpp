// SegmentedLCSS.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <stdio.h>
#include <vector>
#include <stdlib.h>     /* srand, rand */
#include <math.h>       /* sin */
using namespace std;
#include "Matrix.h"
#include "Warping.h"

int main(int argc, char**argv) {
	int a = -1;
	int b = -1;
	std::cout << "Welcome ..." << std::endl;
	vector<double> series(100);
	vector<double> templ(11);
	int c = 0;
	for (int i = 0; i< series.size(); i++){
		series[i] = rand() %100;
		if (i>20 && i<32){
			series[i] = sin(i);
			templ[c] = sin(i);
			c++;
		}
	}
	Mat r = spottingWLCS(series, templ, 0, 0.5, 9);
	for (int i = 0; i < r.getLargestCoordinate(); i++){
		for (int j = 0; j < 2; j++){
			std::cout << "Match: " << r(i,j);
		}
		std::cout << std::endl;
	}
}


