/**
 *This is the file which is to be used to call windowed segmented LCSS
 *from the C++ files.
 *
 */

#include "mex.h"
#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <vector>
#include "Warping.h"
#include "Matrix.h"

#define printf mexPrintf

using namespace std;


/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

	int acceptedDist;
	double penalty;
	int threshold;
	int seriesSize;
	int templateSize;

    /* check for proper number of arguments */
    if(nrhs!=5) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","Seven inputs required.");
    }
 
    
    /* make sure the first input argument is type double */
    if( !mxIsDouble(prhs[0]) || 
         mxIsComplex(prhs[0])) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notDouble","Input matrix must be type double.");
    }
    
    /* make sure the second input argument is type double */
    if( !mxIsDouble(prhs[1]) || 
         mxIsComplex(prhs[1])) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notDouble","Input matrix must be type double.");
    }
    
    /* check that number of rows in second input argument is 1 */
    //if(mxGetM(prhs[1])!=1) {
    //    mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notRowVector","Input must be a row vector.");
    //}
    
     /* create a pointer to the real data in the series matrix  */
    double *series = mxGetPr(prhs[0]);

	 /* create a pointer to the real data in the template matrix  */
    double *templ = mxGetPr(prhs[1]);
    
    /* get the value of the scalar input  */
    acceptedDist = mxGetScalar(prhs[2]);

	/* get the value of the scalar input  */
    penalty= mxGetScalar(prhs[3]);

	/* get the value of the scalar input  */
    threshold= mxGetScalar(prhs[4]);

	/* get the value of the scalar input  */
	seriesSize = mxGetN(prhs[0]);

	/* get the value of the scalar input  */
    templateSize = mxGetN(prhs[1]);
    
    vector<double> seriesV;
    for (int i = 0; i < seriesSize; i++){
        seriesV.push_back(series[i]);
    }

    printf("The size of Series is %d \n",seriesSize);
    vector<double> templV;
    for (int i = 0; i < templateSize; i++){
        templV.push_back(templ[i]);
    }

    Mat result = spottingWLCS(seriesV, templV, acceptedDist, penalty, threshold);

    for (int i = 0; i < result.getLargestCoordinate(); i++){
		for (int j = 0; j < 2; j++){
			printf(" MatchI: %f ",result(i,j));
		}
		printf("\n");
	}
    
    
}
