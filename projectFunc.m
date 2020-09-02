classdef projectFunc
    methods(Static)
   
        function mean=computeMean(struct)
            mean=0;
            M=size(struct.data,2);
            if (M>0)%sruct is not empty
                N=size(struct.data{1},1);
                mean=zeros(N);
                for i=1:M
                   mean=mean +(1/M)*(im2single(struct.data{i}));
                end 
            end
        end
        
        
        function result=searchImage(testImage,eigenfaces,xci,avgImage,numberOfImages,numOfEigenVecs,dataSetEigens)
             testImage   =  im2single(testImage);
             typicalFeatures = testImage(:)-avgImage(:);
            % wface=zeros(numOfEigenVecs);
             for i=1:numOfEigenVecs
                testface(i)  =  sum(typicalFeatures.* eigenfaces{xci(i)}(:)) ;
             end
             %finalWeights=zeros(numberOfImages);
             for i=1:numberOfImages 
                sumcur=0;
                for j=1:numOfEigenVecs
                 sumcur = sumcur + (testface(j) -dataSetEigens(i,j)).^2;
                end
                finalWeights(i) =   sqrt( sumcur);
             end
             finalWeights=finalWeights.';     %%transpose of diff
             min=finalWeights(1);
             result=1;
             for i=2:numberOfImages
                 if(finalWeights(i)<min)
                    result=i;
                    min=finalWeights(i);
                 end
             end
             if(finalWeights(result)>20)
                 result=-1;
             end
             
        end
         
         function [eigenfaces,order,avgImg,numOfImages,selectedEigVecs,weightedImage]= getInputEigenFaces(struct)
             numOfImages=size(struct.names,2);
             avgImg=projectFunc.computeMean(struct);
             redDimensions=50;
             
             %% normalize (remove average image)
            for k=1:numOfImages
                struct.data{k} = im2single(struct.data{k});
                struct.dataAvg{k}  = struct.data{k} -avgImg;
            end
            
            %% generate A = [ img1(:)  img2(:) ...  imgM(:) ];
            A = zeros(redDimensions*redDimensions,numOfImages);% (N*N)*M   2500*4
            for k=1:numOfImages
                 A(:,k) = struct.dataAvg{k}(:);
            end 
            % covariance matrix small dimension (transposed)
            
            cov = A'*A;
            %% eigen vectros  in small dimension
            [eigVec,diagEigenValues ]  = eig(cov);% v M*M e M*M only diagonal 4 eigen values
            vLarge = A*eigVec;% 2500*M*M*M  =2500 *M
            eigenfaces=[];
            for k=1:numOfImages
                c  = vLarge(:,k);
                eigenfaces{k} = reshape(c,redDimensions,redDimensions);
            end
            
            diagVec=diag(diagEigenValues);    %transforming diagonal values into single vector
            [inputEigenValues,order]=sort(diagVec,'descend');% largest eigenval
            selectedEigVecs=size(order,1)-1;
            for mi=1:numOfImages  % image number
                for k=1:selectedEigVecs   % eigen face for coeff number
                    weightedImage(mi,k) =   sum(A(:,mi).* eigenfaces{order(k)}(:)) ;
                end
            end
            
            
            
            
             
             
         end
             
             
             
    end
    
end
    
    